{{- define "control-center.name" -}}
nextlabs-control-center
{{- end }}

{{- define "control-center.fullname" -}}
{{- printf "%s-nextlabs-control-center" .Release.Name }}
{{- end }}

{{- define "control-center.chart" -}}
{{- printf "nextlabs-control-center-%s" .Chart.Version }}
{{- end }}

{{- define "control-center.labels" -}}
helm.sh/chart: {{ include "control-center.chart" . }}
{{ include "control-center.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "control-center.selectorLabels" -}}
app.kubernetes.io/name: {{ include "control-center.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{- define "management-server.name" -}}
nextlabs-control-center-management-server
{{- end }}

{{- define "management-server.fullname" -}}
{{- printf "%s-nextlabs-control-center-management-server" .Release.Name }}
{{- end }}

{{- define "management-server.labels" -}}
helm.sh/chart: {{ include "control-center.chart" . }}
{{ include "management-server.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "management-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "management-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{- define "icenet.name" -}}
nextlabs-control-center-icenet
{{- end }}

{{- define "icenet.fullname" -}}
{{- printf "%s-nextlabs-control-center-icenet" .Release.Name }}
{{- end }}

{{- define "icenet.labels" -}}
helm.sh/chart: {{ include "control-center.chart" . }}
{{ include "icenet.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "icenet.selectorLabels" -}}
app.kubernetes.io/name: {{ include "icenet.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{- define "policy-validator.name" -}}
nextlabs-policy-validator
{{- end }}

{{- define "policy-validator.fullname" -}}
{{- printf "%s-nextlabs-policy-validator" .Release.Name }}
{{- end }}

{{- define "policy-validator.labels" -}}
helm.sh/chart: {{ include "control-center.chart" . }}
{{ include "policy-validator.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "policy-validator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "policy-validator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{- define "policy-controller-java.name" -}}
nextlabs-policy-controller-java
{{- end }}

{{- define "policy-controller-java.fullname" -}}
{{- printf "%s-nextlabs-policy-controller-java" .Release.Name }}
{{- end }}

{{- define "policy-controller-java.labels" -}}
helm.sh/chart: {{ include "control-center.chart" . }}
{{ include "policy-controller-java.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "policy-controller-java.selectorLabels" -}}
app.kubernetes.io/name: {{ include "policy-controller-java.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{- define "cc.ingress.tls" -}}
{{- $ca := genCA "nextlabs-cc-ingress-ca" 3650 -}}
{{- $cn := .Values.nextlabs.cc.dnsName -}}
{{- $cert := genSignedCert $cn nil nil 1825 $ca -}}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
{{- end -}}

{{- define "cc.tls" -}}
{{- $ca := genCA "nextlabs-cc-ca" 3650 -}}
{{- $ccCert := genSignedCert (printf "%s-nextlabs-control-center-management-server" .Release.Name) nil nil 1825 $ca -}}
{{- $webCert := genSignedCert (printf "%s-nextlabs-control-center-management-server" .Release.Name) nil nil 1825 $ca -}}
{{- $jpcCert := genSignedCert (printf "%s-nextlabs-policy-controller-java" .Release.Name) nil nil 1825 $ca -}}
{{- $pvCert := genSignedCert (printf "%s-nextlabs-policy-validator" .Release.Name) nil nil 1825 $ca -}}
nextlabs.cc.ssl.ccKeyPairStore.certificate: {{ $ccCert.Cert | b64enc }}
nextlabs.cc.ssl.ccKeyPairStore.key: {{ $ccCert.Key | b64enc }}
nextlabs.cc.ssl.webKeyPairStore.certificate: {{ $webCert.Cert | b64enc }}
nextlabs.cc.ssl.webKeyPairStore.key: {{ $webCert.Key | b64enc }}
nextlabs.jpc.tls.certificate: {{ $jpcCert.Cert | b64enc }}
nextlabs.jpc.tls.key: {{ $jpcCert.Key | b64enc }}
nextlabs.pv.tls.certificate: {{ $pvCert.Cert | b64enc }}
nextlabs.pv.tls.key: {{ $pvCert.Key | b64enc }}
{{- end -}}

