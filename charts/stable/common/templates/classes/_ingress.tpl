{{/*
This template serves as a blueprint for all Ingress objects that are created
within the common library.
*/}}
{{- define "common.classes.ingress" -}}
{{- $ingressName := include "common.names.fullname" . -}}
{{- $values := .Values.ingress -}}
{{- $svcName := include "common.names.fullname" . -}}
{{- $svcPort := 80 -}}
{{- $ingressService := $.Values.service -}}

{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.ingress -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}


{{/*
Set ingressName
Set svcPort and svcName defaults based on ingress and service names
- It tries to find a service with the same name as the ingress
- If a service with the same name as the ingress exists (and is enabled), it tries to use it's port and name
- If such a service does not exist, or is disabled, it tries to use the main service
- If no service with the same name AND no main service are found, it uses:
   default port 80
   default fullname as name
*/}}
{{- if hasKey $values "nameSuffix" -}}
  {{- $ingressName = printf "%v-%v" $ingressName $values.nameSuffix -}}
  {{- if not $values.servicePort }}
    {{- $ingressService := index  $.Values.service ( $values.nameSuffix | quote ) }}
    {{- if $ingressService.enabled }}
      {{- $svcName := $values.serviceName | default (printf "%v-%v" $svcName $values.nameSuffix | quote ) -}}
      {{- $svcPort = $values.servicePort | default $ingressService.port.port -}}
    {{- else if $.Values.service.main.enabled }}
      {{- $svcPort = $values.servicePort | $.Values.service.main.port.port -}}
    {{ end -}}
  {{ end -}}
{{- else if and ( $.Values.service.main.enabled ) ( not $values.servicePort ) }}
  {{- $svcPort = $values.servicePort | $.Values.service.main.port.port -}}
{{ end -}}


apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ $ingressName }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- with $values.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
  {{- if $values.ingressClassName }}
  ingressClassName: {{ $values.ingressClassName }}
  {{- end }}
  {{- end }}
  {{- if $values.tls }}
  tls:
    {{- range $values.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
        {{- range .hostsTpl }}
        - {{ tpl . $ | quote }}
        {{- end }}
      {{- if or .secretNameTpl .secretName }}
      {{- if .secretNameTpl }}
      secretName: {{ tpl .secretNameTpl $ | quote}}
      {{- else }}
      secretName: {{ .secretName }}
      {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $values.hosts }}
  {{- if .hostTpl }}
    - host: {{ tpl .hostTpl $ | quote }}
  {{- else }}
    - host: {{ .host | quote }}
  {{- end }}
      http:
        paths:
          {{- range .paths }}
          {{- if .pathTpl }}
          - path: {{ tpl .pathTpl $ | quote }}
          {{- else }}
          - path: {{ .path | quote }}
          {{- end }}
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
            pathType: {{ default "Prefix" .pathType }}
            {{- end }}
            backend:
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
              service:
                name: {{ .serviceName | default $svcName }}
                port:
                  number: {{ .servicePort | default $svcPort }}
            {{- else }}
              serviceName: {{ .serviceName | default $svcName }}
              servicePort: {{ .servicePort | default $svcPort }}
            {{- end }}
          {{- end }}
  {{- end }}
{{- end }}
