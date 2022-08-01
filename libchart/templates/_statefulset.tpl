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
      {{- if .Values.podAnnotations }}
      annotations:
        {{ toYaml .Values.podAnnotations | nindent 8 }}
      {{- end }}
      labels:
        {{- include "libchart.labels" . | nindent 8 }}
        {{- with .Values.podLabels }}
          {{ toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- include "libchart.pod" . | nindent 6 -}}
{{- end }}
{{- end }}
