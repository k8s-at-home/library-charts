{{/*
The volume (referencing honeytail config) to be inserted into additionalVolumes.
*/}}
{{- define "common.addon.honeytail.configVolumeSpec" -}}
{{- if or .Values.addons.honeytail.configFile .Values.addons.honeytail.configFileSecret -}}
secret:
  {{- if .Values.addons.honeytail.configFileSecret }}
  secretName: {{ .Values.addons.honeytail.configFileSecret }}
  {{- else }}
  secretName: {{ include "common.names.fullname" . }}-honeytailconfig
  {{- end }}
  items:
    - key: honeytailConfigfile
      path: honeytailConfigfile
{{- end -}}
{{- end -}}
