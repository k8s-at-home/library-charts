# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')

  describe @@chart.name do
    describe 'pod::persistence' do
      it 'multiple volumes' do
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
              existingClaim: "configClaim",
              emptyDir: {
                enabled: false
              }
            },
            data: {
              enabled: true,
              existingClaim: "dataClaim"
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]

        volume = volumes.find{ |v| v["name"] == "cache"}
        refute_nil(volume)

        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal('configClaim', volume["persistentVolumeClaim"]["claimName"])

        volume = volumes.find{ |v| v["name"] == "data"}
        refute_nil(volume)
        assert_equal('dataClaim', volume["persistentVolumeClaim"]["claimName"])
      end

      it 'default nameSuffix' do
        values = {
          persistence: {
            config: {
              enabled: true,
              emptyDir: {
                enabled: false
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal('common-test-config', volume["persistentVolumeClaim"]["claimName"])
      end

      it 'custom nameSuffix' do
        values = {
          persistence: {
            config: {
              enabled: true,
              nameOverride: "test",
              emptyDir: {
                enabled: false
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal('common-test-test', volume["persistentVolumeClaim"]["claimName"])
      end

      it 'no nameSuffix' do
        values = {
          persistence: {
            config: {
              enabled: true,
              nameOverride: "-",
              emptyDir: {
                enabled: false
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal('common-test', volume["persistentVolumeClaim"]["claimName"])
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
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal(Hash.new, volume["emptyDir"])
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
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal("memory", volume["emptyDir"]["medium"])
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
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "config"}
        refute_nil(volume)
        assert_equal("1Gi", volume["emptyDir"]["sizeLimit"])
      end
    end

    describe 'pod::hostPathMounts' do
      it 'multiple volumes' do
        values = {
          hostPathMounts: [
            {
              name: "data",
              enabled: true,
              mountPath: "/data",
              hostPath: "/tmp1"
            },
            {
              name: "config",
              enabled: true,
              mountPath: "/config",
              hostPath: "/tmp2"
            }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]

        volume = volumes.find{ |v| v["name"] == "hostpathmounts-data"}
        refute_nil(volume)
        assert_equal('/tmp1', volume["hostPath"]["path"])

        volume = volumes.find{ |v| v["name"] == "hostpathmounts-config"}
        refute_nil(volume)
        assert_equal('/tmp2', volume["hostPath"]["path"])
      end

      it 'emptyDir can be enabled' do
        values = {
          hostPathMounts: [
            {
              name: "data",
              enabled: true,
              emptyDir: true,
              mountPath: "/data"
            }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        volume = volumes.find{ |v| v["name"] == "hostpathmounts-data"}
        refute_nil(volume)
        assert_equal(Hash.new, volume["emptyDir"])
      end
    end
  end
end
