{{- define "kafka-topic-user.override-kafka-values" }}
{{- $kafkaNamespace := "kafka" }}
{{- $kafkaClusterName := "my-kafka-cluster" }}
{{- $schemaClusterName := "my-schema-registry" }}
{{- $kafka := lookup "kafka.strimzi.io/v1beta2" "Kafka" $kafkaNamespace $kafkaClusterName }}

{{- if $kafka }}
  {{- $kafkaService := printf "%s-kafka-bootstrap.%s.svc.cluster.local:9092" $kafkaClusterName $kafkaNamespace }}
  {{- $_ := set .Values.global "kafkabootstrap" $kafkaService }}

  {{- $schemaRegistryService := lookup "roundtable.lsst.codes/v1beta1" "StrimziSchemaRegistry" $kafkaNamespace $schemaClusterName }}
  {{- if $schemaRegistryService }}
    {{- $schemaRegHost := printf "%s.%s.svc.cluster.local:8081" $schemaClusterName $kafkaNamespace }}
    {{- $_ := set .Values.global "kafkaschemareg" $schemaRegHost }}
  {{- end }}
{{- end }}
{{- end }}

# * progress with creating kafkaUser for <some_product>, and working towards copying it to <some_product>'s namespace.
#   + we can stay with listener 9092, that has no TLS requirements, 
#     in future a transition to TLS is possible on 9093 listener.


# if kafka cluster is found, use their bootstrap,
# else,
# dont override the bootstrap values.

# reference this in the configmap.yaml
# "
# {{- if .Values.kafka.overrideEnabled }}
#   {{- include "kafka-config.override-kafka-values" . }}
# {{- end }}
# "