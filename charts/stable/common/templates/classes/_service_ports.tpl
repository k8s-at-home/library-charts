{{/*
Render all the ports and additionalPorts for a Service object.
*/}}
{{- define "common.classes.service.ports" -}}
  {{- $ports := list -}}
  {{- $values := .values -}}
  {{- $ports = mustAppend $ports $values.port -}}
  {{- range $_ := $values.additionalPorts -}}
    {{- $ports = mustAppend $ports . -}}
  {{- end }}
  {{- if $ports -}}
  ports:
  {{- range $_ := $ports }}
  - port: {{ .port }}
    targetPort: {{ .targetPort | default .name | default "http" }}
    {{- if .protocol }}
    {{- if or ( eq .protocol "HTTP" ) ( eq .protocol "HTTPS" ) ( eq .protocol "TCP" ) }}
    protocol: TCP
    {{- else }}
    protocol: {{ .protocol }}
    {{- end }}
    {{- else }}
    protocol: TCP
    {{- end }}
    name: {{ .name | default "http" }}
    {{- if (and (eq $.svcType "NodePort") (not (empty .nodePort))) }}
    nodePort: {{ .nodePort }}
    {{ end }}
  {{- end -}}
  {{- end -}}
{{- end }}
