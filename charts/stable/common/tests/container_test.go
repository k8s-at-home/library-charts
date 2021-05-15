package common

import (
    "testing"

    "github.com/k8s-at-home/library-charts/test/helmunit"
    "github.com/stretchr/testify/suite"
)

type ContainerTestSuite struct {
    suite.Suite
    Chart helmunit.HelmChart
}

func (suite *ContainerTestSuite) SetupSuite() {
    suite.Chart = helmunit.New("common-test", "../../../../helper-charts/common-test")
    suite.Chart.UpdateDependencies()
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestContainer(t *testing.T) {
    suite.Run(t, new(ContainerTestSuite))
}

func (suite *ContainerTestSuite) TestPorts() {
    tests := map[string]struct {
        values           []string
        expectedPortName string
        expectedPort     int
        expectedProtocol string
    }{
        "Default":       {values: nil, expectedPortName: "http", expectedPort: 0, expectedProtocol: "TCP"},
        "CustomName":    {values: []string{"service.main.ports.http.enabled=false", "service.main.ports.server.enabled=true", "service.main.ports.server.port=8080"}, expectedPortName: "server", expectedPort: 8080, expectedProtocol: "TCP"},
        "ProtocolHTTP":  {values: []string{"service.main.ports.http.protocol=HTTP"}, expectedPortName: "http", expectedPort: 0, expectedProtocol: "TCP"},
        "ProtocolHTTPS": {values: []string{"service.main.ports.http.protocol=HTTP"}, expectedPortName: "http", expectedPort: 0, expectedProtocol: "TCP"},
        "ProtocolUDP":   {values: []string{"service.main.ports.http.protocol=UDP"}, expectedPortName: "http", expectedPort: 0, expectedProtocol: "UDP"},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
            suite.Assertions.NotEmpty(deploymentManifest)
            containers, _ := deploymentManifest.Path("spec.template.spec.containers").Children()
            containerPorts, _ := containers[0].Path("ports").Children()
            suite.Assertions.NotEmpty(containerPorts[0])
            suite.Assertions.EqualValues(tc.expectedPortName, containerPorts[0].Path("name").Data())
            suite.Assertions.EqualValues(tc.expectedProtocol, containerPorts[0].Path("protocol").Data())

            if tc.expectedPort == 0 {
                suite.Assertions.Empty(containerPorts[0].Path("containerPort").Data())
            } else {
                suite.Assertions.EqualValues(tc.expectedPort, containerPorts[0].Path("containerPort").Data())
            }
        })
    }
}
