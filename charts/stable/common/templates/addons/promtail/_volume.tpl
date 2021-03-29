{{/*
The volume (referencing VPN config and scripts) to be inserted into additionalVolumes.
*/}}
{{- define "common.addon.promtail.volume" -}}
name: promtail-config
configMap:
  name: {{ include "common.names.fullname" . }}-promtail
{{- end -}}
