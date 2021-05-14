package helmchart

import (
    "errors"
    "io"
    "strings"

    "github.com/vmware-labs/yaml-jsonpath/pkg/yamlpath"
    "gopkg.in/yaml.v3"
    "helm.sh/helm/v3/pkg/action"
    "helm.sh/helm/v3/pkg/chart/loader"
    "helm.sh/helm/v3/pkg/cli"
    v "helm.sh/helm/v3/pkg/cli/values"
    "helm.sh/helm/v3/pkg/downloader"
    "helm.sh/helm/v3/pkg/getter"
    "helm.sh/helm/v3/pkg/releaseutil"
)

var settings *cli.EnvSettings

type HelmChart struct {
    Name      string
    ChartPath string
    Manifests map[string]map[string]Manifest
}

type Manifest yaml.Node

func (m Manifest) GetKey(path string) string {
    yamlNode := yaml.Node(m)
    yp, _ := yamlpath.NewPath(path)
    results, err := yp.Find(&yamlNode)
    if err != nil {
        return ""
    }

    if len(results) < 1 {
        return ""
    }

    if len(results) > 1 {
        return ""
    }

    return results[0].Value
}

func New(name string, chartPath string) HelmChart {
    h := HelmChart{
        Name:      name,
        ChartPath: chartPath,
    }
    return h
}

func (c *HelmChart) UpdateDependencies() error {
    settings = cli.New()
    client := defaultClient(c.Name, settings.Namespace())
    p := getter.All(&cli.EnvSettings{})

    // Check chart dependencies to make sure all are present in /charts
    chartRequested, err := loader.Load(c.ChartPath)
    if err != nil {
        return err
    }

    if req := chartRequested.Metadata.Dependencies; req != nil {
        if err := action.CheckDependencies(chartRequested, req); err != nil {
            if client.DependencyUpdate {
                man := &downloader.Manager{
                    Out:        io.Discard,
                    ChartPath:  c.ChartPath,
                    Keyring:    client.ChartPathOptions.Keyring,
                    SkipUpdate: false,
                    Getters:    p,
                }
                if err := man.Update(); err != nil {
                    return err
                }
            }
        }
    }
    return nil
}

func (c *HelmChart) Render(valueFilePaths, overrideValues []string) error {
    settings = cli.New()
    client := defaultClient(c.Name, settings.Namespace())

    p := getter.All(&cli.EnvSettings{})
    valueOpts := &v.Options{
        ValueFiles: valueFilePaths,
        Values:     overrideValues,
    }

    values, err := valueOpts.MergeValues(p)
    if err != nil {
        return err
    }

    chartRequested, err := loader.Load(c.ChartPath)
    if err != nil {
        return err
    }

    release, err := client.Run(chartRequested, values)
    if err != nil {
        return err
    }

    manifests := make(map[string]map[string]Manifest)
    for _, manifest := range releaseutil.SplitManifests(release.Manifest) {
        var parsedYaml yaml.Node
        if err := yaml.Unmarshal([]byte(manifest), &parsedYaml); err != nil {
            return err
        }

        yamlManifest := Manifest(parsedYaml)
        kind := strings.ToLower(yamlManifest.GetKey(".kind"))
        name := strings.ToLower(yamlManifest.GetKey(".metadata.name"))

        if kind == "" || name == "" {
            return errors.New("invalid manifest")
        }

        data, ok := manifests[kind]
        if !ok {
            data = make(map[string]Manifest)
            manifests[kind] = data
        }
        data[name] = yamlManifest
    }

    c.Manifests = manifests
    return nil
}

func (c *HelmChart) GetManifest(kind string, name string) *Manifest {
    manifest, ok := c.Manifests[strings.ToLower(kind)][strings.ToLower(name)]
    if !ok {
        return nil
    }
    return &manifest
}

func defaultClient(name, namespace string) *action.Install {
    client := action.NewInstall(&action.Configuration{})
    client.Version = ">0.0.0-0"
    client.ReleaseName = name
    client.Namespace = namespace
    client.ClientOnly = true
    client.DryRun = true
    client.DependencyUpdate = true

    return client
}
