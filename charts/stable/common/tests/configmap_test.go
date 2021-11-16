package common

import (
    // "fmt"
    "testing"

    "github.com/k8s-at-home/library-charts/test/helmunit"
    "github.com/stretchr/testify/suite"
)

type ConfigmapTestSuite struct {
    suite.Suite
    Chart helmunit.HelmChart
}

func (suite *ConfigmapTestSuite) SetupSuite() {
    suite.Chart = helmunit.New("common-test", "../../../../helper-charts/common-test")
    suite.Chart.UpdateDependencies()
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestConfigmap(t *testing.T) {
    suite.Run(t, new(ConfigmapTestSuite))
}

func (suite *ConfigmapTestSuite) TestValues() {
    tests := map[string]struct {
        values            []string
        expectedConfigmap bool
    }{
        "Default": {
            values:            nil,
            expectedConfigmap: false,
        },
        "Disabled": {
            values:            []string{"configmap.config.enabled=false"},
            expectedConfigmap: false,
        },
        "Multiple": {
            values: []string{
                "configmap.config.enabled=true",
                "configmap.config.data.foo=bar",
                "configmap.secondary.enabled=true",
            },
            expectedConfigmap: true,
        },
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            configmapManifest := suite.Chart.Manifests.Get("ConfigMap", "common-test-config")
            if tc.expectedConfigmap {
                suite.Assertions.NotEmpty(configmapManifest)
            } else {
                suite.Assertions.Empty(configmapManifest)
            }
        })
    }
}

func (suite *ConfigmapTestSuite) TestConfigmapName() {
    tests := map[string]struct {
        values       []string
        expectedName string
    }{
        "Default": {
            values: []string{
                "configmap.config.enabled=true",
                "configmap.config.data.foo=bar",
            },
            expectedName: "common-test-config",
        },
        "CustomName": {
            values: []string{
                "configmap.config.enabled=true",
                "configmap.config.data.foo=bar",
                "configmap.config.nameOverride=http",
            },
            expectedName: "common-test-http",
        },
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            configmapManifest := suite.Chart.Manifests.Get("ConfigMap", tc.expectedName)
            suite.Assertions.NotEmpty(configmapManifest)
        })
    }
}
