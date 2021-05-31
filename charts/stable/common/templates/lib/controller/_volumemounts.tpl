{{/* Volumes included by the controller */}}
{{- define "common.controller.volumeMounts" -}}
  {{- range $index, $item := .Values.persistence }}
    {{- if $item.enabled }}
      {{- $mountPath := (printf "/%v" $index) -}}
      {{- if eq "hostPath" (default "pvc" $item.type) -}}
        {{- $mountPath = $item.hostPath -}}
      {{- end -}}
      {{- with $item.mountPath -}}
        {{- $mountPath = . -}}
      {{- end }}
- mountPath: {{ $mountPath }}
  name: {{ $index }}
      {{- with $item.subPath }}
  subPath: {{ . }}
      {{- end }}
      {{- with $item.readOnly }}
  readOnly: {{ . }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{- if .Values.additionalVolumeMounts }}
    {{- toYaml .Values.additionalVolumeMounts | nindent 0 }}
  {{- end }}

  {{- if eq .Values.controller.type "statefulset" }}
    {{- range $index, $vct := .Values.volumeClaimTemplates }}
- mountPath: {{ $vct.mountPath }}
  name: {{ $vct.name }}
      {{- if $vct.subPath }}
  subPath: {{ $vct.subPath }}
      {{- end }}
    {{- end }}
  {{- end }}

{{- end -}}
