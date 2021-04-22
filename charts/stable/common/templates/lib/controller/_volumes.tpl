{{/*
Volumes included by the controller.
*/}}
{{- define "common.controller.volumes" -}}
{{- range $index, $persistence := .Values.persistence }}
{{- if $persistence.enabled }}
- name: {{ $index }}
{{- if $persistence.existingClaim }}
{{- /* Always prefer an existingClaim if that is set */}}
  persistentVolumeClaim:
    claimName: {{ $persistence.existingClaim }}
{{- else -}}
  {{- /* Always prefer an emptyDir next if that is set */}}
  {{- $emptyDir := false -}}
  {{- if $persistence.emptyDir -}}
    {{- if $persistence.emptyDir.enabled -}}
      {{- $emptyDir = true -}}
    {{- end -}}
  {{- end -}}
  {{- if $emptyDir }}
  {{- if or $persistence.emptyDir.medium $persistence.emptyDir.sizeLimit }}
  emptyDir:
    {{- with $persistence.emptyDir.medium }}
    medium: "{{ . }}"
    {{- end }}
    {{- with $persistence.emptyDir.sizeLimit }}
    sizeLimit: "{{ . }}"
    {{- end }}
  {{- else }}
  emptyDir: {}
  {{- end }}
  {{- else -}}
  {{- /* Otherwise refer to the PVC name */}}
  {{- $pvcName := (include "common.names.fullname" $) -}}
  {{- if $persistence.nameSuffix -}}
    {{- if not (eq $persistence.nameSuffix "-") -}}
      {{- $pvcName = (printf "%s-%s" (include "common.names.fullname" $) $persistence.nameSuffix) -}}
    {{- end -}}
  {{- else -}}
    {{- $pvcName = (printf "%s-%s" (include "common.names.fullname" $) $index) -}}
  {{- end }}
  persistentVolumeClaim:
    claimName: {{ $pvcName }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- if .Values.additionalVolumes }}
  {{- toYaml .Values.additionalVolumes | nindent 0 }}
{{- end }}


{{/*
Creates Volumes for hostPaths which can be directly mounted to a container
*/}}
{{- range $name, $hpm := .Values.hostPathMounts -}}
{{ if $hpm.enabled }}
{{ if $hpm.name }}
{{ $name = $hpm.name }}
{{ end }}
- name: customstorage-{{ $name }}
  {{ if $hpm.emptyDir }}
  emptyDir: {}
  {{- else -}}
  hostPath:
    path: {{ required "hostPath not set" $hpm.hostPath }}
  {{ end }}
{{ end }}
{{- end -}}

{{- end -}}
