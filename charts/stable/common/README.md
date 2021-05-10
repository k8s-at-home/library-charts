# common

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

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
| addons.codeserver.image.tag | string | `"3.9.2"` |  |
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
| addons.codeserver.service.ports.codeserver.enabled | bool | `true` |  |
| addons.codeserver.service.ports.codeserver.port | int | `12321` |  |
| addons.codeserver.service.ports.codeserver.protocol | string | `"TCP"` |  |
| addons.codeserver.service.ports.codeserver.targetPort | string | `"codeserver"` |  |
| addons.codeserver.service.type | string | `"ClusterIP"` |  |
| addons.codeserver.volumeMounts | list | `[]` |  |
| addons.codeserver.workingDir | string | `""` |  |
| addons.promtail.args | list | `[]` |  |
| addons.promtail.enabled | bool | `false` |  |
| addons.promtail.env | object | `{}` |  |
| addons.promtail.image.pullPolicy | string | `"IfNotPresent"` |  |
| addons.promtail.image.repository | string | `"grafana/promtail"` |  |
| addons.promtail.image.tag | string | `"2.2.0"` |  |
| addons.promtail.logs | list | `[]` |  |
| addons.promtail.loki | string | `""` |  |
| addons.promtail.securityContext.runAsUser | int | `0` |  |
| addons.promtail.volumeMounts | list | `[]` |  |
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
| args | list | `[]` | Override the args for the default container |
| autoscaling.enabled | bool | `false` | Add a Horizontal Pod Autoscaler |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.target | string | `nil` | Optional: overrides the default deploymentname |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| command | list | `[]` | Override the command(s) for the default container |
| controllerAnnotations | object | `{}` | Set annotations on the deployment/statefulset/daemonset |
| controllerLabels | object | `{}` | Set labels on the deployment/statefulset/daemonset |
| controllerType | string | `"deployment"` | Set the controller type. Valid options are deployment, daemonset or statefulset |
| dnsConfig | object | `{}` | Optional DNS settings, configuring the ndots option may resolve nslookup issues on some Kubernetes setups. |
| dnsPolicy | string | `nil` | Defaults to "ClusterFirst" if hostNetwork is false and "ClusterFirstWithHostNet" if hostNetwork is true. |
| enableServiceLinks | bool | `true` | Enable/disable the generation of environment variables for services. [ref](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#accessing-the-service) |
| env | object | `{}` | Main environment variables. |
| envFrom | list | `[]` | Environment variables that can be loaded from Secrets or ConfigMaps. [ref](https://unofficial-kubernetes.readthedocs.io/en/latest/tasks/configure-pod-container/configmap/#use-case-consume-configmap-in-environment-variables) |
| envList | list | `[]` | Additional environment variables from a list. |
| envTpl | object | `{}` | Environment variables with values set from Helm templates |
| envValueFrom | object | `{}` | Variables with values from (for example) the Downward API [ref](https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/) |
| fullnameOverride | string | `""` |  |
| hostAliases | list | `[]` |  |
| hostNetwork | bool | `false` | When using hostNetwork make sure you set dnsPolicy to `ClusterFirstWithHostNet` |
| hostname | string | `nil` | Allows specifying explicit hostname setting |
| ingress | object | See below | Configure the ingresses for the chart here. Additional ingresses can be added by adding a dictionary key similar to the 'main' ingress. |
| ingress.main.annotations | object | `{}` | Provide additional annotations which may be required. |
| ingress.main.enabled | bool | `false` | Enables or disables the ingress |
| ingress.main.hosts[0].host | string | `"chart-example.local"` | Host address |
| ingress.main.hosts[0].hostTpl | string | `nil` | A Helm template that is evaluated |
| ingress.main.hosts[0].paths[0].path | string | `"/"` | Path |
| ingress.main.hosts[0].paths[0].pathTpl | string | `nil` | A Helm template that is evaluated |
| ingress.main.hosts[0].paths[0].pathType | string | `"Prefix"` | Ignored if not kubeVersion >= 1.14-0 |
| ingress.main.hosts[0].paths[0].serviceName | string | `nil` | Overrides the service name reference for this path |
| ingress.main.hosts[0].paths[0].servicePort | string | `nil` | Overrides the service port reference for this path |
| ingress.main.ingressClassName | string | `nil` | Set the ingressClass that is used for this ingress. Requires Kubernetes >=1.19 |
| ingress.main.labels | object | `{}` | Provide additional labels which may be required. |
| ingress.main.nameOverride | string | `nil` | Override the name suffix that is used for this ingress. |
| ingress.main.primary | bool | `true` | Make this the primary ingress (used in probes, notes, etc...). If there is more than 1 ingress, make sure that only 1 ingress is marked as primary. |
| ingress.main.tls | list | `[]` | Configure TLS for the ingress |
| initContainers | list | `[]` |  |
| lifecycle | object | `{}` | Configure the lifecycle for the main container |
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
| podAnnotations | object | `{}` | Set annotations on the pod |
| podSecurityContext | object | `{}` | Configure the Security Context for the Pod |
| priorityClassName | string | `nil` | Custom priority class for different treatment by the scheduler |
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
| service.main.ports.http.nodePort | string | `nil` | Specify the nodePort value for the LoadBalancer and NodePort service types. [ref](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) |
| service.main.ports.http.port | string | `nil` | The port number |
| service.main.ports.http.primary | bool | `true` | Make this the primary port (used in probes, notes, etc...) If there is more than 1 service, make sure that only 1 port is marked as primary. |
| service.main.ports.http.protocol | string | `"HTTP"` | Port protocol. Support values are `HTTP`, `HTTPS`, `TCP` and `UDP`. HTTPS and HTTPS spawn a TCP service and get used for internal URL and name generation |
| service.main.ports.http.targetPort | string | `nil` | Specify a service targetPort if you wish to differ the service port from the application port. If `targetPort` is specified, this port number is used in the container definition instead of the `port` value. Therefore named ports are not supported for this field. |
| service.main.primary | bool | `true` | Make this the primary service (used in probes, notes, etc...). If there is more than 1 service, make sure that only 1 service is marked as primary. |
| service.main.type | string | `"ClusterIP"` | Set the service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| strategy.type | string | `"RollingUpdate"` | Set the controller upgrade strategy For Deployments, valid values are Recreate and RollingUpdate. For StatefulSets, valid values are OnDelete and RollingUpdate. DaemonSets ignore this. |
| tolerations | list | `[]` |  |
| volumeClaimTemplates | list | `[]` |  |

## Changelog

All notable changes to this application Helm chart will be documented in this file but does not include changes from our common library. To read those click [here](../common/README.md).

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [3.0.0]

#### Changed

- Moved the primary ingress from `ingress` to `ingress.main`.
- Multiple ingress objects can now be specified under the `ingress` key.

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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
