{{/*
The OpenVPN config secret to be included.
*/}}
{{- define "common.addon.vpn.secret" -}}
{{- if and .Values.addons.vpn.configFile (not .Values.addons.vpn.configFileSecret) }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.names.fullname" . }}-vpnConfig
  labels:
  {{- include "common.labels" $ | nindent 4 }}
stringData:
  {{- with .Values.addons.vpn.configFile }}
  vpnConfigfile: |-
    {{- . | nindent 4}}
  {{- end }}
{{- end -}}
{{- end -}}
