# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'service::ports settings' do
      default_name = 'http'
      default_port = 8080

      it 'defaults to name "http" on port 8080' do
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal default_name
        jq('.spec.ports[0].name', resource('Service')).must_equal default_name
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal default_port
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal default_name
      end
  
      it 'port name can be overridden' do
        values = {
          service: {
            port: {
              name: 'server'
            }
          }
        }
        chart.value values
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal values[:service][:port][:name]
        jq('.spec.ports[0].name', resource('Service')).must_equal values[:service][:port][:name]
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal default_port
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal values[:service][:port][:name]
      end

      it 'targetPort can be overridden' do
        values = {
          service: {
            port: {
              targetPort: 80
            }
          }
        }
        chart.value values
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal values[:service][:port][:targetPort]
        jq('.spec.ports[0].name', resource('Service')).must_equal default_name
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal values[:service][:port][:targetPort]
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal default_name
      end

      it 'targetPort cannot be a named port' do
        values = {
          service: {
            port: {
              targetPort: 'test'
            }
          }
        }
        chart.value values
        exception = assert_raises HelmCompileError do
          chart.execute_helm_template!
        end
        assert_match("Our charts do not support named ports for targetPort. (port name #{default_name}, targetPort #{values[:service][:port][:targetPort]})", exception.message)
      end
    end
  end
end
