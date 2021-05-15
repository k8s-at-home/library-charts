package common

import (
    "fmt"
    "testing"

    "github.com/k8s-at-home/library-charts/test/helmunit"
    "github.com/stretchr/testify/suite"
)

type ServiceTestSuite struct {
    suite.Suite
    Chart helmunit.HelmChart
}

func (suite *ServiceTestSuite) SetupSuite() {
    suite.Chart = helmunit.New("common-test", "../../../../helper-charts/common-test")
    suite.Chart.UpdateDependencies()
}

// We need this function to kick off the test suite, otherwise
// "go test" won't know about our tests
func TestService(t *testing.T) {
    suite.Run(t, new(ServiceTestSuite))
}

func (suite *ServiceTestSuite) TestServiceName() {
    tests := map[string]struct {
        values       []string
        expectedName string
    }{
        "Default":    {values: nil, expectedName: "common-test"},
        "CustomName": {values: []string{"service.main.nameOverride=http"}, expectedName: "common-test-http"},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            serviceManifest := suite.Chart.GetManifest("Service", tc.expectedName)
            suite.Assertions.NotEmpty(serviceManifest)
        })
    }
}

func (suite *ServiceTestSuite) TestPortNames() {
    tests := map[string]struct {
        values                []string
        expectedRenderFailure bool
        expectedName          string
        expectedTargetPort    interface{}
    }{
        "Default":          {values: nil, expectedRenderFailure: false, expectedName: "http", expectedTargetPort: "http"},
        "CustomName":       {values: []string{"service.main.ports.http.enabled=false", "service.main.ports.server.enabled=true", "service.main.ports.server.port=8080"}, expectedRenderFailure: false, expectedName: "server", expectedTargetPort: "server"},
        "CustomTargetPort": {values: []string{"service.main.ports.http.targetPort=80"}, expectedRenderFailure: false, expectedName: "http", expectedTargetPort: 80},
        "NamedTargetPort":  {values: []string{"service.main.ports.http.targetPort=name"}, expectedRenderFailure: true, expectedName: "", expectedTargetPort: nil},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if tc.expectedRenderFailure {
                suite.Assertions.Error(err)
                return
            }
            if err != nil {
                suite.FailNow(err.Error())
            }

            serviceManifest := suite.Chart.GetManifest("Service", "common-test")
            suite.Assertions.NotEmpty(serviceManifest)
            servicePorts, _ := serviceManifest.Path("spec.ports").Children()
            suite.Assertions.EqualValues(tc.expectedName, servicePorts[0].Path("name").Data())
            suite.Assertions.EqualValues(tc.expectedTargetPort, servicePorts[0].Path("targetPort").Data())
        })
    }
}

func (suite *ServiceTestSuite) TestPortProtocol() {
    tests := map[string]struct {
        values           []string
        expectedProtocol string
    }{
        "Default":       {values: nil, expectedProtocol: "TCP"},
        "ExplicitTCP":   {values: []string{"service.main.ports.http.protocol=TCP"}, expectedProtocol: "TCP"},
        "ExplicitHTTP":  {values: []string{"service.main.ports.http.protocol=HTTP"}, expectedProtocol: "TCP"},
        "ExplicitHTTPS": {values: []string{"service.main.ports.http.protocol=HTTPS"}, expectedProtocol: "TCP"},
        "ExplicitUDP":   {values: []string{"service.main.ports.http.protocol=UDP"}, expectedProtocol: "UDP"},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            serviceManifest := suite.Chart.GetManifest("Service", "common-test")
            suite.Assertions.NotEmpty(serviceManifest)
            servicePorts, _ := serviceManifest.Path("spec.ports").Children()
            suite.Assertions.EqualValues(tc.expectedProtocol, servicePorts[0].Path("protocol").Data())
        })
    }
}

func (suite *ServiceTestSuite) TestAnnotations() {
    tests := map[string]struct {
        values              []string
        expectedAnnotations map[string]string
    }{
        "Default":       {values: nil, expectedAnnotations: nil},
        "ExplicitTCP":   {values: []string{"service.main.ports.http.protocol=TCP"}, expectedAnnotations: nil},
        "ExplicitHTTP":  {values: []string{"service.main.ports.http.protocol=HTTP"}, expectedAnnotations: nil},
        "ExplicitHTTPS": {values: []string{"service.main.ports.http.protocol=HTTPS"}, expectedAnnotations: map[string]string{"traefik.ingress.kubernetes.io/service.serversscheme": "https"}},
        "ExplicitUDP":   {values: []string{"service.main.ports.http.protocol=UDP"}, expectedAnnotations: nil},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            serviceManifest := suite.Chart.GetManifest("Service", "common-test")
            suite.Assertions.NotEmpty(serviceManifest)
            serviceAnnotations, _ := serviceManifest.Path("metadata.annotations").Children()
            if tc.expectedAnnotations == nil {
                suite.Assertions.Empty(serviceAnnotations)
            } else {
                for annotation, value := range tc.expectedAnnotations {
                    serviceAnnotation := serviceManifest.Path("metadata.annotations").Search(annotation)
                    suite.Assertions.NotEmpty(serviceAnnotation, fmt.Sprintf("Annotation %s not found", annotation))
                    suite.Assertions.EqualValues(value, serviceAnnotation.Data(), fmt.Sprintf("Invalid value for annotation %s", annotation))
                }
            }
        })
    }
}
