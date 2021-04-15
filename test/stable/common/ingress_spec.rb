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

      it 'with path template is evaluated' do
        expectedPath = 'common-test.path'
        values = {
          ingress: {
            hosts: [
              {
                host: 'hostname',
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
        assert_equal(values[:ingress][:hosts][0][:host], ingress["spec"]["rules"][0]["host"])
        assert_equal(expectedPath, ingress["spec"]["rules"][0]["http"]["paths"][0]["path"])
      end

      it 'with hosts' do
        values = {
          ingress: {
            hosts: [
              {
                host: 'hostname',
                paths: [
                  {
                    path: '/'
                  }
                ]
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(values[:ingress][:hosts][0][:paths][0][:path], ingress["spec"]["rules"][0]["http"]["paths"][0]["path"])
      end

      it 'with hosts template is evaluated' do
        expectedHostName = 'common-test.hostname'
        values = {
          ingress: {
            hosts: [
              {
                hostTpl: '{{ .Release.Name }}.hostname',
                paths: [
                  {
                    path: '/'
                  }
                ]
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(expectedHostName, ingress["spec"]["rules"][0]["host"])
      end

      it 'with hosts and tls' do
        values = {
          ingress: {
            enabled: true,
            hosts: [
              {
                host: 'hostname',
                paths: [
                  {
                    path: '/'
                  }
                ]
              }
            ],
            tls: [
              {
                hosts: [ 'hostname' ],
                secretName: 'hostname-secret-name'
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(values[:ingress][:hosts][0][:host], ingress["spec"]["rules"][0]["host"])
        assert_equal(values[:ingress][:hosts][0][:paths][0][:path], ingress["spec"]["rules"][0]["http"]["paths"][0]["path"])
        assert_equal(values[:ingress][:tls][0][:hosts][0], ingress["spec"]["tls"][0]["hosts"][0])
        assert_equal(values[:ingress][:tls][0][:secretName], ingress["spec"]["tls"][0]["secretName"])
      end

      it 'with hosts and tls templates is evaluated' do
        expectedHostName = 'common-test.hostname'
        expectedPath = '/common-test'
        expectedSecretName = 'common-test-hostname-secret-name'
        values = {
          ingress: {
            enabled: true,
            hosts: [
              {
                hostTpl: '{{ .Release.Name }}.hostname',
                paths: [
                  {
                    pathTpl: '/{{ .Release.Name }}'
                  }
                ]
              }
            ],
            tls: [
              {
                hostsTpl: [ '{{ .Release.Name }}.hostname' ],
                secretNameTpl: '{{ .Release.Name }}-hostname-secret-name'
              }
            ]
          }
        }

        chart.value values
        ingress = chart.resources(kind: "Ingress").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(ingress)
        assert_equal(expectedHostName, ingress["spec"]["rules"][0]["host"])
        assert_equal(expectedPath, ingress["spec"]["rules"][0]["http"]["paths"][0]["path"])
        assert_equal(expectedHostName, ingress["spec"]["tls"][0]["hosts"][0])
        assert_equal(expectedSecretName, ingress["spec"]["tls"][0]["secretName"])
      end
    end
  end
end
