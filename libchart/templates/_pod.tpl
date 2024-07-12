{{- define "libchart.pod" -}}
{{- if .Values.image.pullSecrets }}
imagePullSecrets:
{{ range $s := .Values.image.pullSecrets }}
  - name: {{ $s }}
{{- end }}
{{- end }}
serviceAccountName: {{ include "libchart.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}

{{- if .Values.initContainers }}
initContainers:
  {{ toYaml .Values.initContainers | nindent 2 }}
{{- end }}

containers:
  - name: {{ .Chart.Name }}
  {{- include "libchart.container" .Values | indent 2 -}}
  {{- range $sc := .Values.sidecars -}}
    {{ "- name: " | nindent 2 }}{{ $sc.name }}
    {{- include "libchart.container" $sc  | indent 2 }}
  {{- end }}
  {{- if .Values.initContainers }}
  {{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{ toYaml . | nindent 4 }}
{{- end }}

{{- if or .Values.affinity .Values.podAntiAffinity }}
affinity:
{{- with .Values.affinity }}
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- if eq .Values.podAntiAffinity "hard" }}
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - topologyKey: "{{ .Values.podAntiAffinityTopologyKey }}"
        labelSelector:
          matchLabels:
            {{- include "libchart.selectorLabels" . | nindent 12 }}
{{- else if eq .Values.podAntiAffinity "soft" }}
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        podAffinityTerm:
          topologyKey: "{{ .Values.podAntiAffinityTopologyKey }}"
          labelSelector:
            matchLabels:
              {{- include "libchart.selectorLabels" . | nindent 14 }}
{{- end }}
{{- end }}

{{- with .Values.dnsConfig }}
dnsConfig:
  {{ toYaml . | nindent 2 }}
{{- end -}}

{{- with .Values.tolerations }}
tolerations:
  {{ toYaml . | nindent 2 }}
{{- end }}

{{- if or (.Values.volumes) (.Values.csi) }}
volumes:
  {{- if .Values.volumes }}
  {{ toYaml .Values.volumes | nindent 2 }}
  {{- end }}
  {{- if .Values.csi }}
  - name: {{ .Values.csi.name }}
    persistentVolumeClaim:
      claimName: {{ .Values.csi.name }}
  {{- end }}
{{- end }}

{{- end }}
