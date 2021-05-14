package common

import (
    "testing"

    helmchart "github.com/k8s-at-home/library-charts/pkg/helmunit"
    "github.com/stretchr/testify/suite"
)

type PodTestSuite struct {
    suite.Suite
    Chart helmchart.HelmChart
}

func (suite *PodTestSuite) SetupSuite() {
    suite.Chart = helmchart.New("common-test", "../../../../helper-charts/common-test")
    suite.Chart.UpdateDependencies()
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestPod(t *testing.T) {
    suite.Run(t, new(PodTestSuite))
}

func (suite *PodTestSuite) TestReplicas() {
    tests := map[string]struct {
        values        []string
        expectedValue interface{}
    }{
        "Default":   {values: nil, expectedValue: 1},
        "Specified": {values: []string{"controller.replicas=3"}, expectedValue: 3},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values)
            if err != nil {
                panic(err.Error())
            }

            deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
            suite.Assertions.NotEmpty(deploymentManifest)
            suite.Assertions.EqualValues(tc.expectedValue, deploymentManifest.GetKeyData("spec.replicas"))
        })
    }
}

func (suite *PodTestSuite) TestHostNetwork() {
    tests := map[string]struct {
        values        []string
        expectedValue interface{}
    }{
        "Default":        {values: nil, expectedValue: nil},
        "SpecifiedTrue":  {values: []string{"hostNetwork=true"}, expectedValue: true},
        "SpecifiedFalse": {values: []string{"hostNetwork=false"}, expectedValue: nil},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values)
            if err != nil {
                panic(err.Error())
            }

            deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
            suite.Assertions.NotEmpty(deploymentManifest)
            suite.Assertions.EqualValues(tc.expectedValue, deploymentManifest.GetKeyData("spec.template.spec.hostNetwork"))
        })
    }
}

func (suite *PodTestSuite) TestDnsPolicy() {
    tests := map[string]struct {
        values        []string
        expectedValue interface{}
    }{
        "Default":          {values: nil, expectedValue: "ClusterFirst"},
        "HostnetworkFalse": {values: []string{"hostNetwork=false"}, expectedValue: "ClusterFirst"},
        "HostnetworkTrue":  {values: []string{"hostNetwork=true"}, expectedValue: "ClusterFirstWithHostNet"},
        "ManualOverride":   {values: []string{"dnsPolicy=None"}, expectedValue: "None"},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values)
            if err != nil {
                panic(err.Error())
            }

            deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
            suite.Assertions.NotEmpty(deploymentManifest)
            suite.Assertions.EqualValues(tc.expectedValue, deploymentManifest.GetKeyData("spec.template.spec.dnsPolicy"))
        })
    }
}

func (suite *PodTestSuite) TestAdditionalContainers() {
    tests := map[string]struct {
        values            []string
        expectedContainer interface{}
    }{
        "Static":          {values: []string{"additionalContainers[0].name=template-test"}, expectedContainer: "template-test"},
        "DynamicTemplate": {values: []string{`additionalContainers[0].name=\{\{ .Release.Name \}\}-container`}, expectedContainer: "common-test-container"},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values)
            if err != nil {
                panic(err.Error())
            }

            deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
            containers := deploymentManifest.GetContainer("spec.template.spec.containers")
            suite.Assertions.Contains(containers.Search("name").Data(), tc.expectedContainer)
        })
    }
}
