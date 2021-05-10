{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "common.service" -}}
  {{- /* Generate named services as required */ -}}
  {{- range $name, $service := .Values.service }}
    {{- if $service.enabled -}}
      {{- print ("---\n") | nindent 0 -}}
      {{- $serviceValues := $service -}}

      {{/* set defaults */}}
      {{- if and (not $serviceValues.nameSuffix) ( ne $name (include "common.service.primary" $)) -}}
        {{- $_ := set $serviceValues "nameSuffix" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
      {{- include "common.classes.service" $ }}
    {{- end }}
  {{- end }}
{{- end }}


{{/*
Return the name of the primary service object
*/}}
{{- define "common.service.primary" -}}
{{- $result := "" -}}
{{- range $name, $service := .Values.service -}}
  {{- if hasKey $service "primary" -}}
  {{- if $service.primary -}}
    {{- $result = $name -}}
  {{- end -}}
  {{- end -}}
{{- end -}}

{{- if not $result -}}
  {{- $result = keys .Values.service | first -}}
{{- end -}}
{{- $result -}}
{{- end -}}
