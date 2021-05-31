{{/* Probe selection logic */}}
{{- define "common.controller.probes" -}}
  {{- $primaryService := get .Values.service (include "common.service.primary" .) -}}
  {{- $primaryPort := "" -}}
  {{- if $primaryService -}}
    {{- $primaryPort = get $primaryService.ports (include "common.classes.service.ports.primary" (dict "serviceName" (include "common.service.primary" .) "values" $primaryService)) -}}
  {{- end -}}

  {{- range $kind, $probe := .Values.probes }}
    {{- if $probe.enabled }}
      {{- printf "%sProbe:" $kind | nindent 0 }}
      {{- if $probe.custom }}
        {{- toYaml $probe.spec | nindent 2 }}
      {{- else }}
        {{- nindent 2 "tcpSocket:" }}
        {{- printf "port: %v" $primaryPort.port  | nindent 4 }}
        {{- printf "initialDelaySeconds: %v" $probe.spec.initialDelaySeconds  | nindent 2 }}
        {{- printf "failureThreshold: %v" $probe.spec.failureThreshold  | nindent 2 }}
        {{- printf "timeoutSeconds: %v" $probe.spec.timeoutSeconds  | nindent 2 }}
        {{- printf "periodSeconds: %v" $probe.spec.periodSeconds | nindent 2 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
