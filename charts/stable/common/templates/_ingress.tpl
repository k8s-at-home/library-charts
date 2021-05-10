{{/*
Renders the Ingress objects required by the chart.
*/}}
{{- define "common.ingress" -}}
  {{- /* Generate named ingresses as required */ -}}
  {{- range $name, $ingress := .Values.ingress }}
    {{- if $ingress.enabled -}}
      {{- print ("---\n") | nindent 0 -}}
      {{- $ingressValues := $ingress -}}

      {{/* set defaults */}}
      {{- if and (not $ingressValues.nameSuffix) (ne $name (include "common.ingress.primary" $)) -}}
        {{- $_ := set $ingressValues "nameSuffix" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
      {{- include "common.classes.ingress" $ }}
    {{- end }}
  {{- end }}
{{- end }}

{{/*
Return the name of the primary ingress object
*/}}
{{- define "common.ingress.primary" -}}
{{- $result := "" -}}
{{- range $name, $ingress := .Values.ingress -}}
  {{- if hasKey $ingress "primary" -}}
  {{- if $ingress.primary -}}
    {{- $result = $name -}}
  {{- end -}}
  {{- end -}}
{{- end -}}

{{- if not $result -}}
  {{- $result = keys .Values.ingress | first -}}
{{- end -}}
{{- $result -}}
{{- end -}}
