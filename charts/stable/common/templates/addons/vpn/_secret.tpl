{{/*
The OpenVPN config secret to be included.
*/}}
{{- define "common.addon.vpn.secret" -}}
{{- if and .Values.addons.vpn.configFile (not .Values.addons.vpn.configFileSecret) }}
{{- print ("---\n") | nindent 0 -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.names.fullname" . }}-vpnconfig
  labels:
  {{- include "common.labels" $ | nindent 4 }}
stringData:
  {{- with .Values.addons.vpn.configFile }}
  vpnConfigfile: |-
    {{- . | nindent 4}}
  {{- end }}
{{- end -}}
{{- end -}}
