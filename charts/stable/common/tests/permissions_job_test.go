package common

import (
    "testing"

    "github.com/k8s-at-home/library-charts/test/helmunit"
    "github.com/stretchr/testify/suite"
)

type PermissionsJobTestSuite struct {
    suite.Suite
    Chart helmunit.HelmChart
}

func (suite *PermissionsJobTestSuite) SetupSuite() {
    suite.Chart = helmunit.New("common-test", "../../../../helper-charts/common-test")
    suite.Chart.UpdateDependencies()
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestPermissionsJob(t *testing.T) {
    suite.Run(t, new(PermissionsJobTestSuite))
}

func (suite *PermissionsJobTestSuite) TestPresence() {
    tests := map[string]struct {
        values      string
        expectedJob bool
    }{
        "Default": {
            values:      "",
            expectedJob: false,
        },
        "SetPermissionsEnabled": {
            values: `
                hostPathMounts:
                  - name: data
                    enabled: true
                    setPermissions: true
                    mountPath: /data
                    hostPath: /tmp
            `,
            expectedJob: true,
        },
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, nil, &tc.values)
            if err != nil {
                suite.FailNow(err.Error())
            }

            jobManifest := suite.Chart.GetManifest("Job", "common-test-auto-permissions")
            if tc.expectedJob {
                suite.Assertions.NotEmpty(jobManifest)
            } else {
                suite.Assertions.Empty(jobManifest)
            }
        })
    }
}
