# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'pod replicas' do
      it 'defaults to 1' do
        jq('.spec.replicas', resource('Deployment')).must_equal 1
      end
  
      it 'accepts integer as value' do
        chart.value replicas: 3
        jq('.spec.replicas', resource('Deployment')).must_equal 3
      end
    end

    describe 'additional containers' do
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
  end
end
