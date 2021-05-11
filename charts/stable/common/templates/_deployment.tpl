{{/*
This template serves as the blueprint for the Deployment objects that are created
within the common library.
*/}}
{{- define "common.deployment" -}}
{{- print ("---\n") | nindent 0 -}}
apiVersion: {{ include "common.capabilities.deployment.apiVersion" . }}
kind: Deployment
metadata:
  name: {{ include "common.names.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
    {{- with .Values.controllerLabels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.controllerAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  replicas: {{ .Values.replicas }}
  {{- with .Values.strategy }}
  {{- if and (ne .type "Recreate") (ne .type "RollingUpdate") }}
    {{- fail (printf "Not a valid strategy type for Deployment (%s)" .type) }}
  {{- end }}
  strategy:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  selector:
    matchLabels:
    {{- include "common.labels.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
      {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
      {{- include "common.labels.selectorLabels" . | nindent 8 }}
    spec:
      {{- include "common.controller.pod" . | nindent 6 }}
{{- end }}
