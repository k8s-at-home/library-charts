# common

![Version: 2.0.1](https://img.shields.io/badge/Version-2.0.1-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

Function library for k8s-at-home charts

**WARNING: THIS CHART IS NOT MEANT TO BE INSTALLED DIRECTLY**

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm). It's purpose is for grouping common logic between the k8s@home charts.

Since a lot of charts follow the same pattern this library was built to reduce maintenance cost between the charts that use it and try achieve a goal of being DRY.

## Requirements

Kubernetes: `>=1.16.0-0`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.

## Creating a new chart

First be sure to checkout the many charts that already use this like [qBittorrent](https://github.com/k8s-at-home/charts/tree/master/charts/qbittorrent/), [node-red](https://github.com/k8s-at-home/charts/tree/master/charts/node-red/) or the many others in this repository.

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
- name: common
  version: 2.0.0
  repository: https://library-charts.k8s-at-home.com
```
Write a `values.yaml` with some basic defaults you want to present to the user e.g.

```yaml
#
# IMPORTANT NOTE
#
# This chart inherits from our common library chart. You can check the default values/options here:
# https://github.com/k8s-at-home/library-charts/tree/main/stable/common/values.yaml
#

image:
  repository: nodered/node-red
  pullPolicy: IfNotPresent
  tag: 1.2.5

strategy:
  type: Recreate

# See more environment variables in the node-red documentation
# https://nodered.org/docs/getting-started/docker
env: {}
  # TZ:
  # NODE_OPTIONS:
  # NODE_RED_ENABLE_PROJECTS:
  # NODE_RED_ENABLE_SAFE_MODE:
  # FLOWS:

service:
  port:
    port: 1880

ingress:
  enabled: false

persistence:
  data:
    enabled: false
    emptyDir:
      enabled: false
    mountPath: /data
```

If not using a service, set the `service.enabled` to `false`.
```yaml
...
service:
  enabled: false
...
```

Add files to the `templates` folder.
```yaml
# templates/common.yaml
{{ include "common.all . }}

# templates/NOTES.txt
{{ include "common.notes.defaultNotes" . }}
```

If testing locally make sure you update the dependencies with:

```bash
helm dependency update
```

## Values

**Important**: When deploying an application Helm chart you can add more values from our common library chart [here](https://github.com/k8s-at-home/library-charts/tree/main/stable/common/)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers | list | `[]` |  |
| additionalVolumeMounts | list | `[]` |  |
| additionalVolumes | list | `[]` |  |
| addons.codeserver.args[0] | string | `"--auth"` |  |
| addons.codeserver.args[1] | string | `"none"` |  |
| addons.codeserver.enabled | bool | `false` |  |
| addons.codeserver.env | object | `{}` |  |
| addons.codeserver.git.deployKey | string | `""` |  |
| addons.codeserver.git.deployKeyBase64 | string | `""` |  |
| addons.codeserver.git.deployKeySecret | string | `""` |  |
| addons.codeserver.image.pullPolicy | string | `"IfNotPresent"` |  |
| addons.codeserver.image.repository | string | `"codercom/code-server"` |  |
| addons.codeserver.image.tag | string | `"3.7.4"` |  |
| addons.codeserver.ingress.annotations | object | `{}` |  |
| addons.codeserver.ingress.enabled | bool | `false` |  |
| addons.codeserver.ingress.hosts[0].host | string | `"code.chart-example.local"` |  |
| addons.codeserver.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| addons.codeserver.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| addons.codeserver.ingress.labels | object | `{}` |  |
| addons.codeserver.ingress.nameSuffix | string | `"codeserver"` |  |
| addons.codeserver.ingress.tls | list | `[]` |  |
| addons.codeserver.securityContext.runAsUser | int | `0` |  |
| addons.codeserver.service.annotations | object | `{}` |  |
| addons.codeserver.service.enabled | bool | `true` |  |
| addons.codeserver.service.labels | object | `{}` |  |
| addons.codeserver.service.port.name | string | `"codeserver"` |  |
| addons.codeserver.service.port.port | int | `12321` |  |
| addons.codeserver.service.port.protocol | string | `"TCP"` |  |
| addons.codeserver.service.port.targetPort | string | `"codeserver"` |  |
| addons.codeserver.service.type | string | `"ClusterIP"` |  |
| addons.codeserver.volumeMounts | list | `[]` |  |
| addons.codeserver.workingDir | string | `""` |  |
| addons.vpn.additionalVolumeMounts | list | `[]` |  |
| addons.vpn.configFile | string | `nil` |  |
| addons.vpn.configFileSecret | string | `nil` |  |
| addons.vpn.enabled | bool | `false` |  |
| addons.vpn.env | object | `{}` |  |
| addons.vpn.livenessProbe | object | `{}` |  |
| addons.vpn.networkPolicy.egress | string | `nil` |  |
| addons.vpn.networkPolicy.enabled | bool | `false` |  |
| addons.vpn.openvpn.auth | string | `nil` |  |
| addons.vpn.openvpn.authSecret | string | `nil` |  |
| addons.vpn.openvpn.image.pullPolicy | string | `"IfNotPresent"` |  |
| addons.vpn.openvpn.image.repository | string | `"dperson/openvpn-client"` |  |
| addons.vpn.openvpn.image.tag | string | `"latest"` |  |
| addons.vpn.scripts.down | string | `nil` |  |
| addons.vpn.scripts.up | string | `nil` |  |
| addons.vpn.securityContext.capabilities.add[0] | string | `"NET_ADMIN"` |  |
| addons.vpn.securityContext.capabilities.add[1] | string | `"SYS_MODULE"` |  |
| addons.vpn.type | string | `"openvpn"` |  |
| addons.vpn.wireguard.image.pullPolicy | string | `"IfNotPresent"` |  |
| addons.vpn.wireguard.image.repository | string | `"k8sathome/wireguard"` |  |
| addons.vpn.wireguard.image.tag | string | `"1.0.20200827"` |  |
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| command | list | `[]` |  |
| controllerAnnotations | object | `{}` |  |
| controllerLabels | object | `{}` |  |
| controllerType | string | `"deployment"` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| enableServiceLinks | bool | `true` |  |
| env | object | `{}` |  |
| envFrom | list | `[]` |  |
| envTpl | object | `{}` |  |
| envValueFrom | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| hostAliases | list | `[]` |  |
| hostNetwork | bool | `false` |  |
| ingress.additionalIngresses | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.labels | object | `{}` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.config.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.config.enabled | bool | `false` |  |
| persistence.config.mountPath | string | `"/config"` |  |
| persistence.config.size | string | `"1Gi"` |  |
| persistence.config.skipuninstall | bool | `false` |  |
| persistence.shared.emptyDir.enabled | bool | `true` |  |
| persistence.shared.enabled | bool | `false` |  |
| persistence.shared.mountPath | string | `"/shared"` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| probes.liveness.custom | bool | `false` |  |
| probes.liveness.enabled | bool | `true` |  |
| probes.liveness.spec.failureThreshold | int | `3` |  |
| probes.liveness.spec.initialDelaySeconds | int | `0` |  |
| probes.liveness.spec.periodSeconds | int | `10` |  |
| probes.liveness.spec.timeoutSeconds | int | `1` |  |
| probes.readiness.custom | bool | `false` |  |
| probes.readiness.enabled | bool | `true` |  |
| probes.readiness.spec.failureThreshold | int | `3` |  |
| probes.readiness.spec.initialDelaySeconds | int | `0` |  |
| probes.readiness.spec.periodSeconds | int | `10` |  |
| probes.readiness.spec.timeoutSeconds | int | `1` |  |
| probes.startup.custom | bool | `false` |  |
| probes.startup.enabled | bool | `true` |  |
| probes.startup.spec.failureThreshold | int | `30` |  |
| probes.startup.spec.initialDelaySeconds | int | `0` |  |
| probes.startup.spec.periodSeconds | int | `5` |  |
| probes.startup.spec.timeoutSeconds | int | `1` |  |
| replicas | int | `1` |  |
| resources | object | `{}` |  |
| secret | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.additionalPorts | list | `[]` |  |
| service.additionalServices | list | `[]` |  |
| service.annotations | object | `{}` |  |
| service.enabled | bool | `true` |  |
| service.labels | object | `{}` |  |
| service.port.name | string | `nil` |  |
| service.port.port | string | `nil` |  |
| service.port.protocol | string | `"TCP"` |  |
| service.port.targetPort | string | `nil` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| strategy.type | string | `"RollingUpdate"` |  |
| tolerations | list | `[]` |  |
| volumeClaimTemplates | list | `[]` |  |

## Changelog

All notable changes to this application Helm chart will be documented in this file but does not include changes from our common library. To read those click [here](../common/README.md).

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [2.5.0]

#### Added

- Added `Horizontal Pod Autoscaler`
- Can now use "HTTP" or "HTTPS" as port protocol (which use TCP under-the-hood)
- Setting the port protocol to "HTTPS" adds traefik annotation to use https towards the backend service
- Add option to automatically generate a configmap for use with the TrueNAS SCALE UI portal-button
- Added option to use TrueNAS SCALE default storageClass by using `SCALE-ZFS` storageClass
- It is now possible to set the `serviceName` and `servicePort` per Ingress path

#### Changed

- Port protocol gets used to determine install-notes URL (http or https)

### [2.4.0]

#### Added

- `hostPathMounts` to mount hostPaths with a single values.yaml setting
- Automated ownership fixing job for `hostPathMounts`
- `envList` to use a list of environment variables in addition to the current dict or template

#### Changed

- Set `dnsPolicy` default based on `hostNetwork` setting

#### Fixed

- Fixed unit-tests not correctly testing no-env scenario's

### [2.3.1]

#### Fixed

- Fixed the VPN addon secret name when providing inline VPN configuration.

### [2.3.0]

#### Added

- Allow `configFileSecret` to be specified under the VPN add-on, to reference an existing secret.
- Allow `git.deployKey` to be specified under the codeserver add-on. Please refer to `values.yaml` for more details.

#### Changed

- Modified unit tests to no longer depend on `jq`.

#### Fixed

- `secretName` is now truly optional under Ingress TLS configuration.

### [2.2.0]

#### Added

- Persistence `nameSuffix` can now be set to `-` to disable suffixing that PVC.
- Support for configuring `lifecycle`
- Support for configuring `pathTpl` in Ingress (#15).

#### Fixed

- Ingress `pathType` is now actually configurable. Fixes #16.
- PVC's are always forced to a newline. Fixes #17.

### [2.1.0]

#### Added

- Added support for shipping logs to Loki using the new `promtail` add-on.

#### Changed

- Upgraded the default image in the `codeserver` add-on to `v3.9.2`

### [2.0.1]

#### Fixed

- Volumes referencing persistentVolumeClaims actually reference the PVC again.
- Items under persistence now default their `mountPath` to the item name, as they should have been doing.

### [2.0.0]

#### Added

- Added support for using Helm template language in `additionalContainers`.

#### Changed

- **Breaking:** `persistence.emptyDir` was changed to allow more configuration options, such as `medium` and `sizeLimit`.

### [1.0.0]

#### Changed

- Moved common library chart to separate repository

#### Fixed

- The `command` and `args` values now properly support both string and list values.

[2.3.1]: #2.3.1
[2.3.0]: #2.3.0
[2.2.0]: #2.2.0
[2.1.0]: #2.1.0
[2.0.1]: #2.0.1
[2.0.0]: #2.0.0
[1.0.0]: #1.0.0

## Support

- See the [Docs](http://docs.k8s-at-home.com).
- Open an [issue](https://github.com/k8s-at-home/library-charts/issues/new/choose)
- Ask a [question](https://github.com/k8s-at-home/organization/discussions)
- Join our [Discord](https://discord.gg/sTMX7Vh) community
