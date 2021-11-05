{{/*
The ConfigMap object to be generated.
*/}}
{{- define "common.configmap" }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
{{- with .Values.configmap.configData }}
data:
  {{ .configKey }}: |-
  {{ .configValue | trim | nindent 4 }}
{{- end }}
{{- end }}
