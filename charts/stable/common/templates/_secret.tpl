{{/*
The Secret object to be created.
*/}}
{{- define "common.secret" -}}
{{- print ("---\n") | nindent 0 -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.names.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
type: Opaque
{{- with .Values.secret }}
stringData:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
