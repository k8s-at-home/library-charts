{{/*
Renders the Ingress objects required by the chart by returning a concatinated list
of the main Ingress and any additionalIngresses.
*/}}
{{- define "common.ingress" -}}
  {{- if .Values.ingress.enabled -}}
    {{- $svcPort := .Values.service.port.port -}}

    {{- /* Generate primary ingress */ -}}
    {{- $ingressValues := .Values.ingress -}}
    {{- $_ := set . "ObjectValues" (dict "ingress" $ingressValues) -}}
    {{- include "common.classes.ingress" . }}

    {{- if $ingressValues.scaleCert -}}
    {{- $_ := set $ "ObjectValues" (dict "certHolder" $ingressValues) -}}
    {{- print ("---") | nindent 0 -}}
    {{- include "common.scale.cert.secret" $ -}}
    {{ end -}}

    {{- /* Generate additional ingresses as required */ -}}
    {{- range $index, $extraIngress := .Values.ingress.additionalIngresses }}
      {{- if $extraIngress.enabled -}}
        {{- print ("---") | nindent 0 -}}
        {{- $ingressValues := $extraIngress -}}
        {{- if not $ingressValues.nameSuffix -}}
          {{- $_ := set $ingressValues "nameSuffix" $index -}}
        {{ end -}}
        {{- $_ := set $ "ObjectValues" (dict "ingress" $ingressValues) -}}
        {{- include "common.classes.ingress" $ -}}

        {{- if $ingressValues.scaleCert -}}
        {{- $_ := set $ "ObjectValues" (dict "certHolder" $ingressValues) -}}
        {{- print ("---") | nindent 0 -}}
        {{- include "common.scale.cert.secret" $ -}}
        {{ end -}}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
