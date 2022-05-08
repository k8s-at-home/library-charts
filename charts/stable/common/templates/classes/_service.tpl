{{/*
This template serves as a blueprint for all Service objects that are created
within the common library.
*/}}
{{- define "common.classes.service" -}}
{{- $values := .Values.service -}}
{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.service -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}

{{- $serviceName := include "common.names.fullname" . -}}
{{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
  {{- $serviceName = printf "%v-%v" $serviceName $values.nameOverride -}}
{{ end -}}
{{- $svcType := $values.type | default "" -}}
{{- $primaryPort := get $values.ports (include "common.classes.service.ports.primary" (dict "values" $values)) }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $serviceName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  annotations:
  {{- if eq ( $primaryPort.protocol | default "" ) "HTTPS" }}
    traefik.ingress.kubernetes.io/service.serversscheme: https
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
    {{ toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if (or (eq $svcType "ClusterIP") (empty $svcType)) }}
  type: ClusterIP
  {{- if $values.clusterIP }}
  clusterIP: {{ $values.clusterIP }}
  {{end}}
  {{- else if eq $svcType "LoadBalancer" }}
  type: {{ $svcType }}
  {{- if $values.loadBalancerIP }}
  loadBalancerIP: {{ $values.loadBalancerIP }}
  {{- end }}
  {{- if $values.loadBalancerSourceRanges }}
  loadBalancerSourceRanges:
    {{ toYaml $values.loadBalancerSourceRanges | nindent 4 }}
  {{- end -}}
  {{- else }}
  type: {{ $svcType }}
  {{- end }}
  {{- if $values.externalTrafficPolicy }}
  externalTrafficPolicy: {{ $values.externalTrafficPolicy }}
  {{- end }}
  {{- if $values.sessionAffinity }}
  sessionAffinity: {{ $values.sessionAffinity }}
  {{- if $values.sessionAffinityConfig }}
  sessionAffinityConfig:
    {{ toYaml $values.sessionAffinityConfig | nindent 4 }}
  {{- end -}}
  {{- end }}
  {{- with $values.externalIPs }}
  externalIPs:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if $values.publishNotReadyAddresses }}
  publishNotReadyAddresses: {{ $values.publishNotReadyAddresses }}
  {{- end }}
  {{- if $values.ipFamilyPolicy }}
  ipFamilyPolicy: {{ $values.ipFamilyPolicy }}
  {{- end }}
  {{- with $values.ipFamilies }}
  ipFamilies:
    {{ toYaml . | nindent 4 }}
  {{- end }}
  ports:
  {{- range $name, $port := $values.ports }}
  {{- if $port.enabled }}
  - port: {{ $port.port }}
    targetPort: {{ $port.targetPort | default $name }}
    {{- if $port.protocol }}
    {{- if or ( eq $port.protocol "HTTP" ) ( eq $port.protocol "HTTPS" ) ( eq $port.protocol "TCP" ) }}
    protocol: TCP
    {{- else }}
    protocol: {{ $port.protocol }}
    {{- end }}
    {{- else }}
    protocol: TCP
    {{- end }}
    name: {{ $name }}
    {{- if (and (eq $svcType "NodePort") (not (empty $port.nodePort))) }}
    nodePort: {{ $port.nodePort }}
    {{ end }}
  {{- end }}
  {{- end }}
  selector:
    {{- include "common.labels.selectorLabels" . | nindent 4 }}
{{- end }}
