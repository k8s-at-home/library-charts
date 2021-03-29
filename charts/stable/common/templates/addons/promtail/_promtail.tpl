{{/*
Template to render promtail addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "common.addon.promtail" -}}
{{- if .Values.addons.promtail.enabled -}}
  {{/* Append the promtail container to the additionalContainers */}}
  {{- $container := include "common.addon.promtail.container" . | fromYaml -}}
  {{- if $container -}}
    {{- $additionalContainers := append .Values.additionalContainers $container -}}
    {{- $_ := set .Values "additionalContainers" $additionalContainers -}}
  {{- end -}}

  {{/* Include the configmap if not empty */}}
  {{- $configmap := include "common.addon.promtail.configmap" . -}}
  {{- if $configmap -}}
    {{- print "---" | nindent 0 -}}
    {{- $configmap | nindent 0 -}}
  {{- end -}}

  {{/* Append the promtail config volume to the additionalVolumes */}}
  {{- $volume := include "common.addon.promtail.volume" . | fromYaml -}}
  {{- if $volume -}}
    {{- $additionalVolumes := append .Values.additionalVolumes $volume }}
    {{- $_ := set .Values "additionalVolumes" $additionalVolumes -}}
  {{- end -}}
{{- end -}}
{{- end -}}
