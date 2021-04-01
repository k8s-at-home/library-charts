{{/*
Renders the PersistentVolumeClaim objects required by the chart by returning a concatinated list
of all the entries of the persistence key.
*/}}
{{- define "common.pvc" -}}
  {{- /* Generate pvc as required */ -}}
  {{- range $index, $PVC := .Values.persistence }}
    {{- $emptyDir := false -}}
    {{- if $PVC.emptyDir -}}
      {{- if $PVC.emptyDir.enabled -}}
        {{- $emptyDir = true -}}
      {{- end -}}
    {{- end -}}

    {{- if and $PVC.enabled (not (or $emptyDir $PVC.existingClaim)) -}}
      {{- $persistenceValues := $PVC -}}
      {{- if not $persistenceValues.nameSuffix -}}
        {{- $_ := set $persistenceValues "nameSuffix" $index -}}
      {{- end -}}
      {{- $_ := set $ "ObjectValues" (dict "persistence" $persistenceValues) -}}
      {{- print ("---") | nindent 0 -}}
      {{- include "common.classes.pvc" $ | nindent 0 -}}
    {{- end }}
  {{- end }}
{{- end }}
