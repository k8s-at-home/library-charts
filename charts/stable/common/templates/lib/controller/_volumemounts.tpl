{{/*
Volumes included by the controller.
*/}}
{{- define "common.controller.volumeMounts" -}}

{{- range $index, $PVC := .Values.persistence }}
{{- if $PVC.enabled }}
- mountPath: {{ $PVC.mountPath | default (printf "/%v" $index) }}
  name: {{ $index }}
{{- if $PVC.subPath }}
  subPath: {{ $PVC.subPath }}
{{- end }}
{{- end }}
{{- end }}

{{- if .Values.additionalVolumeMounts }}
{{- toYaml .Values.additionalVolumeMounts | nindent 0 }}
{{- end }}

{{- if eq .Values.controllerType "statefulset"  }}
{{- range $index, $vct := .Values.volumeClaimTemplates }}
- mountPath: {{ $vct.mountPath }}
  name: {{ $vct.name }}
{{- if $vct.subPath }}
  subPath: {{ $vct.subPath }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Creates mountpoints to mount hostPaths directly to the container
*/}}
{{ range $name, $hpm := .Values.hostPathMounts }}
{{- if $hpm.enabled -}}
{{ if $hpm.name }}
  {{ $name = $hpm.name }}
{{ end }}
- name: hostpathmounts-{{ $name }}
  mountPath: {{ $hpm.mountPath }}
  {{ if $hpm.subPath }}
  subPath: {{ $hpm.subPath }}
  {{ end }}
  {{ if $hpm.readOnly }}
  readOnly: {{ $hpm.readOnly }}
  {{ end }}
{{- end -}}
{{ end }}

{{- end -}}
