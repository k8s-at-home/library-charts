{{/*
Template to render VPN addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "common.addon.vpn" -}}
{{- if .Values.addons.vpn.enabled -}}
  {{- if eq "openvpn" .Values.addons.vpn.type -}}
    {{- include "common.addon.openvpn" . }}
  {{- end -}}

  {{- if eq "wireguard" .Values.addons.vpn.type -}}
    {{- include "common.addon.wireguard" . }}
  {{- end -}}

  {{/* Include the configmap if not empty */}}
  {{- $configmap := include "common.addon.vpn.configmap" . -}}
  {{- if $configmap -}}
    {{- print "---" | nindent 0 -}}
    {{- $configmap | nindent 0 -}}
  {{- end -}}

  {{/* Include the secret if not empty */}}
  {{- $secret := include "common.addon.vpn.secret" . -}}
  {{- if $secret -}}
    {{- print "---" | nindent 0 -}}
    {{- $secret | nindent 0 -}}
  {{- end -}}

  {{/* Append the vpn scripts volume to the additionalVolumes */}}
  {{- $scriptVolume := include "common.addon.vpn.scriptsVolume" . | fromYaml -}}
  {{- if $scriptVolume -}}
    {{- $additionalVolumes := append .Values.additionalVolumes $scriptVolume }}
    {{- $_ := set .Values "additionalVolumes" $additionalVolumes -}}
  {{- end -}}

  {{/* Append the vpn config volume to the additionalVolumes */}}
  {{- $configVolume := include "common.addon.vpn.configVolume" . | fromYaml -}}
  {{- if $configVolume -}}
    {{- $additionalVolumes := append .Values.additionalVolumes $configVolume }}
    {{- $_ := set .Values "additionalVolumes" $additionalVolumes -}}
  {{- end -}}

  {{/* Include the networkpolicy if not empty */}}
  {{- $networkpolicy := include "common.addon.vpn.networkpolicy" . -}}
  {{- if $networkpolicy -}}
    {{- print "---" | nindent 0 -}}
    {{- $networkpolicy | nindent 0 -}}
  {{- end -}}
{{- end -}}
{{- end -}}
