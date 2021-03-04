{{- define "vault-injector.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vault-injector.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "vault-injector.metaLabels" -}}
app.kubernetes.io/name: {{ template "vault-injector.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ include "vault-injector.name" .}}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/part-of: {{ include "vault-injector.name" . }}
app.kubernetes.io/managed-by: helm
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "vault-injector.selectorLabels" -}}
app.kubernetes.io/name: {{ template "vault-injector.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}
