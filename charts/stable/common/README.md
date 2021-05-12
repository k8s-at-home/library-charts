# common

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

Function library for k8s-at-home charts

Since a lot of the k8s-at-home charts follow a similar pattern, this library was built to reduce maintenance cost between the charts that use it and try achieve a goal of being DRY.

## Requirements

Kubernetes: `>=1.16`

## Dependencies

| Repository | Name | Version |
|------------|------|---------|

## Installing the Chart

This is a [Helm Library Chart](https://helm.sh/docs/topics/library_charts/#helm).

**WARNING: THIS CHART IS NOT MEANT TO BE INSTALLED DIRECTLY**

## Using this library

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
- name: common
  version: 3.0.0
  repository: https://k8s-at-home.com/charts/
```

For more information, take a look at the [Docs](http://docs.k8s-at-home.com/our-helm-charts/common-library/).

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.

## Custom configuration

N/A

## Values

**Important**: When deploying an application Helm chart you can add more values from our common library chart [here](https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers | list | `[]` | Specify any additional containers here. Yaml will be passed in to the Pod as-is. |
| additionalVolumeMounts | list | `[]` | Specify any additional volume mounts for the main container here. |
| additionalVolumes | list | `[]` | Specify any additional volumes here. (e.g. to mount nfs volumes directly) |
| addons | object | See below | The common chart supports several add-ons. These can be configured under this key. |
| addons.codeserver | object | See values.yaml | The common library supports adding a code-server add-on to access files. It can be configured under this key. For more info, check out [our docs](http://docs.k8s-at-home.com/our-helm-charts/common-library-add-ons/#code-server) |
| addons.codeserver.args | list | `["--auth","none"]` | Set codeserver command line arguments. Consider setting --user-data-dir to a persistent location to preserve code-server setting changes |
| addons.codeserver.enabled | bool | `false` | Enable running a code-server container in the pod |
| addons.codeserver.env | object | `{}` | Set any environment variables for code-server here |
| addons.codeserver.git | object | See below | Optionally allow access a Git repository by passing in a private SSH key |
| addons.codeserver.git.deployKey | string | `""` | Raw SSH private key |
| addons.codeserver.git.deployKeyBase64 | string | `""` | Base64-encoded SSH private key. When both variables are set, the raw SSH key takes precedence. |
| addons.codeserver.git.deployKeySecret | string | `""` | Existing secret containing SSH private key The chart expects it to be present under the `id_rsa` key. |
| addons.codeserver.image.pullPolicy | string | `"IfNotPresent"` | Specify the code-server image pull policy |
| addons.codeserver.image.repository | string | `"codercom/code-server"` | Specify the code-server image |
| addons.codeserver.image.tag | string | `"3.9.2"` | Specify the code-server image tag |
| addons.codeserver.ingress.enabled | bool | `false` | Enable an ingress for the code-server add-on. |
| addons.codeserver.service.enabled | bool | `true` | Enable a service for the code-server add-on. |
| addons.codeserver.volumeMounts | list | `[]` | Specify a list of volumes that get mounted in the code-server container. At least 1 volumeMount is required! |
| addons.codeserver.workingDir | string | `""` | Specify the working dir that will be opened when code-server starts If not given, the app will default to the mountpah of the first specified volumeMount |
| addons.promtail | object | See values.yaml | The common library supports adding a promtail add-on to to access logs and ship them to loki. It can be configured under this key. |
| addons.promtail.args | list | `[]` | Set promtail command line arguments |
| addons.promtail.enabled | bool | `false` | Enable running a promtail container in the pod |
| addons.promtail.env | object | `{}` | Set any environment variables for promtail here |
| addons.promtail.image.pullPolicy | string | `"IfNotPresent"` | Specify the promtail image pull policy |
| addons.promtail.image.repository | string | `"grafana/promtail"` | Specify the promtail image |
| addons.promtail.image.tag | string | `"2.2.0"` | Specify the promtail image tag |
| addons.promtail.logs | list | `[]` | The paths to logs on the volume |
| addons.promtail.loki | string | `""` | The URL to Loki |
| addons.promtail.volumeMounts | list | `[]` | Specify a list of volumes that get mounted in the promtail container. At least 1 volumeMount is required! |
| addons.vpn | object | See values.yaml | The common chart supports adding a VPN add-on. It can be configured under this key. For more info, check out [our docs](http://docs.k8s-at-home.com/our-helm-charts/common-library-add-ons/#wireguard-vpn) |
| addons.vpn.configFile | string | `nil` | Provide a customized vpn configuration file to be used by the VPN. |
| addons.vpn.enabled | bool | `false` | Enable running a VPN in the pod to route traffic through a VPN |
| addons.vpn.env | object | `{}` | All variables specified here will be added to the vpn sidecar container See the documentation of the VPN image for all config values |
| addons.vpn.livenessProbe | object | `{}` | Optionally specify a livenessProbe, e.g. to check if the connection is still being protected by the VPN |
| addons.vpn.openvpn | object | See below | OpenVPN specific configuration |
| addons.vpn.openvpn.auth | string | `nil` | Credentials to connect to the VPN Service (used with -a) |
| addons.vpn.openvpn.authSecret | string | `nil` | Optionally specify an existing secret that contains the credentials. Credentials should be stored under the `VPN_AUTH` key |
| addons.vpn.openvpn.image.pullPolicy | string | `"IfNotPresent"` | Specify the openvpn client image pull policy |
| addons.vpn.openvpn.image.repository | string | `"dperson/openvpn-client"` | Specify the openvpn client image |
| addons.vpn.openvpn.image.tag | string | `"latest"` | Specify the openvpn client image tag |
| addons.vpn.scripts | object | See values.yaml | Provide custom up/down scripts that can be used by the vpn configuration. |
| addons.vpn.securityContext | object | See values.yaml | Set the VPN container securityContext |
| addons.vpn.type | string | `"openvpn"` | Specify the VPN type. Valid options are openvpn or wireguard |
| addons.vpn.wireguard | object | See below | WireGuard specific configuration |
| addons.vpn.wireguard.image.pullPolicy | string | `"IfNotPresent"` | Specify the WireGuard image pull policy |
| addons.vpn.wireguard.image.repository | string | `"docker pull ghcr.io/k8s-at-home/wireguard"` | Specify the WireGuard image |
| addons.vpn.wireguard.image.tag | string | `"v1.0.20210424"` | Specify the WireGuard image tag |
| affinity | object | `{}` | Defines affinity constraint rules. [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| args | list | `[]` | Override the args for the default container |
| autoscaling | object | <disabled> | Add a Horizontal Pod Autoscaler |
| command | list | `[]` | Override the command(s) for the default container |
| controller.annotations | object | `{}` | Set annotations on the deployment/statefulset/daemonset |
| controller.labels | object | `{}` | Set labels on the deployment/statefulset/daemonset |
| controller.replicas | int | `1` | Number of desired pods |
| controller.revisionHistoryLimit | int | `3` | ReplicaSet revision history limit |
| controller.rollingUpdate.partition | string | `nil` | Set statefulset RollingUpdate partition |
| controller.rollingUpdate.surge | string | `nil` | Set deployment RollingUpdate max surge |
| controller.rollingUpdate.unavailable | string | `nil` | Set deployment RollingUpdate max unavailable |
| controller.strategy | string | `nil` | Set the controller upgrade strategy For Deployments, valid values are Recreate (default) and RollingUpdate. For StatefulSets, valid values are OnDelete and RollingUpdate (default). DaemonSets ignore this. |
| controller.type | string | `"deployment"` | Set the controller type. Valid options are deployment, daemonset or statefulset |
| dnsConfig | object | `{}` | Optional DNS settings, configuring the ndots option may resolve nslookup issues on some Kubernetes setups. |
| dnsPolicy | string | `nil` | Defaults to "ClusterFirst" if hostNetwork is false and "ClusterFirstWithHostNet" if hostNetwork is true. |
| enableServiceLinks | bool | `true` | Enable/disable the generation of environment variables for services. [[ref]](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#accessing-the-service) |
| env | string | `nil` | Main environment variables. Template enabled. Syntax options: A) TZ: UTC B) PASSWD: '{{ .Release.Name }}' C) PASSWD:      envFrom:        ... D) - name: TZ      value: UTC E) - name: TZ      value: '{{ .Release.Name }}' |
| fullnameOverride | string | `""` |  |
| global.fullnameOverride | string | `nil` | Set the entire name definition |
| global.nameOverride | string | `nil` | Set an override for the prefix of the fullname |
| hostAliases | list | `[]` | Use hostAliases to add custom entries to /etc/hosts - mapping IP addresses to hostnames. [[ref]](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/) |
| hostNetwork | bool | `false` | When using hostNetwork make sure you set dnsPolicy to `ClusterFirstWithHostNet` |
| hostPathMounts | list | `[]` | Mount a path on the host to the main container. |
| hostname | string | `nil` | Allows specifying explicit hostname setting |
| image.pullPolicy | string | `nil` |  |
| image.repository | string | `nil` |  |
| image.tag | string | `nil` |  |
| ingress | object | See below | Configure the ingresses for the chart here. Additional ingresses can be added by adding a dictionary key similar to the 'main' ingress. |
| ingress.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| ingress.main.enabled | bool | `false` | Enables or disables the ingress |
| ingress.main.hosts[0].host | string | `"chart-example.local"` | Host address. Template enabled. |
| ingress.main.hosts[0].paths[0].path | string | `"/"` | Path. Template enabled. |
| ingress.main.hosts[0].paths[0].pathType | string | `"Prefix"` | Ignored if not kubeVersion >= 1.14-0 |
| ingress.main.hosts[0].paths[0].service.name | string | `nil` | Overrides the service name reference for this path |
| ingress.main.hosts[0].paths[0].service.port | string | `nil` | Overrides the service port reference for this path |
| ingress.main.ingressClassName | string | `nil` | Set the ingressClass that is used for this ingress. Requires Kubernetes >=1.19 |
| ingress.main.labels | object | `{}` | Provide additional labels which may be required. |
| ingress.main.nameOverride | string | `nil` | Override the name suffix that is used for this ingress. |
| ingress.main.primary | bool | `true` | Make this the primary ingress (used in probes, notes, etc...). If there is more than 1 ingress, make sure that only 1 ingress is marked as primary. |
| ingress.main.tls | list | `[]` | Configure TLS for the ingress. Both secretName and hosts are template enabled. |
| initContainers | list | `[]` | Specify any initContainers here. Yaml will be passed in to the Pod as-is. |
| lifecycle | object | `{}` | Configure the lifecycle for the main container |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | Node selection constraint [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistence | object | See below | Configure the persistent volumes for the chart here. Additional items can be added by adding a dictionary key similar to the 'config' key. |
| persistence.config | object | See below | Default persistence for configuration files. |
| persistence.config.accessMode | string | `"ReadWriteOnce"` | AccessMode for the persistent volume. Make sure to select an access mode that is supported by your storage provider! [[ref]](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| persistence.config.emptyDir.enabled | bool | `false` | Create an emptyDir volume instead of a persistent volume. [[ref]] (https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) |
| persistence.config.enabled | bool | `false` | Enables or disables the persistent volume |
| persistence.config.existingClaim | string | `nil` | If you want to reuse an existing claim, the name of the existing PVC can be passed here. |
| persistence.config.mountPath | string | `"/config"` | Where to mount the volume in the main container. |
| persistence.config.nameOverride | string | `nil` | Override the name suffix that is used for this volume. |
| persistence.config.size | string | `"1Gi"` | The amount of storage that is requested for the persistent volume. |
| persistence.config.storageClass | string | `nil` | Storage Class for the config volume. If set to `-`, dynamic provisioning is disabled. If set to `SCALE-ZFS`, the default provisioner for TrueNAS SCALE is used. If set to something else, the given storageClass is used. If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner. |
| persistence.config.subPath | string | `nil` | Used in conjunction with `existingClaim`. Specifies a sub-path inside the referenced volume instead of its root |
| persistence.shared.enabled | bool | `false` | Create an emptyDir volume to share between all containers |
| persistence.shared.mountPath | string | `"/shared"` | Where to mount the shared volume in the main container. |
| podAnnotations | object | `{}` | Set annotations on the pod |
| podSecurityContext | object | `{}` | Configure the Security Context for the Pod |
| priorityClassName | string | `nil` | Custom priority class for different treatment by the scheduler |
| probes | object | See below | Probe configuration -- [[ref]](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| probes.liveness | object | See below | Liveness probe configuration |
| probes.liveness.custom | bool | `false` | Set this to `true` if you wish to specify your own livenessProbe |
| probes.liveness.enabled | bool | `true` | Enable the liveness probe |
| probes.liveness.spec | object | See below | The spec field contains the values for the default livenessProbe. If you selected `custom: true`, this field holds the definition of the livenessProbe. |
| probes.readiness | object | See below | Redainess probe configuration |
| probes.readiness.custom | bool | `false` | Set this to `true` if you wish to specify your own readinessProbe |
| probes.readiness.enabled | bool | `true` | Enable the readiness probe |
| probes.readiness.spec | object | See below | The spec field contains the values for the default readinessProbe. If you selected `custom: true`, this field holds the definition of the readinessProbe. |
| probes.startup | object | See below | Startup probe configuration |
| probes.startup.custom | bool | `false` | Set this to `true` if you wish to specify your own startupProbe |
| probes.startup.enabled | bool | `true` | Enable the startup probe |
| probes.startup.spec | object | See below | The spec field contains the values for the default startupProbe. If you selected `custom: true`, this field holds the definition of the startupProbe. |
| resources | object | `{}` | Set the resource requests / limits for the main container. |
| schedulerName | string | `nil` | Allows specifying a custom scheduler name |
| secret | object | `{}` | Use this to populate a secret with the values you specify. Be aware that these values are not encrypted by default, and could therefore visible to anybody with access to the values.yaml file. |
| securityContext | object | `{}` | Configure the Security Context for the main container |
| service | object | See below | Configure the services for the chart here. Additional services can be added by adding a dictionary key similar to the 'main' service. |
| service.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| service.main.enabled | bool | `true` | Enables or disables the service |
| service.main.labels | object | `{}` | Provide additional labels which may be required. |
| service.main.nameOverride | string | `nil` | Override the name suffix that is used for this service |
| service.main.ports | object | See below | Configure the Service port information here. Additional ports can be added by adding a dictionary key similar to the 'http' service. |
| service.main.ports.http.enabled | bool | `true` | Enables or disables the port |
| service.main.ports.http.nodePort | string | `nil` | Specify the nodePort value for the LoadBalancer and NodePort service types. [[ref]](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) |
| service.main.ports.http.port | string | `nil` | The port number |
| service.main.ports.http.primary | bool | `true` | Make this the primary port (used in probes, notes, etc...) If there is more than 1 service, make sure that only 1 port is marked as primary. |
| service.main.ports.http.protocol | string | `"HTTP"` | Port protocol. Support values are `HTTP`, `HTTPS`, `TCP` and `UDP`. HTTPS and HTTPS spawn a TCP service and get used for internal URL and name generation |
| service.main.ports.http.targetPort | string | `nil` | Specify a service targetPort if you wish to differ the service port from the application port. If `targetPort` is specified, this port number is used in the container definition instead of the `port` value. Therefore named ports are not supported for this field. |
| service.main.primary | bool | `true` | Make this the primary service (used in probes, notes, etc...). If there is more than 1 service, make sure that only 1 service is marked as primary. |
| service.main.type | string | `"ClusterIP"` | Set the service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Specify taint tolerations [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| volumeClaimTemplates | list | `[]` | Used in conjunction with `controller.type: statefulset` to create individual disks for each instance. |

## Changelog

All notable changes to this library Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [3.0.0]

#### Added

- It is now possible to flag an ingress / service / port as primary. This will then be used
  by default in the chart notes, probes, etc.
- Individual ports can now be enabled / disabled.
- Annotated the values.yaml to better describe what fields do. This is also reflected in the [README.md](README.md) file.

#### Changed

- Probes are now automatically disabled (except for custom defined probes) when no service is enabled.
- Moved the primary ingress from `ingress` to `ingress.main`.
- Moved the primary service from `service` to `service.main`.
- Multiple ingress objects can now be specified under the `ingress` key.
- Multiple service objects can now be specified under the `ingress` key.
- `nameSuffix` has been renamed to `nameOverride`.

#### Fixed

- Cleaned up YAML document separators (`---`).
- Fixed indenting of the `lifecycle` field.

#### Removed

- Removed support for `ingress.additionalIngresses`

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

[3.0.0]: #3.0.0
[2.5.0]: #2.5.0
[2.4.0]: #2.4.0
[2.3.1]: #2.3.1
[2.3.0]: #2.3.0
[2.2.0]: #2.2.0
[2.1.0]: #2.1.0
[2.0.1]: #2.0.1
[2.0.0]: #2.0.0
[1.0.0]: #1.0.0

## Support

- See the [Docs](https://docs.k8s-at-home.com/our-helm-charts/getting-started/)
- Open an [issue](https://github.com/k8s-at-home/charts/issues/new/choose)
- Ask a [question](https://github.com/k8s-at-home/organization/discussions)
- Join our [Discord](https://discord.gg/sTMX7Vh) community

