{{- define "libchart.hpa.tpl" }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ template "libchart.name" . }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
spec:
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
  {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
  - resource:
      name: cpu
      target:
        averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
        type: Utilization
    type: Resource
  {{- end }}
  {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
  - resource:
      name: memory
      target:
        averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
        type: Utilization
    type: Resource
  {{- end }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "libchart.fullname" . }}
{{- end }}