{{- define "libchart.container" }}
  image: "{{ .image.repository }}:{{ .image.tag }}"
  imagePullPolicy: Always
  {{- if .command }}
  command:
    {{ toYaml .command | nindent 6 }}
  {{- end }}
  {{- if .args }}
  args:
    {{ toYaml .args | nindent 6 }}
  {{- end }}
  {{- if or (.volumeMounts) (.csi) }}
  volumeMounts:
  {{- if .volumeMounts }}
  {{- toYaml .volumeMounts | nindent 6 }}
  {{- end }}
  {{- if .csi }}
    - name: {{ .csi.name }}
      mountPath: {{ .csi.mountPath | quote }}
      readOnly: true
  {{- end }}
  {{- end }}
  ports:
    {{- if .deployKind }} {{/* a hack to check if we are in the root context or in a sidecar; sidecars are not using the port mapping from the service */}}
      {{- "- name: http" | nindent 4 }}
      {{- "containerPort: " | nindent 6 }}{{ .service.targetPort | default 8080 }}
      protocol: TCP
    {{- end }}
    {{- if .extraContainerPorts }}
    {{ toYaml .extraContainerPorts | nindent 6 }}
    {{- end }}
  {{- $liveness := default dict .liveness }}
  {{- $livenessEnabled := default false $liveness.enabled }}
  {{- if and $liveness $livenessEnabled }}
  livenessProbe:
    httpGet:
      path: {{ .liveness.path | default "/" }}
      port: {{ .liveness.port | default 8080 }}
    initialDelaySeconds: {{ .liveness.delay | default 15 }}
    timeoutSeconds: {{ .liveness.timeout | default 15 }}
    periodSeconds: {{ .liveness.periodSeconds | default 15 }}
  {{- end }}
  {{- $readiness := default dict .readiness }}
  {{- $readinessEnabled := default false $readiness.enabled }}
  {{- if and $readiness $readinessEnabled }}
  readinessProbe:
    httpGet:
      path: {{ .readiness.path | default "/" }}
      port: {{ .readiness.port | default 8080 }}
    initialDelaySeconds: {{ .readiness.delay | default 15 }}
    timeoutSeconds: {{ .readiness.timeout | default 15 }}
    periodSeconds: {{ .readiness.periodSeconds | default 15 }}
  {{- end }}
  env:
    {{- if .secrets }}
    {{ toYaml .secrets | nindent 6 }}
    {{- end }}
    {{- if .environment }}
    {{ toYaml .environment | nindent 6 }}
    {{- end }}
  resources:
    {{- toYaml .resources | nindent 6 }}
  securityContext:
    {{- toYaml .securityContext | nindent 6 }}
{{- end }}
