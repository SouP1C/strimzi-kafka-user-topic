{{- define "mychart.kafkaTopic" }}
{{- $ctx := .ctx }}
{{- $type := $ctx.type | default "internal" }}
{{- $namespace := $ctx.kafka_namespace }}
{{- $client_namespace := $ctx.client_namespace }}
{{- $tenantId := $ctx.tenantid | default "default" }}
{{- $name := "" }}
{{- if or (eq $type "changelog") (eq $type "repartition") }}
  {{- $name = printf "%s.%s.%s.%s" $client_namespace $tenantId $ctx.name $type }}
{{- else if eq $type "shared" }}
  {{- $name = printf "%s.SHARED.%s" $client_namespace $ctx.name }}
{{- else if eq $type "external" }}
  {{- $name = printf "%s.%s.%s" $client_namespace $tenantId $ctx.name }}
{{- else if eq $type "internal" }}
  {{- $name = printf "%s" $ctx.name }}
{{- else }}
  {{- $name = printf ".%s.%s" $client_namespace $ctx.name }}
{{- end }}
{{- $partitions := 3 }}
{{- $replicas := 3 }}
{{- $retention := 7200000 }}
{{- $cleanup := "compact" }}
{{- $segment := 1073741824 }}
{{- if eq $type "shared" }}
  {{- $cleanup = "delete" }}
  {{- $retention = 259200000 }}
  {{- $segment = 43200000 }}
{{- else if eq $type "internal" }}
  {{- $cleanup = "compact" }}
  {{- $retention = -1 }}
  {{- $segment = 604800000  }}
{{- else if eq $type "external" }}
  {{- $cleanup = "delete" }}
  {{- $retention = 604800000 }}
  {{- $segment = 86400000 }}
{{- else if eq $type "repartition" }}
  {{- $cleanup = "delete" }}
  {{- $retention = 86400000 }}
  {{- $segment = 3600000 }}
{{- else if eq $type "changelog" }}
  {{- $cleanup = "compact" }}
  {{- $retention = -1 }}
  {{- $segment = 604800000 }}
{{- else if eq $type "deadletter" }}
  {{- $cleanup = "delete" }}
  {{- $retention = 1209600000 }}
  {{- $segment = 86400000 }}
{{- else if eq $type "audit" }}
  {{- $cleanup = "delete" }}
  {{- $retention = 2592000000 }}
  {{- $segment = 86400000 }}
{{- else if eq $type "retry" }}
  {{- $cleanup = "delete" }}
  {{- $retention = 60000 }}
  {{- $segment = 60000 }}
{{- end }}
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaTopic
metadata:
  name: {{ $name }}
  namespace: {{ $namespace }}
  labels:
    strimzi.io/cluster: {{ $ctx.kafka_cluster }}
spec:
  partitions: {{ $partitions }}
  replicas: {{ $replicas }}
  topicName: {{ $name }}
  config:
    retention.ms: {{ $retention }}
    cleanup.policy: {{ $cleanup | quote }}
    segment.bytes: {{ $segment }}
---
{{- end }}

