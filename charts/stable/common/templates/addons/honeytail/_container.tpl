{{/*
The honeytail sidecar container to be inserted.
*/}}
{{- define "common.addon.honeytail.container" -}}
{{- if lt (len .Values.addons.honeytail.volumeMounts) 1 }}
{{- fail "At least 1 volumeMount is required for honeytail container" }}
{{- end -}}
name: honeytail
image: "{{ .Values.addons.honeytail.image.repository }}:{{ .Values.addons.honeytail.image.tag }}"
imagePullPolicy: {{ .Values.addons.honeytail.image.pullPolicy }}
{{- with .Values.addons.honeytail.securityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
command: 
- "/bin/sh"
- "-c"
args:
- "/entrypoint.sh"
env:
  - name: HONEYCOMB_CONFIG_FILE
    value: "/honeytail-conf/honeytail-config.conf"
  - name: NODE_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: spec.nodeName
  - name: POD_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.name
  - name: POD_NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
{{- with .Values.addons.honeytail.env }}
{{- range $k, $v := . }}
  - name: {{ $k }}
    value: {{ $v | quote }}
{{- end }}
{{- end }}
volumeMounts:
{{- if or .Values.addons.honeytail.configFile .Values.addons.honeytail.configFileSecret }}
  - name: honeytail-conf
    mountPath: /honeytail-conf/honeytail-config.conf
    subPath: honeytailConfigfile
{{- end }}
{{- if .Values.persistence.shared.enabled }}
  - mountPath: {{ .Values.persistence.shared.mountPath }}
    name: shared
{{- end }}
{{- with .Values.addons.honeytail.volumeMounts }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.addons.honeytail.resources }}
resources:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
