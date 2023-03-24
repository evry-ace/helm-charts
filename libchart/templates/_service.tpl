{{- define "libchart.service.tpl" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "libchart.name" . }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
{{- if .Values.service.annotations }}
  annotations:
  {{ toYaml .Values.service.annotations | nindent 4 }}
{{- end }}
spec:
  type: {{ .Values.service.type }}
{{- if .Values.service.headless }}
  clusterIP: None
{{- end }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort | default "http" }}
      protocol: TCP
      name: {{ .Values.service.name | default "http" }}
    {{ if .Values.service.extraPorts }}
    {{ toYaml .Values.service.extraPorts | nindent 4 }}
    {{- end }}
  selector:
    {{- include "libchart.selectorLabels" . | nindent 4 }}
{{- end }}
