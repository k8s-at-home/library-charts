package helmunit

import (
    "errors"
    "io"
    "strings"

    "github.com/Jeffail/gabs"
    "helm.sh/helm/v3/pkg/action"
    "helm.sh/helm/v3/pkg/chart/loader"
    "helm.sh/helm/v3/pkg/cli"
    v "helm.sh/helm/v3/pkg/cli/values"
    "helm.sh/helm/v3/pkg/downloader"
    "helm.sh/helm/v3/pkg/getter"
    "helm.sh/helm/v3/pkg/releaseutil"
    "sigs.k8s.io/yaml"
)

var settings *cli.EnvSettings

type HelmChart struct {
    Name      string
    ChartPath string
    Manifests map[string]map[string]Manifest
}

type Manifest gabs.Container

func (m *Manifest) GetContainer(path string) *gabs.Container {
    container := gabs.Container(*m)
    result := container.Path(path)
    return result
}

func (m *Manifest) GetKeyData(path string) interface{} {
    container := m.GetContainer(path)
    result := container.Data()
    return result
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

func (c *HelmChart) Render(valueFilePaths, stringValues []string, rawYamlValues *string) error {
    settings = cli.New()
    client := defaultClient(c.Name, settings.Namespace())

    p := getter.All(&cli.EnvSettings{})
    valueOpts := &v.Options{
        ValueFiles: valueFilePaths,
        Values:     stringValues,
    }

    values, err := valueOpts.MergeValues(p)
    if err != nil {
        return err
    }

    if !(rawYamlValues == nil) {
        currentMap := map[string]interface{}{}
        if err := yaml.Unmarshal([]byte(*rawYamlValues), &currentMap); err != nil {
            panic(err)
        }
        values = mergeMaps(currentMap, values)
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
        jsonBytes, err := yaml.YAMLToJSON([]byte(manifest))
        if err != nil {
            return err
        }
        jsonParsed, err := gabs.ParseJSON(jsonBytes)
        if err != nil {
            return err
        }
        jsonManifest := Manifest(*jsonParsed)

        kind := strings.ToLower(jsonManifest.GetKeyData("kind").(string))
        name := strings.ToLower(jsonManifest.GetKeyData("metadata.name").(string))

        if kind == "" || name == "" {
            return errors.New("invalid manifest")
        }

        data, ok := manifests[kind]
        if !ok {
            data = make(map[string]Manifest)
            manifests[kind] = data
        }
        data[name] = jsonManifest
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
