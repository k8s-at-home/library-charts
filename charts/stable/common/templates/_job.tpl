{{- define "common.job" -}}
{{- range $job := .Values.job }}
---
{{ $name := include "common.names.fullname" $ }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $job.name }}
  {{- with (merge ($.Values.controller.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  backoffLimit: {{ $job.backoffLimit }}
  activeDeadlineSeconds: {{ $job.activeDeadlineSeconds }}
  ttlSecondsAfterFinished: {{ $job.ttlSecondsAfterFinished }}
  parallelism: {{ $job.parallelism }}
  completions: {{ $job.completions }}
  manualSelector: {{ $job.manualSelector }}
  selector:
    matchLabels: {{- include "common.labels.selectorLabels" $ | nindent 6 }}
{{/*  concurrencyPolicy: {{ $job.concurrencyPolicy }}*/}}
{{/*  failedJobsHistoryLimit: {{ $job.failedJobsHistoryLimit }}*/}}
{{/*  schedule: {{ $job.schedule | quote }}*/}}
{{/*  successfulJobsHistoryLimit: {{ $job.successfulJobsHistoryLimit }}*/}}
  template:
    spec:
      template:
        metadata:
          labels:
          {{- include "common.labels.selectorLabels" $ | nindent 12 }}
          {{- with $job.podLabels }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
          annotations:
          {{- with $job.podAnnotations }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
        spec:
          serviceAccountName: {{ $job.serviceAccount | default $name }}
          {{- if $job.securityContext }}
          securityContext:
            {{- if index $job "securityContext" "runAsUser" }}
            runAsUser: {{ index $job "securityContext" "runAsUser" }}
            {{- end }}
            {{- if index $job "securityContext" "runAsGroup" }}
            runAsGroup: {{ index $job "securityContext" "runAsGroup" }}
            {{- end }}
            {{- if index $job "securityContext" "fsGroup" }}
            fsGroup: {{ index $job "securityContext" "fsGroup" }}
            {{- end }}
          {{- end }}
          {{- with $job.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 10 }}
          {{- end }}
          restartPolicy: {{ $job.restartPolicy }}
          containers:
          - name: {{ $job.name }}
            image: "{{ index $job "image" "repository" }}:{{ index $job "image" "tag" }}"
            imagePullPolicy: {{ $job.image.imagePullPolicy }}
            {{- with $job.env }}
            env:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $job.envFrom }}
            envFrom:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $job.command }}
            command: {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $job.args }}
            args:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $job.resources }}
            resources:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with $job.volumeMounts }}
            volumeMounts:
              {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- with $job.nodeSelector }}
          nodeSelector:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $job.affinity }}
          affinity:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $job.tolerations }}
          tolerations:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $job.volumes }}
          volumes:
            {{- toYaml . | nindent 10 }}
          {{- end }}
  {{- end }}
{{- end }}