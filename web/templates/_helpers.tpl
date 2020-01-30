{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "web.name" -}}
{{- default .Release.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "web.metaLabels" -}}
app.kubernetes.io/name: {{ template "web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ default (include "web.name" .) .Values.appComponent }}
app.kubernetes.io/version: {{ .Values.appVersion }}
app.kubernetes.io/part-of: {{ default (include "web.name" .) .Values.appPartOf}}
app.kubernetes.io/managed-by: helm
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "web.selectorLabels" -}}
app.kubernetes.io/name: {{ template "web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.appVersion }}
{{- end -}}