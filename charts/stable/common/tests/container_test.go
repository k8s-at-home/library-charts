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

func (suite *ContainerTestSuite) TestCommand() {
    tests := map[string]struct {
        values          []string
        expectedCommand []string
    }{
        "Default":      {values: nil, expectedCommand: nil},
        "SingleString": {values: []string{"command=/bin/sh"}, expectedCommand: []string{"/bin/sh"}},
        "StringList":   {values: []string{"command={/bin/sh,-c}"}, expectedCommand: []string{"/bin/sh", "-c"}},
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
            containerCommand := containers[0].Path("command")

            if tc.expectedCommand == nil {
                suite.Assertions.Empty(containerCommand)
            } else {
                var actualDataList []string
                actualData, _ := containerCommand.Children()
                for _, key := range actualData {
                    actualDataList = append(actualDataList, key.Data().(string))
                }
                suite.Assertions.EqualValues(tc.expectedCommand, actualDataList)
            }
        })
    }
}

func (suite *ContainerTestSuite) TestArgs() {
    tests := map[string]struct {
        values       []string
        expectedArgs []string
    }{
        "Default":      {values: nil, expectedArgs: nil},
        "SingleString": {values: []string{"args=sleep infinity"}, expectedArgs: []string{"sleep infinity"}},
        "StringList":   {values: []string{"args={sleep,infinity}"}, expectedArgs: []string{"sleep", "infinity"}},
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
            containerArgs := containers[0].Path("args")

            if tc.expectedArgs == nil {
                suite.Assertions.Empty(containerArgs)
            } else {
                var actualDataList []string
                actualData, _ := containerArgs.Children()
                for _, key := range actualData {
                    actualDataList = append(actualDataList, key.Data().(string))
                }
                suite.Assertions.EqualValues(tc.expectedArgs, actualDataList)
            }
        })
    }
}

func (suite *ContainerTestSuite) TestEnv() {
    tests := map[string]struct {
        values      []string
        expectedEnv map[string]string
    }{
        "Default":                    {values: nil, expectedEnv: nil},
        "KeyValueString":             {values: []string{"env.string=value_of_env"}, expectedEnv: map[string]string{"string": "value_of_env"}},
        "KeyValueFloat":              {values: []string{"env.float=4.2"}, expectedEnv: map[string]string{"float": "4.2"}},
        "KeyValueBool":               {values: []string{"env.bool=false"}, expectedEnv: map[string]string{"bool": "false"}},
        "KeyValueInt":                {values: []string{"env.int=42"}, expectedEnv: map[string]string{"int": "42"}},
        "List":                       {values: []string{"env[0].name=STATIC_ENV_FROM_LIST", "env[0].value=STATIC_ENV_VALUE_FROM_LIST"}, expectedEnv: map[string]string{"STATIC_ENV_FROM_LIST": "STATIC_ENV_VALUE_FROM_LIST"}},
        "ValueFrom":                  {values: []string{"env[0].name=STATIC_ENV_FROM_LIST", "env[0].valueFrom.fieldRef.fieldPath=spec.nodeName"}, expectedEnv: map[string]string{"STATIC_ENV_FROM_LIST": "spec.nodeName"}},
        "KeyValue+ExplicitValueFrom": {values: []string{"env.STATIC_ENV=value_of_env", "env.STATIC_ENV_FROM.valueFrom.fieldRef.fieldPath=spec.nodeName"}, expectedEnv: map[string]string{"STATIC_ENV": "value_of_env", "STATIC_ENV_FROM": "spec.nodeName"}},
        "ImplicitValueFrom":          {values: []string{"env.NODE_NAME.fieldRef.fieldPath=spec.nodeName"}, expectedEnv: map[string]string{"NODE_NAME": "spec.nodeName"}},
        "Templated":                  {values: []string{`env.DYN_ENV=\{\{ .Release.Name \}\}-admin`}, expectedEnv: map[string]string{"DYN_ENV": "common-test-admin"}},
        "Mixed": {
            values: []string{
                `env.DYN_ENV=\{\{ .Release.Name \}\}-admin`,
                "env.STATIC_ENV=value_of_env",
                "env.STATIC_EXPLICIT_ENV_FROM.valueFrom.fieldRef.fieldPath=spec.nodeName",
                "env.STATIC_IMPLICIT_ENV_FROM.fieldRef.fieldPath=spec.nodeName",
            },
            expectedEnv: map[string]string{
                "DYN_ENV":                  "common-test-admin",
                "STATIC_ENV":               "value_of_env",
                "STATIC_EXPLICIT_ENV_FROM": "spec.nodeName",
                "STATIC_IMPLICIT_ENV_FROM": "spec.nodeName",
            },
        },
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
            containerEnv := containers[0].Path("env")

            if tc.expectedEnv == nil {
                suite.Assertions.Empty(containerEnv)
            } else {
                actualDataMap := make(map[string]string)
                actualData, _ := containerEnv.Children()
                for _, value := range actualData {
                    envVar, _ := value.ChildrenMap()
                    envName := envVar["name"].Data().(string)
                    var envValue string
                    if _, ok := envVar["valueFrom"]; ok {
                        envValue = value.Path("valueFrom.fieldRef.fieldPath").Data().(string)
                    } else {
                        envValue = value.Path("value").Data().(string)
                    }
                    actualDataMap[envName] = envValue
                }
                suite.Assertions.EqualValues(tc.expectedEnv, actualDataMap)
            }
        })
    }
}

func (suite *ContainerTestSuite) TestEnvFrom() {
    tests := map[string]struct {
        values             []string
        expectSecret       bool
        expectedSecretName string
    }{
        "Default":    {values: nil, expectSecret: false, expectedSecretName: ""},
        "FromSecret": {values: []string{"secret.STATIC_SECRET=value_of_secret"}, expectSecret: true, expectedSecretName: "common-test"},
    }
    for name, tc := range tests {
        suite.Suite.Run(name, func() {
            err := suite.Chart.Render(nil, tc.values, nil)
            if err != nil {
                suite.FailNow(err.Error())
            }

            secretManifest := suite.Chart.GetManifest("Secret", tc.expectedSecretName)
            if tc.expectSecret {
                suite.Assertions.NotEmpty(secretManifest)
            } else {
                suite.Assertions.Empty(secretManifest)
            }

            deploymentManifest := suite.Chart.GetManifest("Deployment", "common-test")
            suite.Assertions.NotEmpty(deploymentManifest)

            containers, _ := deploymentManifest.Path("spec.template.spec.containers").Children()
            containerEnvFrom, _ := containers[0].Path("envFrom").Children()

            if !tc.expectSecret {
                suite.Assertions.Empty(containerEnvFrom)
            } else {
                suite.Assertions.EqualValues(tc.expectedSecretName, containerEnvFrom[0].Path("secretRef.name").Data().(string))
            }
        })
    }
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
