{{/* Expand the name of the chart */}}
{{- define "common.names.name" -}}
  {{- default .Chart.Name (default .Values.nameOverride .Values.global.nameOverride) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.names.fullname" -}}
  {{- $name := include "common.names.name" . -}}
  {{- if or .Values.fullnameOverride .Values.global.fullnameOverride -}}
    {{- $name = default .Values.fullnameOverride .Values.global.fullnameOverride -}}
  {{- else -}}
    {{- if contains $name .Release.Name -}}
      {{- $name := .Release.Name -}}
    {{- else -}}
      {{- $name := printf "%s-%s" .Release.Name $name -}}
    {{- end -}}
  {{- end -}}
  {{- trunc 63 $name | trimSuffix "-" -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label */}}
{{- define "common.names.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create the name of the ServiceAccount to use */}}
{{- define "common.names.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create -}}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
  {{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
  {{- end -}}
{{- end -}}

{{/* Return the properly cased version of the controller type */}}
{{- define "common.names.controllerType" -}}
  {{- if eq .Values.controller.type "deployment" -}}
    {{- print "Deployment" -}}
  {{- else if eq .Values.controller.type "daemonset" -}}
    {{- print "DaemonSet" -}}
  {{- else if eq .Values.controller.type "statefulset"  -}}
    {{- print "StatefulSet" -}}
  {{ else }}
    {{- fail (printf "Not a valid controller.type (%s)" .Values.controller.type) }}
  {{- end -}}
{{- end -}}
