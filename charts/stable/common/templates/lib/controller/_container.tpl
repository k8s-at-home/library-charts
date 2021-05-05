{{- /*
The main container included in the controller.
*/ -}}
{{- define "common.controller.mainContainer" -}}
- name: {{ include "common.names.fullname" . }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- with .Values.command }}
  {{- if kindIs "string" . }}
  command: {{ . }}
  {{- else }}
  command:
  {{ toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- with .Values.args }}
  {{- if kindIs "string" . }}
  args: {{ . }}
  {{- else }}
  args:
  {{ toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
  {{- with .Values.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- if or .Values.envList .Values.env .Values.envTpl .Values.envValueFrom }}
  env:
  {{- range $envList := .Values.envList }}
  {{- if and $envList.name $envList.value }}
  - name: {{ $envList.name }}
    value: {{ $envList.value | quote }}
  {{- else }}
    {{- fail "Please specify name/value for environment variable" }}
  {{- end }}
  {{- end}}
  {{- range $key, $value := .Values.env }}
  - name: {{ $key }}
    value: {{ $value | quote }}
  {{- end }}
  {{- range $key, $value := .Values.envTpl }}
  - name: {{ $key }}
    value: {{ tpl $value $ | quote }}
  {{- end }}
  {{- range $key, $value := .Values.envValueFrom }}
  - name: {{ $key }}
    valueFrom:
      {{- $value | toYaml | nindent 6 }}
  {{- end }}
  {{- end }}
  {{- if or .Values.envFrom .Values.secret }}
  envFrom:
  {{- with .Values.envFrom }}
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- if or .Values.secret }}
  - secretRef:
      name: {{ include "common.names.fullname" . }}
  {{- end }}
  {{- end }}
  {{- include "common.controller.ports" . | trim | nindent 2 }}
  {{- with (include "common.controller.volumeMounts" . | trim) }}
  volumeMounts:
    {{- . | nindent 2 }}
  {{- end }}
  {{- include "common.controller.probes" . | nindent 2 }}
  {{- with .Values.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
