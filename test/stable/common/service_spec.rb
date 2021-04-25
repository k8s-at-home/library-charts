# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')

  describe @@chart.name do
    describe 'service::ports settings' do
      default_name = 'http'
      default_port = 8080

      it 'defaults to name "http" on port 8080' do
        service = chart.resources(kind: "Service").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(service)
        assert_equal(default_port, service["spec"]["ports"].first["port"])
        assert_equal(default_name, service["spec"]["ports"].first["targetPort"])
        assert_equal(default_name, service["spec"]["ports"].first["name"])

        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(default_port, mainContainer["ports"].first["containerPort"])
        assert_equal(default_name, mainContainer["ports"].first["name"])
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
        service = chart.resources(kind: "Service").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(service)
        assert_equal(default_port, service["spec"]["ports"].first["port"])
        assert_equal(values[:service][:port][:name], service["spec"]["ports"].first["targetPort"])
        assert_equal(values[:service][:port][:name], service["spec"]["ports"].first["name"])

        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(default_port, mainContainer["ports"].first["containerPort"])
        assert_equal(values[:service][:port][:name], mainContainer["ports"].first["name"])
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
        service = chart.resources(kind: "Service").find{ |s| s["metadata"]["name"] == "common-test" }
        refute_nil(service)
        assert_equal(default_port, service["spec"]["ports"].first["port"])
        assert_equal(values[:service][:port][:targetPort], service["spec"]["ports"].first["targetPort"])
        assert_equal(default_name, service["spec"]["ports"].first["name"])

        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:service][:port][:targetPort], mainContainer["ports"].first["containerPort"])
        assert_equal(default_name, mainContainer["ports"].first["name"])
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
