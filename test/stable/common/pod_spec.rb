# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'pod::replicas' do
      it 'defaults to 1' do
        jq('.spec.replicas', resource('Deployment')).must_equal 1
      end
  
      it 'accepts integer as value' do
        chart.value replicas: 3
        jq('.spec.replicas', resource('Deployment')).must_equal 3
      end
    end

    describe 'pod::additional containers' do
      it 'accepts static additionalContainers' do
        values = {
          additionalContainers: [
            {
              name: "template-test"
            }
          ]
        }
        chart.value values
        jq('.spec.template.spec.containers[1].name', resource('Deployment')).must_equal 'template-test'
      end

      it 'accepts "Dynamic/Tpl" additionalContainers' do
        values = {
          additionalContainers: [
            {
              name: "{{ .Release.Name }}-container",
            }
          ]
        }
        chart.value values
        jq('.spec.template.spec.containers[1].name', resource('Deployment')).must_equal 'common-test-container'
      end
    end

    describe 'pod::persistence::emptyDir' do
      it 'can be configured' do
        values = {
          persistence: {
              config: {
                enabled: true,
                emptyDir: {
                  enabled: true
                }
              }
            }
        }
        chart.value values
        jq('.spec.template.spec.volumes[0].name', resource('Deployment')).must_equal 'config'
        jq('.spec.template.spec.volumes[0].emptyDir', resource('Deployment')).must_equal Hash.new
      end

      it 'medium can be configured' do
        values = {
          persistence: {
              config: {
                enabled: true,
                emptyDir: {
                  enabled: true,
                  medium: "memory"
                }
              }
            }
        }
        chart.value values
        jq('.spec.template.spec.volumes[0].name', resource('Deployment')).must_equal 'config'
        jq('.spec.template.spec.volumes[0].emptyDir.medium', resource('Deployment')).must_equal "memory"
      end

      it 'sizeLimit can be configured' do
        values = {
          persistence: {
              config: {
                enabled: true,
                emptyDir: {
                  enabled: true,
                  medium: "memory",
                  sizeLimit: "1Gi"
                }
              }
            }
        }
        chart.value values
        jq('.spec.template.spec.volumes[0].name', resource('Deployment')).must_equal 'config'
        jq('.spec.template.spec.volumes[0].emptyDir.sizeLimit', resource('Deployment')).must_equal "1Gi"
      end
  
    end
  end
end
