# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')
  
  describe @@chart.name do  
    describe 'addon::vpn' do
      it 'defaults to disabled' do
        assert_nil(resource('Deployment')['spec']['template']['spec']['containers'][1])
      end

      it 'can be enabled' do
        values = {
          addons: {
            vpn: {
              enabled: true
            }
          }
        }

        chart.value values
        jq('.spec.template.spec.containers[1].name', resource('Deployment')).must_equal "openvpn"
      end

      it 'a configuration file can be passed' do
        values = {
          addons: {
            vpn: {
              enabled: true,
              configFile: "test"
            }
          }
        }

        expectedContent = { "vpnConfigfile" => values[:addons][:vpn][:configFile] }

        chart.value values
        jq('.metadata.name', resource('Secret')).must_equal "common-test-vpnConfig"
        jq('.stringData', resource('Secret')).must_equal expectedContent
        jq('.spec.template.spec.containers[1].volumeMounts[0].name', resource('Deployment')).must_equal "vpnconfig"
        jq('.spec.template.spec.volumes[0].name', resource('Deployment')).must_equal "vpnconfig"
        jq('.spec.template.spec.volumes[0].secret.secretName', resource('Deployment')).must_equal "common-test-vpnConfig"
      end

      it 'an existing configuration secret can be passed' do
        values = {
          addons: {
            vpn: {
              enabled: true,
              configFileSecret: "testSecret"
            }
          }
        }

        chart.value values
        assert_nil(resource('Secret'))
        jq('.spec.template.spec.containers[1].volumeMounts[0].name', resource('Deployment')).must_equal "vpnconfig"
        jq('.spec.template.spec.volumes[0].name', resource('Deployment')).must_equal "vpnconfig"
        jq('.spec.template.spec.volumes[0].secret.secretName', resource('Deployment')).must_equal values[:addons][:vpn][:configFileSecret]
      end
    end
  end
end
