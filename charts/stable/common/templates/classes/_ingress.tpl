{{/*
This template serves as a blueprint for all Ingress objects that are created
within the common library.
*/}}
{{- define "common.classes.ingress" -}}
{{- $ingressName := include "common.names.fullname" . -}}
{{- $values := .Values.ingress -}}

{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.ingress -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}

{{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
  {{- $ingressName = printf "%v-%v" $ingressName $values.nameOverride -}}
{{ end -}}

{{- $primaryService := get .Values.service (include "common.service.primary" .) }}
{{- $svcName := $values.serviceName | default (include "common.names.fullname" .) -}}
{{- $primaryPort := get $primaryService.ports (include "common.classes.service.ports.primary" (dict "values" $primaryService)) -}}
{{- $svcPort := $values.servicePort | default $primaryPort.port -}}

{{- print ("---\n") | nindent 0 -}}
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
