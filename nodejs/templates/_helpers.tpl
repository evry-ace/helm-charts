{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nodejs.name" -}}
{{- default .Release.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nodejs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "nodejs.metaLabels" -}}
app.kubernetes.io/name: {{ template "nodejs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ default .Values.appComponent (include "nodejs.name" .) }}
app.kubernetes.io/version: {{ .Values.appVersion }}
app.kubernetes.io/part-of: {{ default .Values.appPartOf (include "nodejs.name" .) }}
app.kubernetes.io/managed-by: helm
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "nodejs.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nodejs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.appVersion }}
{{- end -}}