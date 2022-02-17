{{- define "libchart.pod" -}}
{{- if .Values.image.pullSecrets }}
imagePullSecrets:
{{ range $s := .Values.image.pullSecrets }}
  - name: {{ $s }}
{{- end }}
{{- end }}
serviceAccountName: {{ include "libchart.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.securityContext | nindent 2 }}
containers:
  - name: {{ .Chart.Name }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
    imagePullPolicy: Always
    {{- if .Values.command }}
    command:
      {{ toYaml .Values.command | nindent 6 }}
    {{- end }}
    {{- if .Values.args }}
    args:
      {{ toYaml .Values.args | nindent 6 }}
    {{- end }}
    {{- if or (.Values.volumeMounts) (.Values.csi) }}
    volumeMounts:
    {{- if .Values.volumeMounts }}
    {{ toYaml .Values.volumeMounts | nindent 6 }}
    {{- end }}
    {{- if .Values.csi }}
      - name: {{ .Values.csi.name }}
        mountPath: {{ .Values.csi.mountPath | quote }}
        readOnly: true
    {{- end }}
    {{- end }}
    ports:
      - name: http
        containerPort: {{ .Values.service.targetPort | default 8080 }}
        protocol: TCP
      {{ if .Values.extraContainerPorts }}
      {{ toYaml .Values.extraContainerPorts | nindent 6 }}
      {{- end }}
    {{- if and (.Values.liveness) (.Values.liveness.enabled) }}
    livenessProbe:
      httpGet:
        path: {{ .Values.liveness.path | default "/" }}
        port: {{ .Values.liveness.port | default 8080 }}
      initialDelaySeconds: {{ .Values.liveness.delay | default 15 }}
      timeoutSeconds: {{ .Values.liveness.timeout | default 15 }}
      periodSeconds: {{ .Values.liveness.periodSeconds | default 15 }}
    {{- end }}
    {{- if and (.Values.readiness) (.Values.readiness.enabled) }}
    readinessProbe:
      httpGet:
        path: {{ .Values.readiness.path | default "/" }}
        port: {{ .Values.readiness.port | default 8080 }}
      initialDelaySeconds: {{ .Values.readiness.delay | default 15 }}
      timeoutSeconds: {{ .Values.readiness.timeout | default 15 }}
      periodSeconds: {{ .Values.readiness.periodSeconds | default 15 }}
    {{- end }}
    env:
      {{- if .Values.secrets }}
      {{ toYaml .Values.secrets | nindent 6 }}
      {{- end }}
      {{- if .Values.environment }}
      {{ toYaml .Values.environment | nindent 6 }}
      {{- end }}
    resources:
      {{ toYaml .Values.resources | nindent 6 }}

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
