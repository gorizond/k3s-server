{{/*
Expand the name of the chart.
*/}}
{{- define "k3s-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Database name api
*/}}
{{- define "k3s-server.sanitizeName" -}}
{{- $namespace := .Release.Namespace -}}
{{- $clusterId := .Values.clusterId -}}
{{- $combined := printf "%s_api_%s" $namespace $clusterId -}}
{{- $sanitized := $combined -}}
{{- $sanitized = $sanitized | replace "@" "_" | replace "." "_" | replace "-" "_" | replace "_" "_" | replace ":" "_" | replace " " "_" -}}
{{- $sanitized -}}
{{- end -}}

{{/*
Database name headscale
*/}}
{{- define "k3s-server.sanitizeNameHeadscale" -}}
{{- $namespace := .Release.Namespace -}}
{{- $clusterId := .Values.clusterId -}}
{{- $combined := printf "%s_hs_%s" $namespace $clusterId -}}
{{- $sanitized := $combined -}}
{{- $sanitized = $sanitized | replace "@" "_" | replace "." "_" | replace "-" "_" | replace "_" "_" | replace ":" "_" | replace " " "_" -}}
{{- $sanitized -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k3s-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k3s-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "k3s-server.labels" -}}
helm.sh/chart: {{ include "k3s-server.chart" . }}
{{ include "k3s-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k3s-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k3s-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "k3s-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k3s-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
