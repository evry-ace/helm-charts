{{- define "libchart.deployment.tpl" }}
{{- if eq .Values.deployKind "deployment" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ template "libchart.name" . }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "libchart.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "libchart.labels" . | nindent 8 }}
    spec:
      {{- include "libchart.pod" . | nindent 6 -}}
{{- end }}
{{- end }}
