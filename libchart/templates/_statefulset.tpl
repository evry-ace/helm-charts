{{- define "libchart.statefulset.tpl" }}
{{- if eq .Values.deployKind "statefulset" }}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ template "libchart.name" . }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  serviceName: {{ template "libchart.name" . }}
  selector:
    matchLabels:
      {{- include "libchart.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "libchart.labels" . | nindent 8 }}
        {{- if .Values.podLabels }}
        {{ toYaml .Values.podLabels | nindent 8 }}
        {{- end -}}
      {{- if .Values.podAnnotations }}
      annotations:
        {{ toYaml .Values.podAnnotations | nindent 8 }}
      {{- end }}
    spec:
      spec:
      {{- include "libchart.pod" . | nindent 6 -}}
{{- end }}
{{- end }}
