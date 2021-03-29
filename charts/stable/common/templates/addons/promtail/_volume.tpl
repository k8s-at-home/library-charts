{{/*
The volume (referencing config) to be inserted into additionalVolumes.
*/}}
{{- define "common.addon.promtail.volume" -}}
name: promtail-config
configMap:
  name: {{ include "common.names.fullname" . }}-promtail
{{- end -}}
