{{- define "common.scale.cert.secret" -}}

{{- $secretName := include "common.names.fullname" . -}}

{{- if .ObjectValues.certHolder -}}
  {{- if hasKey .ObjectValues.certHolder "nameSuffix" -}}
    {{- $secretName = ( printf "%v-%v-%v" $secretName .ObjectValues.certHolder.nameSuffix "scalecert" ) -}}
  {{ end -}}
  {{- $secretName = ( printf "%v-%v" $secretName "scalecert" ) -}}
{{ else }}
  {{- $_ := set $ "ObjectValues" (dict "certHolder" .Values) -}}
  {{- $secretName = ( printf "%v-%v" $secretName "scalecert" ) -}}
{{ end -}}

{{- if eq (include "common.scale.cert.available" $ ) "true" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
  labels: {{ include "common.labels" . | nindent 4 }}
type: kubernetes.io/tls
data:
  tls.crt: {{ (include "common.scale.cert.publicKey" $ ) | toString | b64enc | quote }}
  tls.key: {{ (include "common.scale.cert.privateKey" $ ) | toString | b64enc | quote }}
{{- end -}}
{{- end -}}
