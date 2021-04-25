# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')

  describe @@chart.name do
    describe 'ingress' do
      it 'disabled when ingress.enabled: false' do
        values = {
          ingress: {
            enabled: false
          }
        }
        chart.value values
        assert_nil(resource('Ingress'))
      end

      it 'enabled when ingress.enabled: true' do
        values = {
          ingress: {
            enabled: true
          }
        }

        chart.value values
        refute_nil(resource('Ingress'))
      end

      it 'tls can be provided' do
        expectedPath = 'common-test.path'
        values = {
          ingress: {
            tls: [
              {
                hosts: [ 'hostname' ],
                secretName: 'secret-name'
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(values[:ingress][:tls][0][:hosts][0], ingress["spec"]["tls"][0]["hosts"][0])
        assert_equal(values[:ingress][:tls][0][:secretName], ingress["spec"]["tls"][0]["secretName"])
      end

      it 'tls secret can be left empty' do
        expectedPath = 'common-test.path'
        values = {
          ingress: {
            tls: [
              {
                hosts: [ 'hostname' ]
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(values[:ingress][:tls][0][:hosts][0], ingress["spec"]["tls"][0]["hosts"][0])
        assert_equal(false, ingress["spec"]["tls"][0].key?("secretName"))
        assert_nil(ingress["spec"]["tls"][0]["secretName"])
      end

      it 'tls secret template can be provided' do
        expectedPath = 'common-test.path'
        values = {
          ingress: {
            tls: [
              {
                secretNameTpl: '{{ .Release.Name }}-secret'
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal('common-test-secret', ingress["spec"]["tls"][0]["secretName"])
      end

      it 'path template can be provided' do
        expectedPath = 'common-test.path'
        values = {
          ingress: {
            hosts: [
              {
                paths: [
                  {
                    pathTpl: '{{ .Release.Name }}.path'
                  }
                ]
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(expectedPath, ingress["spec"]["rules"][0]["http"]["paths"][0]["path"])
      end

      it 'hosts can be provided' do
        values = {
          ingress: {
            hosts: [
              {
                host: 'hostname'
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(values[:ingress][:hosts][0][:host], ingress["spec"]["rules"][0]["host"])
      end

      it 'hosts template can be provided' do
        expectedHostName = 'common-test.hostname'
        values = {
          ingress: {
            hosts: [
              {
                hostTpl: '{{ .Release.Name }}.hostname'
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(expectedHostName, ingress["spec"]["rules"][0]["host"])
      end
    end
  end
end
