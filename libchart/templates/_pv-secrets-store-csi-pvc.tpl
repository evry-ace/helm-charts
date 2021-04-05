{{- define "libchart.pv-secrets-store-csi-pvc.tpl" -}}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.csi.name }}
  labels:
    {{- include "libchart.labels" . | nindent 4 }}
spec:
  accessModes:
    - ReadOnlyMany
  resources:
    requests:
      storage: {{ .Values.csi.storage | default "10Mi" | quote }}
  volumeName: {{ .Values.csi.name }}
  storageClassName: {{ .Values.csi.storageClassName| quote}}
{{- end -}}
