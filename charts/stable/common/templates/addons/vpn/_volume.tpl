{{/*
The volume (referencing VPN scripts) to be inserted into additionalVolumes.
*/}}
{{- define "common.addon.vpn.scriptsVolume" -}}
{{- if or .Values.addons.vpn.scripts.up .Values.addons.vpn.scripts.down -}}
name: vpnscript
configMap:
  name: {{ include "common.names.fullname" . }}-vpn
  items:
    {{- if .Values.addons.vpn.scripts.up }}
    - key: up.sh
      path: up.sh
      mode: 0777
    {{- end }}
    {{- if .Values.addons.vpn.scripts.down }}
    - key: down.sh
      path: down.sh
      mode: 0777
    {{- end }}
{{- end -}}
{{- end -}}

{{/*
The volume (referencing VPN config) to be inserted into additionalVolumes.
*/}}
{{- define "common.addon.vpn.configVolume" -}}
{{- if or .Values.addons.vpn.configFile .Values.addons.vpn.configFileSecret -}}
name: vpnconfig
secret:
  {{- if .Values.addons.vpn.configFileSecret }}
  secretName: {{ .Values.addons.vpn.configFileSecret }}
  {{- else }}
  secretName: {{ include "common.names.fullname" . }}-vpnconfig
  {{- end }}
  items:
    - key: vpnConfigfile
      path: vpnConfigfile
{{- end -}}
{{- end -}}
