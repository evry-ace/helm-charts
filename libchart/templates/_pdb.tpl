{{- define "libchart.pdb.tpl" -}}
{{- if .Values.podDisruptionBudget -}}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ template "libchart.name" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "libchart.selectorLabels" . | nindent 6 }}
  {{ toYaml .Values.podDisruptionBudget | nindent 2 }}
{{- end -}}
{{- end -}}
