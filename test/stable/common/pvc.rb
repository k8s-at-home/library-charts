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
        pvc = chart.resources(kind: "PersistentVolumeClaim").find{ |s| s["metadata"]["name"] == "common-test-config" }
        refute_nil(pvc)
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
        pvc = chart.resources(kind: "PersistentVolumeClaim").find{ |s| s["metadata"]["name"] == "common-test-customSuffix" }
        refute_nil(pvc)
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
        pvc = chart.resources(kind: "PersistentVolumeClaim").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(pvc)
      end
    end
  end
end
