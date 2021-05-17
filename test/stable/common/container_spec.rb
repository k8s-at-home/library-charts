# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')

  describe @@chart.name do
    describe 'container::persistence' do
      it 'supports multiple volumeMounts' do
        values = {
          persistence: {
              cache: {
                enabled: true,
                emptyDir: {
                  enabled: true
                }
              },
              config: {
                enabled: true,
                existingClaim: "configClaim"
              },
              data: {
                enabled: true,
                existingClaim: "dataClaim"
              }
            }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        # Check that all persistent volumes have mounts
        values[:persistence].each { |key, value|
          volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == key.to_s }
          refute_nil(volumeMount)
        }
      end

      it 'defaults mountPath to persistence key' do
        values = {
          persistence: {
              data: {
                enabled: true,
                existingClaim: "dataClaim"
              }
            }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == "data" }
        refute_nil(volumeMount)
        assert_equal("/data", volumeMount["mountPath"])
      end

      it 'supports setting custom mountPath' do
        values = {
          persistence: {
              data: {
                enabled: true,
                existingClaim: "dataClaim",
                mountPath: "/myMountPath"
              }
            }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == "data" }
        refute_nil(volumeMount)
        assert_equal("/myMountPath", volumeMount["mountPath"])
      end

      it 'supports setting subPath' do
        values = {
          persistence: {
              data: {
                enabled: true,
                existingClaim: "dataClaim",
                subPath: "mySubPath"
              }
            }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == "data" }
        refute_nil(volumeMount)
        assert_equal("mySubPath", volumeMount["subPath"])
      end
    end

    describe 'container::hostPathMounts' do
      it 'supports multiple hostPathMounts' do
        values = {
          hostPathMounts: [
          {
                name: "data",
                enabled: true,
                mountPath: "/data",
                hostPath: "/tmp"
          },
          {
                name: "config",
                enabled: true,
                mountPath: "/config",
                hostPath: "/tmp"
          }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        # Check that all hostPathMounts volumes have mounts
        values[:hostPathMounts].each { |value|
          volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == "hostpathmounts-" + value[:name].to_s }
          refute_nil(volumeMount)
        }
      end

      it 'supports setting mountPath' do
        values = {
          hostPathMounts: [
          {
                name: "data",
                enabled: true,
                mountPath: "/data",
                hostPath: "/tmp"
          }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == "hostpathmounts-data" }
        refute_nil(volumeMount)
        assert_equal("/data", volumeMount["mountPath"])
      end

      it 'supports setting subPath' do
        values = {
          hostPathMounts: [
          {
                name: "data",
                enabled: true,
                mountPath: "/data",
                hostPath: "/tmp",
                subPath: "mySubPath"
          }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }

        volumeMount = mainContainer["volumeMounts"].find{ |v| v["name"] == "hostpathmounts-data" }
        refute_nil(volumeMount)
        assert_equal("mySubPath", volumeMount["subPath"])
      end
    end
  end
end
