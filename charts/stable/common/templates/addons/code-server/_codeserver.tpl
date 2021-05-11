{{/*
Template to render code-server addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "common.addon.codeserver" -}}
{{- if .Values.addons.codeserver.enabled -}}
  {{/* Append the code-server container to the additionalContainers */}}
  {{- $container := include "common.addon.codeserver.container" . | fromYaml -}}
  {{- if $container -}}
    {{- $additionalContainers := append .Values.additionalContainers $container -}}
    {{- $_ := set .Values "additionalContainers" $additionalContainers -}}
  {{- end -}}

  {{/* Include the deployKeySecret if not empty */}}
  {{- $secret := include "common.addon.codeserver.deployKeySecret" . -}}
  {{- if $secret -}}
    {{- $secret | nindent 0 -}}
  {{- end -}}

  {{/* Append the secret volume to the additionalVolumes */}}
  {{- $volume := include "common.addon.codeserver.deployKeyVolume" . | fromYaml -}}
  {{- if $volume -}}
    {{- $additionalVolumes := append .Values.additionalVolumes $volume }}
    {{- $_ := set .Values "additionalVolumes" $additionalVolumes -}}
  {{- end -}}

  {{/* Add the code-server service */}}
  {{- if .Values.addons.codeserver.service.enabled -}}
    {{- $serviceValues := .Values.addons.codeserver.service -}}
    {{- if not $serviceValues.nameOverride -}}
        {{- $_ := set $serviceValues "nameOverride" "codeserver" -}}
    {{ end -}}
    {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
    {{- include "common.classes.service" $ -}}
    {{- $_ := unset $ "ObjectValues" -}}
  {{- end -}}

  {{/* Add the code-server ingress */}}
  {{- if .Values.addons.codeserver.ingress.enabled -}}
    {{- $ingressValues := .Values.addons.codeserver.ingress -}}
    {{- if not $ingressValues.nameOverride -}}
        {{- $_ := set $ingressValues "nameOverride" "codeserver" -}}
    {{ end -}}

    {{/* Determine the target service name & port */}}
    {{- $svcName := printf "%v-%v" (include "common.names.fullname" .) .Values.addons.codeserver.service.nameOverride -}}
    {{- $_ := set $ingressValues "serviceName" $svcName -}}
    {{- $_ := set $ingressValues "servicePort" .Values.addons.codeserver.service.ports.codeserver.port -}}

    {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
    {{- include "common.classes.ingress" $ -}}
    {{- $_ := unset $ "ObjectValues" -}}
  {{- end -}}
{{- end -}}
{{- end -}}
