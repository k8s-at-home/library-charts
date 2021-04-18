# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'addon::vpn' do
      baseValues = {
        addons: {
          vpn: {
            enabled: true
          }
        }
      }

      it 'defaults to disabled' do
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        vpnContainer = containers.find{ |c| c["name"] == "openvpn" }

        assert_nil(vpnContainer)
      end

      it 'can be enabled' do
        values = baseValues

        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        vpnContainer = containers.find{ |c| c["name"] == "openvpn" }

        refute_nil(vpnContainer)
      end

      it 'a configuration file can be passed' do
        values = baseValues.deep_merge_override({
          addons: {
            vpn: {
              configFile: "test"
            }
          }
        })
      
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        secret = chart.resources(kind: "Secret").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        vpnContainer = containers.find{ |c| c["name"] == "openvpn" }
        expectedSecretContent = { "vpnConfigfile" => values[:addons][:vpn][:configFile] }

        # Check that the secret has been created
        refute_nil(secret)
        assert_equal("common-test-vpnConfig", secret["metadata"]["name"])
        assert_equal(expectedSecretContent, secret["stringData"])

        # Make sure the deployKey volumeMount is present in the sidecar container
        vpnconfigVolumeMount = vpnContainer["volumeMounts"].find { |v| v["name"] == "vpnconfig"}
        refute_nil(vpnconfigVolumeMount)
        assert_equal("/vpn/vpn.conf", vpnconfigVolumeMount["mountPath"])
        assert_equal("vpnConfigfile", vpnconfigVolumeMount["subPath"])

        # Make sure the deployKey volume is present in the Deployment
        vpnconfigVolume = volumes.find{ |v| v["name"] == "vpnconfig" }
        refute_nil(vpnconfigVolume)
        assert_equal("common-test-vpnConfig", vpnconfigVolume["secret"]["secretName"])
      end

      it 'an existing configuration secret can be passed' do
        values = baseValues.deep_merge_override({
          addons: {
            vpn: {
              configFileSecret: "testSecret"
            }
          }
        })

        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        secret = chart.resources(kind: "Secret").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        volumes = deployment["spec"]["template"]["spec"]["volumes"]
        vpnContainer = containers.find{ |c| c["name"] == "openvpn" }
        expectedSecretContent = { "vpnConfigfile" => values[:addons][:vpn][:configFile] }

        # Check that the secret has not been created
        assert_nil(secret)

        # Make sure the deployKey volumeMount is present in the sidecar container
        vpnconfigVolumeMount = vpnContainer["volumeMounts"].find { |v| v["name"] == "vpnconfig"}
        refute_nil(vpnconfigVolumeMount)
        assert_equal("/vpn/vpn.conf", vpnconfigVolumeMount["mountPath"])
        assert_equal("vpnConfigfile", vpnconfigVolumeMount["subPath"])

        # Make sure the deployKey volume is present in the Deployment
        vpnconfigVolume = volumes.find{ |v| v["name"] == "vpnconfig" }
        refute_nil(vpnconfigVolume)
        assert_equal(values[:addons][:vpn][:configFileSecret], vpnconfigVolume["secret"]["secretName"])
      end
    end
  end
end
