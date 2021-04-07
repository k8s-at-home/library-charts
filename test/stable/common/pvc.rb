# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'pvc' do
      it 'nameSuffix defaults to persistence key' do
        values = {
          persistence: {
            config: {
              enabled: true
            }
          }
        }
        chart.value values
        jq('.metadata.name', resource('PersistentVolumeClaim')).must_equal 'common-test-config'
      end

      it 'nameSuffix can be overridden' do
        values = {
          persistence: {
            config: {
              enabled: true,
              nameSuffix: 'customSuffix'
            }
          }
        }
        chart.value values
        jq('.metadata.name', resource('PersistentVolumeClaim')).must_equal 'common-test-customSuffix'
      end

      it 'nameSuffix can be skipped' do
        values = {
          persistence: {
            config: {
              enabled: true,
              nameSuffix: '-'
            }
          }
        }
        chart.value values
        jq('.metadata.name', resource('PersistentVolumeClaim')).must_equal 'common-test'
      end
    end
  end
end
