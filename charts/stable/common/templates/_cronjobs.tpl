{{- define "common.cronjobs" -}}
{{- range $cronjobs := .Values.cronjobs }}
---
{{ $name := include "common.names.fullname" $ }}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $cronjobs.name }}
  {{- with (merge ($.Values.controller.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  concurrencyPolicy: {{ $cronjobs.concurrencyPolicy }}
  failedJobsHistoryLimit: {{ $cronjobs.failedJobsHistoryLimit }}
  successfulJobsHistoryLimit: {{ $cronjobs.successfulJobsHistoryLimit }}
  schedule: {{ $cronjobs.schedule | quote }}
  startingDeadlineSeconds: {{ $cronjobs.startingDeadlineSeconds }}
  suspend: {{ $cronjobs.suspend }}
  selector:
    matchLabels: {{- include "common.labels.selectorLabels" $ | nindent 6 }}
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            {{- include "common.labels.selectorLabels" $ | nindent 12 }}
            {{- with $cronjobs.podLabels }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
          annotations:
          {{- with $cronjobs.podAnnotations }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
        spec:
          serviceAccountName: {{ $cronjobs.serviceAccount | default $name }}
          {{- if $cronjobs.securityContext }}
          securityContext:
            {{- if index $cronjobs "securityContext" "runAsUser" }}
            runAsUser: {{ index $cronjobs "securityContext" "runAsUser" }}
            {{- end }}
            {{- if index $cronjobs "securityContext" "runAsGroup" }}
            runAsGroup: {{ index $cronjobs "securityContext" "runAsGroup" }}
            {{- end }}
            {{- if index $cronjobs "securityContext" "fsGroup" }}
            fsGroup: {{ index $cronjobs "securityContext" "fsGroup" }}
            {{- end }}
          {{- end }}
          {{- with $cronjobs.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 10 }}
          {{- end }}
          restartPolicy: {{ $cronjobs.restartPolicy }}
          containers:
          - name: {{ $cronjobs.name }}
            image: "{{ index $cronjobs "image" "repository" }}:{{ index $cronjobs "image" "tag" }}"
            imagePullPolicy: {{ $cronjobs.image.imagePullPolicy }}
            {{- with $cronjobs.env }}
            env:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjobs.envFrom }}
            envFrom:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjobs.command }}
            command: {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjobs.args }}
            args:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjobs.resources }}
            resources:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with $cronjobs.volumeMounts }}
            volumeMounts:
              {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- with $cronjobs.nodeSelector }}
          nodeSelector:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $cronjobs.affinity }}
          affinity:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $cronjobs.tolerations }}
          tolerations:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $cronjobs.volumes }}
          volumes:
            {{- toYaml . | nindent 10 }}
          {{- end }}
  {{- end }}
{{- end }}