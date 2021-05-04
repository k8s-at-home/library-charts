{{/*
Renders the Service objects required by the chart by returning a concatinated list
of the main Service and any additionalservice.
*/}}
{{- define "common.service" -}}
  {{- if .Values.service -}}
    {{- range $name, $service := .Values.service }}
      {{- if or ( $service.enabled ) ( eq $name "main" ) -}}
        {{- print ("---\n") | nindent 0 -}}
        {{- $serviceValues := $service -}}

        {{- /* Dont add name suffix for primary service named "main" */ -}}
        {{- if and (not $serviceValues.nameSuffix) ( ne $name "main" ) -}}
          {{- $_ := set $serviceValues "nameSuffix" $name -}}
        {{ end -}}

        {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
        {{- include "common.classes.service" $ -}}
    {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
