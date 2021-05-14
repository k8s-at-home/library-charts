package common

import (
    "testing"

    helmchart "github.com/k8s-at-home/library-charts/pkg/helmunit"
    "github.com/stretchr/testify/suite"
)

type CommonPoCTestSuite struct {
    suite.Suite
    Chart helmchart.HelmChart
}

func (suite *CommonPoCTestSuite) SetupSuite() {
    suite.Chart = helmchart.New("helmChart", "../../../../helper-charts/common-test")
    suite.Chart.UpdateDependencies()
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestCommonPoC(t *testing.T) {
    suite.Run(t, new(CommonPoCTestSuite))
}

func (suite *CommonPoCTestSuite) TestExample() {
    err := suite.Chart.Render(nil, nil)
    if err != nil {
        panic(err.Error())
    }

    serviceManifest := suite.Chart.GetManifest("Service", "common-test")
    suite.Assertions.NotEmpty(serviceManifest)
    suite.Assertions.Equal("ClusterIP", serviceManifest.GetKey("spec.type"))
}

func (suite *CommonPoCTestSuite) TestExample2() {
    values := []string{
        "ingress.main.enabled=true",
        "ingress.secondary.enabled=true",
    }

    err := suite.Chart.Render(nil, values)
    if err != nil {
        panic(err.Error())
    }

    ingressMainManifest := suite.Chart.GetManifest("Ingress", "common-test")
    ingressSecondaryManifest := suite.Chart.GetManifest("Ingress", "common-test-secondary")
    suite.Assertions.NotEmpty(ingressMainManifest)
    suite.Assertions.NotEmpty(ingressSecondaryManifest)
}

func (suite *CommonPoCTestSuite) TestExample3() {
    err := suite.Chart.Render(nil, nil)
    if err != nil {
        panic(err.Error())
    }

    deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
    suite.Assertions.NotEmpty(deploymentManifest)
    suite.Assertions.EqualValues(1, deploymentManifest.GetKey("spec.replicas"))
}
