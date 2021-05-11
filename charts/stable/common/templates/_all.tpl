{{/*
Main entrypoint for the common library chart. It will render all underlying templates based on the provided values.
*/}}
{{- define "common.all" -}}
  {{- /* Merge the local chart values and the common chart defaults */ -}}
  {{- include "common.values.setup" . }}

  {{- /* Enable code-server add-on if required */ -}}
  {{- if .Values.addons.codeserver.enabled }}
    {{- include "common.addon.codeserver" . }}
  {{- end -}}

  {{- /* Enable VPN add-on if required */ -}}
  {{- if .Values.addons.vpn.enabled }}
    {{- include "common.addon.vpn" . }}
  {{- end -}}

  {{- /* Enable promtail add-on if required */ -}}
  {{- if .Values.addons.promtail.enabled }}
    {{- include "common.addon.promtail" . }}
  {{- end -}}

  {{- /* Build the templates */ -}}
  {{- include "common.pvc" . }}

  {{- if .Values.serviceAccount.create -}}
    {{- include "common.serviceAccount" . }}
  {{- end -}}

  {{- if eq .Values.controllerType "deployment" }}
    {{- include "common.deployment" . | nindent 0 }}
  {{ else if eq .Values.controllerType "daemonset" }}
    {{- include "common.daemonset" . | nindent 0 }}
  {{ else if eq .Values.controllerType "statefulset"  }}
    {{- include "common.statefulset" . | nindent 0 }}
  {{ else }}
    {{- fail (printf "Not a valid controllerType (%s)" .Values.controllerType) }}
  {{- end -}}

  {{ include "common.classes.hpa" . | nindent 0 }}

  {{ include "common.service" . | nindent 0 }}

  {{ include "common.ingress" .  | nindent 0 }}

  {{- if .Values.secret -}}
    {{ include "common.secret" .  | nindent 0 }}
  {{- end -}}

  {{ include "common.class.mountPermissions" .  | nindent 0 }}

  {{ include "common.classes.portal" .  | nindent 0 }}
{{- end -}}
