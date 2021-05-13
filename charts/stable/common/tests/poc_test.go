package common

import (
    "testing"

    helmchart "github.com/k8s-at-home/library-charts/pkg/helmunit"
    "github.com/stretchr/testify/suite"
)

type CommonPoCTestSuite struct {
    suite.Suite
    CommonTestChartPath string
}

func (suite *CommonPoCTestSuite) SetupTest() {
    suite.CommonTestChartPath = "../../../../helper-charts/common-test"
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestCommonPoC(t *testing.T) {
    suite.Run(t, new(CommonPoCTestSuite))
}

func (suite *CommonPoCTestSuite) TestExample() {
    assert := suite.Require()
    chart := helmchart.New("helmChart", suite.CommonTestChartPath)

    err := chart.Template(
        "default",
        nil,
        []string{
            "ingress.main.enabled=true",
        },
    )
    if err != nil {
        panic(err.Error())
    }

    serviceManifest := chart.GetManifest("Service", "common-test")
    assert.NotEmpty(serviceManifest)
    assert.Equal(serviceManifest.Path("spec.type").Data(), "ClusterIP")
}
