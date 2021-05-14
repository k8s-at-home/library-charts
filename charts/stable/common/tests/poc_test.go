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
