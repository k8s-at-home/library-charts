{{/*
Template to render honeytail addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "common.addon.honeytail" -}}
{{- if .Values.addons.honeytail.enabled -}}
  {{/* Append the code-server container to the additionalContainers */}}
  {{- $container := include "common.addon.honeytail.container" . | fromYaml -}}
  {{- if $container -}}
    {{- $_ := set .Values.additionalContainers "addon-honeytail" $container -}}
  {{- end -}}

  {{/* Append the secret volume to the volumes */}}
  {{- $volume := include "common.addon.honeytail.configVolumeSpec" . | fromYaml -}}
  {{- if $volume -}}
    {{- $_ := set .Values.persistence "honeytail-conf" (dict "enabled" "true" "mountPath" "/honeytail-conf" "type" "custom" "volumeSpec" $volume) -}}
  {{- end -}}

  {{/* Include the secret if not empty */}}
  {{- $secret := include "common.addon.honeytail.secret" . -}}
  {{- if $secret -}}
    {{- $secret | nindent 0 -}}
  {{- end -}}
{{- end -}}
{{- end -}}
