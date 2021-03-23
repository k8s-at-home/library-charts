# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'container::command' do
      it 'defaults to nil' do
        assert_nil(resource('Deployment')['spec']['template']['spec']['containers'][0]['command'])
      end

      it 'accepts a single string' do
        values = {
          command: "/bin/sh"
        }
        chart.value values
        jq('.spec.template.spec.containers[0].command', resource('Deployment')).must_equal values[:command]
      end

      it 'accepts a list of strings' do
        values = {
          command: [
            "/bin/sh",
            "-c"
          ]
        }
        chart.value values
        jq('.spec.template.spec.containers[0].command', resource('Deployment')).must_equal values[:command]
      end
    end

    describe 'container::arguments' do
      it 'defaults to nil' do
        assert_nil(resource('Deployment')['spec']['template']['spec']['containers'][0]['args'])
      end

      it 'accepts a single string' do
        values = {
          args: "sleep infinity"
        }
        chart.value values
        jq('.spec.template.spec.containers[0].args', resource('Deployment')).must_equal values[:args]
      end

      it 'accepts a list of strings' do
        values = {
          args: [
            "sleep",
            "infinity"
          ]
        }
        chart.value values
        jq('.spec.template.spec.containers[0].args', resource('Deployment')).must_equal values[:args]
      end
    end

    describe 'container::environment settings' do
      it 'Check no environment variables' do
        values = {}
        chart.value values        
        assert_nil(resource('Deployment')['spec']['template']['spec']['containers'][0]['env'])
      end

      it 'set "static" environment variables' do
        values = {
          env: {
            STATIC_ENV: 'value_of_env'
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal values[:env].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal values[:env].values[0].to_s
      end

      it 'set "valueFrom" environment variables' do
        values = {
          envValueFrom: {
            NODE_NAME: {
              fieldRef: {
                fieldPath: "spec.nodeName"
              }
            }
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal values[:envValueFrom].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[0].valueFrom | keys[0]', resource('Deployment')).must_equal values[:envValueFrom].values[0].keys[0].to_s
      end

      it 'set "static" and "Dynamic/Tpl" environment variables' do
        values = {
          env: {
            STATIC_ENV: 'value_of_env'
          },
          envTpl: {
            DYN_ENV: "{{ .Release.Name }}-admin"
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal values[:env].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal values[:env].values[0].to_s
        jq('.spec.template.spec.containers[0].env[1].name', resource('Deployment')).must_equal values[:envTpl].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[1].value', resource('Deployment')).must_equal 'common-test-admin'
      end
      
      it 'set "Dynamic/Tpl" environment variables' do
        values = {
          envTpl: {
            DYN_ENV: "{{ .Release.Name }}-admin"
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal values[:envTpl].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal 'common-test-admin'
      end
      
      it 'set "static" secret variables' do
        expectedSecretName = 'common-test'
        values = {
          secret: {
            STATIC_SECRET: 'value_of_secret'
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].envFrom[0].secretRef.name', resource('Deployment')).must_equal expectedSecretName
        jq('.metadata.name', resource('Secret')).must_equal expectedSecretName
        jq('.stringData.STATIC_SECRET', resource('Secret')).must_equal values[:secret].values[0].to_s
      end
    end
  end
end
