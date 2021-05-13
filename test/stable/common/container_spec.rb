# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')

  describe @@chart.name do
    describe 'container::command' do
      it 'defaults to nil' do
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_nil(mainContainer["command"])
      end

      it 'accepts a single string' do
        values = {
          command: "/bin/sh"
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal([values[:command]], mainContainer["command"])
      end

      it 'accepts a list of strings' do
        values = {
          command: [
            "/bin/sh",
            "-c"
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:command], mainContainer["command"])
      end
    end

    describe 'container::arguments' do
      it 'defaults to nil' do
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_nil(mainContainer["args"])
      end

      it 'accepts a single string' do
        values = {
          args: "sleep infinity"
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal([values[:args]], mainContainer["args"])
      end

      it 'accepts a list of strings' do
        values = {
          args: [
            "sleep",
            "infinity"
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:args], mainContainer["args"])
      end
    end

    describe 'container::environment settings' do
      it 'Check no environment variables' do
        values = {}
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_nil(mainContainer["env"])
      end

      it 'set static "k/v pair style" environment variables' do
        values = {
          env: {
            BOOL_ENV: false,
            FLOAT_ENV: 4.2,
            INT_ENV: 42,
            STRING_ENV: 'value_of_env'
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal(values[:env].values[0].to_s, mainContainer["env"][0]["value"])
        assert_equal(values[:env].keys[1].to_s, mainContainer["env"][1]["name"])
        assert_equal(values[:env].values[1].to_s, mainContainer["env"][1]["value"])
        assert_equal(values[:env].keys[2].to_s, mainContainer["env"][2]["name"])
        assert_equal(values[:env].values[2].to_s, mainContainer["env"][2]["value"])
        assert_equal(values[:env].keys[3].to_s, mainContainer["env"][3]["name"])
        assert_equal(values[:env].values[3].to_s, mainContainer["env"][3]["value"])
      end

      it 'set list of static "kubernetes style" environment variables' do
        values = {
          env: [
            {
              name: 'STATIC_ENV_FROM_LIST',
              value: 'STATIC_ENV_VALUE_FROM_LIST'
             }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env][0][:name].to_s, mainContainer["env"][0]["name"])
        assert_equal(values[:env][0][:value].to_s, mainContainer["env"][0]["value"])
      end

      it 'set list of static "kubernetes valueFrom style" environment variables' do
        values = {
          env: [
            {
              name: 'STATIC_ENV_FROM_LIST',
              valueFrom: {
                 fieldRef: {
                   fieldPath: "spec.nodeName"
                 }
              }
            }
          ]
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env][0][:name].to_s, mainContainer["env"][0]["name"])
        assert_equal(values[:env][0][:valueFrom][:fieldRef][:fieldPath], mainContainer["env"][0]["valueFrom"]["fieldRef"]["fieldPath"])
      end

      it 'set both static "k/v pair style" and static "k/valueFrom style" environment variables' do
        values = {
          env: {
            STATIC_ENV: 'value_of_env',
            STATIC_ENV_FROM: {
              valueFrom: {
                 fieldRef: {
                   fieldPath: "spec.nodeName"
                 }
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal(values[:env].values[0].to_s, mainContainer["env"][0]["value"])
        assert_equal(values[:env].keys[1].to_s, mainContainer["env"][1]["name"])
        assert_equal(values[:env].values[1][:valueFrom][:fieldRef][:fieldPath], mainContainer["env"][1]["valueFrom"]["fieldRef"]["fieldPath"])
      end

      it 'set static "k/explicitValueFrom pair style" environment variables' do
        values = {
          env: {
            NODE_NAME: {
              valueFrom: {
                fieldRef: {
                  fieldPath: "spec.nodeName"
                }
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal(values[:env].values[0][:valueFrom][:fieldRef][:fieldPath], mainContainer["env"][0]["valueFrom"]["fieldRef"]["fieldPath"])
      end

      it 'set static "k/implicitValueFrom pair style" environment variables' do
        values = {
          env: {
            NODE_NAME: {
              fieldRef: {
                fieldPath: "spec.nodeName"
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal(values[:env].values[0][:fieldRef][:fieldPath], mainContainer["env"][0]["valueFrom"]["fieldRef"]["fieldPath"])
      end

      it 'set both static "k/v pair style" and templated "k/v pair style" environment variables' do
        values = {
          env: {
            DYN_ENV: "{{ .Release.Name }}-admin",
            STATIC_ENV: 'value_of_env'
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal("common-test-admin", mainContainer["env"][0]["value"])
        assert_equal(values[:env].keys[1].to_s, mainContainer["env"][1]["name"])
        assert_equal(values[:env].values[1].to_s, mainContainer["env"][1]["value"])
      end

      it 'set templated "k/v pair style" environment variables' do
        values = {
          env: {
            DYN_ENV: "{{ .Release.Name }}-admin"
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal("common-test-admin", mainContainer["env"][0]["value"])
      end

      it 'set static "k/v pair style", templated "k/v pair style", static "k/explicitValueFrom pair style", and static "k/implicitValueFrom pair style" environment variables' do
        values = {
          env: {
            DYN_ENV: "{{ .Release.Name }}-admin",
            STATIC_ENV: 'value_of_env',
            STATIC_EXPLICIT_ENV_FROM: {
              valueFrom: {
                fieldRef: {
                  fieldPath: "spec.nodeName"
                }
              }
            },
            STATIC_IMPLICIT_ENV_FROM: {
              fieldRef: {
                fieldPath: "spec.nodeName"
              }
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(values[:env].keys[0].to_s, mainContainer["env"][0]["name"])
        assert_equal("common-test-admin", mainContainer["env"][0]["value"])
        assert_equal(values[:env].keys[1].to_s, mainContainer["env"][1]["name"])
        assert_equal(values[:env].values[1].to_s, mainContainer["env"][1]["value"])
        assert_equal(values[:env].keys[2].to_s, mainContainer["env"][2]["name"])
        assert_equal(values[:env].values[2][:valueFrom][:fieldRef][:fieldPath], mainContainer["env"][2]["valueFrom"]["fieldRef"]["fieldPath"])
        assert_equal(values[:env].keys[3].to_s, mainContainer["env"][3]["name"])
        assert_equal(values[:env].values[3][:fieldRef][:fieldPath], mainContainer["env"][3]["valueFrom"]["fieldRef"]["fieldPath"])
      end

      it 'set "static" secret variables' do
        expectedSecretName = 'common-test'
        values = {
          secret: {
            STATIC_SECRET: 'value_of_secret'
          }
        }
        chart.value values
        secret = chart.resources(kind: "Secret").find{ |s| s["metadata"]["name"] == expectedSecretName }
        refute_nil(secret)
        assert_equal(values[:secret].values[0].to_s, secret["stringData"]["STATIC_SECRET"])

        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal(expectedSecretName, mainContainer["envFrom"][0]["secretRef"]["name"])
      end
    end

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
