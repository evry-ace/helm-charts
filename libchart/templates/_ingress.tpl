{{- define "libchart.ingress.tpl" }}
{{- $name := include "libchart.name" . -}}
{{- $ingressPath := .Values.ingress.path -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $name }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{ toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.tls }}
  tls:
  {{- range .Values.ingress.tls }}
    - hosts:
      {{- range .hosts }}
        - {{ . }}
      {{- end }}
      secretName: {{ .secretName }}
  {{- end }}
  {{- end }}
  rules:
  {{- range .Values.ingress.hosts }}
    - host: {{ . }}
      http:
        paths:
          - path: {{ $ingressPath }}
            backend:
              service:
                name: {{ $name }}
                port:
                  name: http
            pathType: ImplementationSpecific
  {{- end }}
{{- end }}
