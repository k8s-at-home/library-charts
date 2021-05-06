# frozen_string_literal: true
require_relative '../../test_helper'

class Test < ChartTest
  @@chart = Chart.new('helper-charts/common-test')

  describe @@chart.name do
    describe 'container::resources' do
      it 'no resources added by default' do
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal({"limits"=>{}}, mainContainer["resources"])
      end
      it 'resources can be added' do
        values = {
          resources: {
            testresourcename: "testresourcevalue"
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal({"limits"=>{}, "testresourcename"=>"testresourcevalue"}, mainContainer["resources"])
      end
      it 'resources.limits can be added' do
        values = {
          resources: {
            limits: {
              testlimitkey: "testlimitvalue"
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal({"limits"=>{"testlimitkey"=>"testlimitvalue"}}, mainContainer["resources"])
      end
      it 'resources and resources.limits can both be added' do
        values = {
          resources: {
            testresourcekey: "testresourcevalue",
            limits: {
              testlimitkey: "testlimitvalue"
            }
          }
        }
        chart.value values
        deployment = chart.resources(kind: "Deployment").first
        containers = deployment["spec"]["template"]["spec"]["containers"]
        mainContainer = containers.find{ |c| c["name"] == "common-test" }
        assert_equal({"limits"=>{"testlimitkey"=>"testlimitvalue"}, "testresourcekey"=>"testresourcevalue"}, mainContainer["resources"])
      end
    end
    describe 'container::resources-scaleGPU' do
      it 'scaleGPU can be set' do
          values = {
            scaleGPU: {
              intelblabla: 1
            }
          }
          chart.value values
          deployment = chart.resources(kind: "Deployment").first
          containers = deployment["spec"]["template"]["spec"]["containers"]
          mainContainer = containers.find{ |c| c["name"] == "common-test" }
          assert_equal({"limits"=>{"intelblabla"=>1}}, mainContainer["resources"])
        end
        it 'scaleGPU can be combined with resources and resource values' do
          values = {
            resources: {
              testresourcekey: "testresourcevalue",
              limits: {
                testlimitkey: "testlimitvalue"
              }
            },
            scaleGPU: {
              intelblabla: 1
            }
          }
          chart.value values
          deployment = chart.resources(kind: "Deployment").first
          containers = deployment["spec"]["template"]["spec"]["containers"]
          mainContainer = containers.find{ |c| c["name"] == "common-test" }
          assert_equal({"limits"=>{"intelblabla"=>1, "testlimitkey"=>"testlimitvalue"}, "testresourcekey"=>"testresourcevalue"}, mainContainer["resources"])
        end
      end
  end
end
