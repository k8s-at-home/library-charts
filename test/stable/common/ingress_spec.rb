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
        jq('.spec.rules[0].host', resource('Ingress')).must_equal values[:ingress][:hosts][0][:host]
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal expectedPath
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
        jq('.spec.rules[0].host', resource('Ingress')).must_equal values[:ingress][:hosts][0][:host]
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:hosts][0][:paths][0][:path]
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
        jq('.spec.rules[0].host', resource('Ingress')).must_equal expectedHostName
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:hosts][0][:paths][0][:path]
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
        jq('.spec.rules[0].host', resource('Ingress')).must_equal values[:ingress][:hosts][0][:host]
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:hosts][0][:paths][0][:path]
        jq('.spec.tls[0].hosts[0]', resource('Ingress')).must_equal values[:ingress][:tls][0][:hosts][0]
        jq('.spec.tls[0].secretName', resource('Ingress')).must_equal values[:ingress][:tls][0][:secretName]
      end

      it 'with hosts and tls templates is evaluated' do
        expectedHostName = 'common-test.hostname'
        expectedSecretName = 'common-test-hostname-secret-name'
        values = {
          ingress: {
            enabled: true,
            hosts: [
              {
                hostTpl: '{{ .Release.Name }}.hostname',
                paths: [
                  {
                    path: '/'
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
        jq('.spec.rules[0].host', resource('Ingress')).must_equal expectedHostName
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:hosts][0][:paths][0][:path]
        jq('.spec.tls[0].hosts[0]', resource('Ingress')).must_equal expectedHostName
        jq('.spec.tls[0].secretName', resource('Ingress')).must_equal expectedSecretName
      end
    end
  end
end
