package helmchart

import (
    "strings"

    "github.com/Jeffail/gabs"
    "helm.sh/helm/v3/pkg/action"
    "helm.sh/helm/v3/pkg/chart/loader"
    "helm.sh/helm/v3/pkg/cli"
    v "helm.sh/helm/v3/pkg/cli/values"
    "helm.sh/helm/v3/pkg/getter"
    "helm.sh/helm/v3/pkg/releaseutil"
    "sigs.k8s.io/yaml"
)

type helmChart struct {
    Name      string
    ChartPath string
    Manifests map[string]map[string]*gabs.Container
}

func New(name string, chartPath string) helmChart {
    h := helmChart{
        Name:      name,
        ChartPath: chartPath,
    }
    return h
}

func (c *helmChart) Template(namespace string, valueFilePaths, overrideValues []string) error {
    client := defaultClient(c.Name, namespace)

    p := getter.All(&cli.EnvSettings{})
    valueOpts := &v.Options{
        ValueFiles: valueFilePaths,
        Values:     overrideValues,
    }

    values, err := valueOpts.MergeValues(p)
    if err != nil {
        return err
    }
    chart, err := loader.Load(c.ChartPath)
    if err != nil {
        return err
    }
    release, err := client.Run(chart, values)
    if err != nil {
        return err
    }

    manifests := make(map[string]map[string]*gabs.Container)
    for _, manifest := range releaseutil.SplitManifests(release.Manifest) {
        jsonBytes, err := yaml.YAMLToJSON([]byte(manifest))
        if err != nil {
            return err
        }

        parsedJson, err := gabs.ParseJSON(jsonBytes)
        if err != nil {
            return err
        }

        kind := strings.ToLower(parsedJson.Path("kind").Data().(string))
        name := strings.ToLower(parsedJson.Path("metadata.name").Data().(string))

        data, ok := manifests[kind]
        if !ok {
            data = make(map[string]*gabs.Container)
            manifests[kind] = data
        }
        data[name] = parsedJson
    }

    c.Manifests = manifests
    return nil
}

func (c *helmChart) GetManifest(kind string, name string) (manifest *gabs.Container) {
    manifest, ok := c.Manifests[strings.ToLower(kind)][strings.ToLower(name)]
    if !ok {
        return nil
    }
    return manifest
}

func defaultClient(name string, namespace string) *action.Install {
    client := action.NewInstall(&action.Configuration{})
    client.Version = ">0.0.0-0"
    client.ReleaseName = name
    client.Namespace = namespace
    client.ClientOnly = true
    client.DryRun = true

    return client
}
