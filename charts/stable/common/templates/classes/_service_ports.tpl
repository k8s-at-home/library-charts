{{/*
Return the name of the primary port for a given Service object.
*/}}
{{- define "common.classes.service.ports.primary" -}}
  {{- $enabledPorts := dict -}}
  {{- range $name, $port := .values.ports -}}
    {{- if $port.enabled -}}
      {{- $_ := set $enabledPorts $name . -}}
    {{- end -}}
  {{- end -}}

  {{- $result := "" -}}
  {{- range $name, $port := $enabledPorts -}}
    {{- if hasKey $port "primary" -}}
    {{- if $port.primary -}}
      {{- $result = $name -}}
    {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys $enabledPorts | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
