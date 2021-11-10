{{/*
Blueprint for the NetworkPolicy object that can be included in the addon.
*/}}
{{- define "common.addon.vpn.networkpolicy" -}}
{{- if .Values.addons.vpn.networkPolicy.enabled }}
---
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: {{ include "common.names.fullname" . }}
  labels:
    {{- with .Values.addons.vpn.networkPolicy.labels }}
       {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- with .Values.addons.vpn.networkPolicy.annotations }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
spec:
  podSelector:
    matchLabels:
      {{- include "common.labels.selectorLabels" . | nindent 6 }}
      {{- with .Values.addons.vpn.networkPolicy.podSelectorLabels }}
        {{ toYaml . | nindent 6 }}
      {{- end }}
  policyTypes:
    - Egress
  egress:
    {{- with .Values.addons.vpn.networkPolicy.egress }}
      {{- . | toYaml | nindent 4 }}
    {{- end -}}
{{- end -}}
{{- end -}}
