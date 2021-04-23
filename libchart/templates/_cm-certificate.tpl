{{- define "libchart.cm-certificate.tpl" -}}
{{- $hosts := .Values.cert.hosts -}}

{{- if and .Values.istio.enabled (.Values.istio.ingress.enabled) }}
{{ $hosts = .Values.istio.ingress.hosts }}
{{- else if .Values.ingress.enabled }}
{{ $hosts = .Values.ingress.hosts }}
{{- end }}

{{- if and .Values.cert.enabled ($hosts) }}

apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ template "libchart.name" . }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
  annotations:
{{ toYaml .Values.cert.annotations | indent 4 }}
spec:
{{- if .Values.cert.secretName }}
  secretName: {{ .Values.cert.secretName }}
{{- else }}
  secretName: {{ template "libchart.name" . }}
{{- end }}
{{- if .Values.cert.duration }}
  duration: {{ .Values.cert.duration }}
{{- end }}
  renewBefore: {{ .Values.cert.renewBefore }}
  commonName: {{ index $hosts 0 }}
  dnsNames:
{{ $hosts | toYaml | indent 4 }}
  issuerRef:
    name: {{ .Values.cert.issuer | default "letsencrypt-prod" }}
    kind: {{ .Values.cert.issuerKind | default "ClusterIssuer" }}
{{- end }}
{{- end }}
