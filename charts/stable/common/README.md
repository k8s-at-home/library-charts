# common

![Version: 4.3.0](https://img.shields.io/badge/Version-4.3.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

Function library for k8s-at-home charts

Since a lot of the k8s-at-home charts follow a similar pattern, this library was built to reduce maintenance cost between the charts that use it and try achieve a goal of being DRY.

## Requirements

Kubernetes: `>=1.16.0-0`

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
| additionalContainers | object | `{}` | Specify any additional containers here as dictionary items. Each additional container should have its own key. Helm templates can be used. |
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
| addons.codeserver.service.ipFamilies | list | `["IPv4"]` | The ip families that should be used. Options: IPv4, IPv6 |
| addons.codeserver.service.ipFamilyPolicy | string | `"SingleStack"` | Specify the ip policy. Options: SingleStack, PreferDualStack, RequireDualStack |
| addons.codeserver.volumeMounts | list | `[]` | Specify a list of volumes that get mounted in the code-server container. At least 1 volumeMount is required! |
| addons.codeserver.workingDir | string | `""` | Specify the working dir that will be opened when code-server starts If not given, the app will default to the mountpah of the first specified volumeMount |
| addons.netshoot | object | See values.yaml | The common library supports adding a netshoot add-on to troubleshoot network issues within a Pod. It can be configured under this key. |
| addons.netshoot.enabled | bool | `false` | Enable running a netshoot container in the pod |
| addons.netshoot.env | object | `{}` | Set any environment variables for netshoot here |
| addons.netshoot.image.pullPolicy | string | `"Always"` | Specify the netshoot image pull policy |
| addons.netshoot.image.repository | string | `"nicolaka/netshoot"` | Specify the netshoot image |
| addons.netshoot.image.tag | string | `"latest"` | Specify the netshoot image tag |
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
| addons.vpn.configFileSecret | string | `nil` | Reference an existing secret that contains the VPN configuration file The chart expects it to be present under the `vpnConfigfile` key. |
| addons.vpn.enabled | bool | `false` | Enable running a VPN in the pod to route traffic through a VPN |
| addons.vpn.env | object | `{}` | All variables specified here will be added to the vpn sidecar container See the documentation of the VPN image for all config values |
| addons.vpn.livenessProbe | object | `{}` | Optionally specify a livenessProbe, e.g. to check if the connection is still being protected by the VPN |
| addons.vpn.networkPolicy.annotations | object | `{}` | Provide additional annotations which may be required. |
| addons.vpn.networkPolicy.egress | string | `nil` | The egress configuration for your network policy, All outbound traffic from the pod will be blocked unless specified here. [[ref]](https://kubernetes.io/docs/concepts/services-networking/network-policies/) [[recipes]](https://github.com/ahmetb/kubernetes-network-policy-recipes) |
| addons.vpn.networkPolicy.enabled | bool | `false` | If set to true, will deploy a network policy that blocks all outbound traffic except traffic specified as allowed |
| addons.vpn.networkPolicy.labels | object | `{}` | Provide additional labels which may be required. |
| addons.vpn.networkPolicy.podSelectorLabels | object | `{}` | Provide additional podSelector labels which may be required. |
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
| addons.vpn.wireguard.image.repository | string | `"ghcr.io/k8s-at-home/wireguard"` | Specify the WireGuard image |
| addons.vpn.wireguard.image.tag | string | `"v1.0.20210914"` | Specify the WireGuard image tag |
| affinity | object | `{}` | Defines affinity constraint rules. [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| args | list | `[]` | Override the args for the default container |
| automountServiceAccountToken | bool | `true` | Specifies whether a service account token should be automatically mounted. |
| autoscaling | object | <disabled> | Add a Horizontal Pod Autoscaler |
| command | list | `[]` | Override the command(s) for the default container |
| configmap | object | See below | Configure configMaps for the chart here. Additional configMaps can be added by adding a dictionary key similar to the 'config' object. |
| configmap.config.annotations | object | `{}` | Annotations to add to the configMap |
| configmap.config.data | object | `{}` | configMap data content. Helm template enabled. |
| configmap.config.enabled | bool | `false` | Enables or disables the configMap |
| configmap.config.labels | object | `{}` | Labels to add to the configMap |
| controller.annotations | object | `{}` | Set annotations on the deployment/statefulset/daemonset |
| controller.enabled | bool | `true` | enable the controller. |
| controller.labels | object | `{}` | Set labels on the deployment/statefulset/daemonset |
| controller.podManagementPolicy | string | `nil` | Set statefulset podManagementPolicy, valid values are Parallel and OrderedReady (default). |
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
| env | string | `nil` | Main environment variables. Template enabled. Syntax options: A) TZ: UTC B) PASSWD: '{{ .Release.Name }}' C) PASSWD:      configMapKeyRef:        name: config-map-name        key: key-name D) PASSWD:      valueFrom:        secretKeyRef:          name: secret-name          key: key-name      ... E) - name: TZ      value: UTC F) - name: TZ      value: '{{ .Release.Name }}' |
| envFrom | list | `[]` | Secrets and/or ConfigMaps that will be loaded as environment variables. [[ref]](https://unofficial-kubernetes.readthedocs.io/en/latest/tasks/configure-pod-container/configmap/#use-case-consume-configmap-in-environment-variables) |
| global.fullnameOverride | string | `nil` | Set the entire name definition |
| global.nameOverride | string | `nil` | Set an override for the prefix of the fullname |
| hostAliases | list | `[]` | Use hostAliases to add custom entries to /etc/hosts - mapping IP addresses to hostnames. [[ref]](https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/) |
| hostNetwork | bool | `false` | When using hostNetwork make sure you set dnsPolicy to `ClusterFirstWithHostNet` |
| hostname | string | `nil` | Allows specifying explicit hostname setting |
| image.pullPolicy | string | `nil` | image pull policy |
| image.repository | string | `nil` | image repository |
| image.tag | string | `nil` | image tag |
| ingress | object | See below | Configure the ingresses for the chart here. Additional ingresses can be added by adding a dictionary key similar to the 'main' ingress. |
| ingress.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| ingress.main.enabled | bool | `false` | Enables or disables the ingress |
| ingress.main.hosts[0].host | string | `"chart-example.local"` | Host address. Helm template can be passed. |
| ingress.main.hosts[0].paths[0].path | string | `"/"` | Path.  Helm template can be passed. |
| ingress.main.hosts[0].paths[0].pathType | string | `"Prefix"` | Ignored if not kubeVersion >= 1.14-0 |
| ingress.main.hosts[0].paths[0].service.name | string | `nil` | Overrides the service name reference for this path |
| ingress.main.hosts[0].paths[0].service.port | string | `nil` | Overrides the service port reference for this path |
| ingress.main.ingressClassName | string | `nil` | Set the ingressClass that is used for this ingress. Requires Kubernetes >=1.19 |
| ingress.main.labels | object | `{}` | Provide additional labels which may be required. |
| ingress.main.nameOverride | string | `nil` | Override the name suffix that is used for this ingress. |
| ingress.main.primary | bool | `true` | Make this the primary ingress (used in probes, notes, etc...). If there is more than 1 ingress, make sure that only 1 ingress is marked as primary. |
| ingress.main.tls | list | `[]` | Configure TLS for the ingress. Both secretName and hosts can process a Helm template. |
| initContainers | object | `{}` | Specify any initContainers here as dictionary items. Each initContainer should have its own key. The dictionary item key will determine the order. Helm templates can be used. |
| lifecycle | object | `{}` | Configure the lifecycle for the main container |
| nodeSelector | object | `{}` | Node selection constraint [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistence | object | See below | Configure persistence for the chart here. Additional items can be added by adding a dictionary key similar to the 'config' key. [[ref]](http://docs.k8s-at-home.com/our-helm-charts/common-library-storage) |
| persistence.config | object | See below | Default persistence for configuration files. |
| persistence.config.accessMode | string | `"ReadWriteOnce"` | AccessMode for the persistent volume. Make sure to select an access mode that is supported by your storage provider! [[ref]](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) |
| persistence.config.enabled | bool | `false` | Enables or disables the persistence item |
| persistence.config.existingClaim | string | `nil` | If you want to reuse an existing claim, the name of the existing PVC can be passed here. |
| persistence.config.mountPath | string | `nil` | Where to mount the volume in the main container. Defaults to `/<name_of_the_volume>`, setting to '-' creates the volume but disables the volumeMount. |
| persistence.config.nameOverride | string | `nil` | Override the name suffix that is used for this volume. |
| persistence.config.readOnly | bool | `false` | Specify if the volume should be mounted read-only. |
| persistence.config.retain | bool | `false` | Set to true to retain the PVC upon `helm uninstall` |
| persistence.config.size | string | `"1Gi"` | The amount of storage that is requested for the persistent volume. |
| persistence.config.storageClass | string | `nil` | Storage Class for the config volume. If set to `-`, dynamic provisioning is disabled. If set to something else, the given storageClass is used. If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner. |
| persistence.config.subPath | string | `nil` | Used in conjunction with `existingClaim`. Specifies a sub-path inside the referenced volume instead of its root |
| persistence.config.type | string | `"pvc"` | Sets the persistence type Valid options are pvc, emptyDir, hostPath, secret, configMap or custom |
| persistence.shared | object | See below | Create an emptyDir volume to share between all containers [[ref]]https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) |
| persistence.shared.medium | string | `nil` | Set the medium to "Memory" to mount a tmpfs (RAM-backed filesystem) instead of the storage medium that backs the node. |
| persistence.shared.sizeLimit | string | `nil` | If the `SizeMemoryBackedVolumes` feature gate is enabled, you can specify a size for memory backed volumes. |
| podAnnotations | object | `{}` | Set annotations on the pod |
| podLabels | object | `{}` | Set labels on the pod |
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
| runtimeClassName | string | `nil` | Allow specifying a runtimeClassName other than the default one (ie: nvidia) |
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
| termination.gracePeriodSeconds | string | `nil` | Duration in seconds the pod needs to terminate gracefully -- [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle)] |
| termination.messagePath | string | `nil` | Configure the path at which the file to which the main container's termination message will be written. -- [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle-1)] |
| termination.messagePolicy | string | `nil` | Indicate how the main container's termination message should be populated. Valid options are `File` and `FallbackToLogsOnError`. -- [[ref](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle-1)] |
| tolerations | list | `[]` | Specify taint tolerations [[ref]](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| topologySpreadConstraints | list | `[]` | Defines topologySpreadConstraint rules. [[ref]](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/) |
| volumeClaimTemplates | list | `[]` | Used in conjunction with `controller.type: statefulset` to create individual disks for each instance. |

## Changelog

All notable changes to this library Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [4.3.0]

#### Added

- Support setting `podManagementPolicy` on StatefulSet
- Support setting the `runtimeClassName` of pods

#### Changed

- Improved environment variables documentation to correctly reflect the available syntax options.

### [4.2.0]

#### Added

- Support for defining ipFamilyPolicy and ipFamilies in service resources

### [4.1.0]

#### Changed

- Updated Wireguard add-on image tag to `v1.0.20210914`.

#### Added

- Support for specifying whether a pod should auto mount a service account token.
- Support for specifying configMaps directly in values.yaml.
- Support for specifying annotations/labels on the VPN add-on `NetworkPolicy`.
- Support for specifying custom podSelector labels on the VPN add-on `NetworkPolicy`.
- Added `secret` and `configMap` as persistence types. [[ref]](http://docs.k8s-at-home.com/our-helm-charts/common-library-storage/).

### [4.0.1]

#### Fixed

- Fixed an issue where users weren't able to set custom ingress labels.

### [4.0.0]

#### Added

- Support for specifying container termination message path and policy (#77).
- Support for specifying Pod termination grace period.
- Support for specifying PVC labels for `persistence` items.

#### Changed

- **BREAKING**: Renamed the `skipuninstall` key to `retain` for `persistence` items.
- **BREAKING**: `initContainers` now expects a dictionary instead of a list to make merging less error-prone. initContainers are ordered by their key.
- **BREAKING**: `additionalContainers` now expects a dictionary instead of a list to make merging less error-prone.

### [3.3.0]

#### Added

- Support ability to specify the [mountPropagation](https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation) key under persistence items (https://github.com/k8s-at-home/library-charts/issues/74).

#### Changed

- Changed the docstring for `persistence` to better reference [our documentation](http://docs.k8s-at-home.com/our-helm-charts/common-library-storage/) regarding Storage options.

#### Fixed

- Fixed an issue where the default `repository` value for the Wireguard addon was incorrect (https://github.com/k8s-at-home/library-charts/issues/69).
- Fixed an issue where probes were not referencing the service `targetPort`.

### [3.2.0]

#### Added

- Support for specifying [topologySpreadConstraints](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/) for a pod.
- Support for specifying multiple `subPath` items under `persistence` keys.

#### Removed

- Removed persistence examples from the `values.yaml` file. These will be documented instead in [our documentation](http://docs.k8s-at-home.com/our-helm-charts/common-library/).

### [3.1.1]

#### Fixed

- Fixed an issue where the default service would not be determined correctly for Ingress objects.
- Fixed an issue where the code-server addon ingress would reference the wrong service when multiple hosts were specified (https://github.com/k8s-at-home/library-charts/issues/64).

### [3.1.0]

#### Added

- Support to disable the controller when no container is deployed.

#### Fixed

- Fixed an issue where the code-server addon ingress would reference the wrong service.

### [3.0.2]

#### Fixed

- Fixed an issue where the `common.names.fullname` template would not properly render.

### [3.0.1]

#### Fixed

- Fixed an issue where the `nameOverride` and `fullnameOverride` could throw an error.

### [3.0.0]

#### Added

- It is now possible to flag an ingress / service / port as primary. This will then be used
  by default in the chart notes, probes, etc.
- Individual ports can now be enabled / disabled.
- Allow setting Pod labels using the `podLabels` field.
- Allow setting `volumeName` for PVC's.
- Annotated the values.yaml to better describe what fields do. This is also reflected in the [README.md](README.md) file.
- Added a [netshoot](https://github.com/nicolaka/netshoot) add-on. This allows for injecting a network trouble-shooting swiss-army sidecar container.

#### Changed

- Probes are now automatically disabled (except for custom defined probes) when no service is enabled.
- Moved the primary ingress from `ingress` to `ingress.main`.
- Moved the primary service from `service` to `service.main`.
- Multiple ingress objects can now be specified under the `ingress` key.
- Multiple service objects can now be specified under the `service` key.
- `nameSuffix` has been renamed to `nameOverride`.
- `hostPathMounts` has been integrated with `persistence`.
- `additionalVolumes` has been integrated with `persistence`.
- Test framework has been rewritten from Ruby to Go.

#### Fixed

- Cleaned up YAML document separators (`---`).
- Fixed indenting of the `lifecycle` field.

#### Removed

- Removed support for `ingress.additionalIngresses`.
- Removed support for `services.additionalServices`.
- Removed support for TrueNAS SCALE features. These are out of scope for our project.

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

[4.0.0]: #400
[3.3.0]: #330
[3.2.0]: #320
[3.1.1]: #311
[3.1.0]: #310
[3.0.2]: #302
[3.0.1]: #301
[3.0.0]: #300
[2.5.0]: #250
[2.4.0]: #240
[2.3.1]: #231
[2.3.0]: #230
[2.2.0]: #220
[2.1.0]: #210
[2.0.1]: #201
[2.0.0]: #200
[1.0.0]: #100

## Support

- See the [Docs](https://docs.k8s-at-home.com/our-helm-charts/getting-started/)
- Open an [issue](https://github.com/k8s-at-home/charts/issues/new/choose)
- Ask a [question](https://github.com/k8s-at-home/organization/discussions)
- Join our [Discord](https://discord.gg/sTMX7Vh) community

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
