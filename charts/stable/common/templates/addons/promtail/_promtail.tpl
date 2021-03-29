{{/*
Template to render code-server addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "common.addon.promtail" -}}
{{- if .Values.addons.promtail.enabled -}}
  {{/* Append the code-server container to the additionalContainers */}}
  {{- $container := include "common.addon.promtail.container" . | fromYaml -}}
  {{- if $container -}}
    {{- $additionalContainers := append .Values.additionalContainers $container -}}
    {{- $_ := set .Values "additionalContainers" $additionalContainers -}}
  {{- end -}}
{{- end -}}
{{- end -}}
