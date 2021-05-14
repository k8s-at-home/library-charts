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
    assert := suite.Require()

    err := suite.Chart.Render(
        nil,
        nil,
    )
    if err != nil {
        panic(err.Error())
    }

    serviceManifest := suite.Chart.GetManifest("Service", "common-test")
    assert.NotEmpty(serviceManifest)
    assert.Equal(serviceManifest.GetKey(".spec.type"), "ClusterIP")
}

func (suite *CommonPoCTestSuite) TestExample2() {
    assert := suite.Require()

    err := suite.Chart.Render(
        nil,
        []string{
            "ingress.main.enabled=true",
            "ingress.secondary.enabled=true",
        },
    )
    if err != nil {
        panic(err.Error())
    }

    ingressMainManifest := suite.Chart.GetManifest("Ingress", "common-test")
    ingressSecondaryManifest := suite.Chart.GetManifest("Ingress", "common-test-secondary")
    assert.NotEmpty(ingressMainManifest)
    assert.NotEmpty(ingressSecondaryManifest)
}
