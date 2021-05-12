{{- /* The main container included in the controller */ -}}
{{- define "common.controller.mainContainer" -}}
- name: {{ include "common.names.fullname" . }}
  image: {{ printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) | quote }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- with .Values.command }}
  command:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.args }}
  args:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.env }}
  env:
    {{- range $k, $v := . }}
      {{- $name := $k }}
      {{- $value := $v }}
      {{- if kindIs "int" $name }}
        {{- $name = required "environment variables as a list of maps require a name field" $value.name }}
      {{- end }}
    - name: {{ quote $name }}
      {{- if kindIs "map" $value -}}
        {{- if hasKey $value "value" }}
          {{- if or (kindIs "string" $value.value) (kindIs "float64" $value.value) (kindIs "int64" $value.value) }}
            {{- $value = $value.value -}}
          {{- else }}
            {{- $value = tpl $value.value $ | quote }}
          {{- end }}
        {{- else if hasKey $value "valueFrom" }}
      valueFrom:
          {{- tpl $value.valueFrom $ | nindent 8 }}
        {{- else }}
          {{- fail "invalid env var format" }}
        {{- end }}
      {{- end }}
      {{- if not (kindIs "map" $value) }}
      value: {{ quote $value }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- if or .Values.envFrom .Values.secret }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- if .Values.secret }}
    - secretRef:
        name: {{ include "common.names.fullname" . }}
    {{- end }}
  {{- end }}
  {{- include "common.controller.ports" . | trim | nindent 2 }}
  {{- with (include "common.controller.volumeMounts" . | trim) }}
  volumeMounts:
    {{ nindent 4 . }}
  {{- end }}
  {{- include "common.controller.probes" . | trim | nindent 2 }}
  {{- with .Values.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
