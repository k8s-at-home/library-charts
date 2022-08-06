{{/*
The OpenVPN config secret to be included.
*/}}
{{- define "common.addon.honeytail.secret" -}}
{{- if and .Values.addons.honeytail.configFile (not .Values.addons.honeytail.configFileSecret) }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.names.fullname" . }}-honeytailconfig
  labels:
    configsecret: honeytail
    {{- include "common.labels" $ | nindent 4 }}
stringData:
  {{- with .Values.addons.honeytail.configFile }}
  honeytailConfigfile: |-
    {{- . | nindent 4}}
  {{- end }}
{{- end -}}
{{- end -}}