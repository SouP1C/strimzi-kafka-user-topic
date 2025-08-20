{{- define "mychart.kafkaUser" }}
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaUser
metadata:
  name: {{ .name }}
  namespace: {{ .namespace }}
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "-10"
    "helm.sh/hook-delete-policy": before-hook-creation
  labels:
    strimzi.io/cluster: {{ .kafka_cluster }}
spec:
  authentication:
    type: {{ .authentication }}
  authorization:
    type: simple
    acls:
    {{- if eq .user_type "microservice" }}
      - resource:
          type: topic
          name: {{ .namespace }}
          patternType: literal
        operation: Read
        host: "*"
      - resource:
          type: topic
          name: {{ .namespace }}
          patternType: literal
        operation: Write
        host: "*"
      - resource:
          type: group
          name: {{ .namespace }}
          patternType: literal
        operation: Read
        host: "*"
    {{- else if eq .user_type "console-user" }}
      - resource:
          type: topic
          name: {{ .namespace }}
          patternType: prefix
        operation: Read
      - resource:
          type: topic
          name: {{ .namespace }}
          patternType: prefix
        operation: Write
      - resource:
          type: topic
          name: {{ .namespace }}
          patternType: prefix
        operation: Describe
      - resource:
          type: group
          name: "console-consumer"
          patternType: prefix
        operation: Read
      - resource:
          type: group
          name: "console-consumer"
          patternType: prefix
        operation: Describe
    {{- else if eq .user_type "customer" }}
      - resource:
          type: topic
          name: {{ .namespace }}.SHARED
          patternType: prefix
        operation: Read
      - resource:
          type: topic
          name: {{ .namespace }}.SHARED
          patternType: prefix
        operation: Write
      - resource:
          type: topic
          name: {{ .namespace }}.SHARED
          patternType: prefix
        operation: Describe
      - resource:
          type: group
          name: {{ .namespace }}.SHARED
          patternType: prefix
        operation: Read
      - resource:
          type: group
          name: {{ .namespace }}.SHARED
          patternType: prefix
        operation: Describe
    {{- else if eq .user_type "connect" }}
    # ACL's for topic CRUD
      - resource:
          type: topic
          name: "{{ .Values.global.groupid }}-"
          patternType: prefix
        operation: Read
      - resource:
          type: topic
          name: "{{ .Values.global.groupid }}-"
          patternType: prefix
        operation: Create
      - resource:
          type: topic
          name: "{{ .Values.global.groupid }}-"
          patternType: prefix
        operation: Write
      - resource:
          type: topic
          name: "{{ .Values.global.groupid }}-"
          patternType: prefix
        operation: DescribeConfigs
        
      - resource:
          type: group
          name: {{ .Values.global.groupid }}
          patternType: prefix
        operation: Read
      - resource:
          type: group
          name: {{ .Values.global.groupid }}
          patternType: prefix
        operation: Describe
    {{- else if eq .user_type "mm2" }}
      - resource:
          type: topic
          name: "mirrormaker2-cluster"
          patternType: prefix
        operation: Describe
      - resource:
          type: topic
          name: "mirrormaker2-cluster"
          patternType: prefix
        operation: Read
      - resource:
          type: topic
          name: "mirrormaker2-cluster"
          patternType: prefix
        operation: Write
      - resource:
          type: topic
          name: "mirrormaker2-cluster"
          patternType: prefix
        operation: Create
      - resource:
          type: group
          name: "mirrormaker2-cluster"
          patternType: prefix
        operation: Read
      - resource:
          type: group
          name: "mirrormaker2-cluster"
          patternType: prefix
        operation: Describe
    {{- else if eq .user_type "schema-registry" }}
      - resource:
          type: topic
          name: registry-schemas
          patternType: literal
        operation: Read
      - resource:
          type: topic
          name: registry-schemas
          patternType: literal
        operation: Write
      - resource:
          type: topic
          name: registry-schemas
          patternType: literal
        operation: Create
      - resource:
          type: topic
          name: registry-schemas
          patternType: literal
        operation: Describe
      - resource:
          type: topic
          name: registry-schemas
          patternType: literal
        operation: DescribeConfigs
      - resource:
          type: topic
          name: registry-schemas
          patternType: literal
        operation: AlterConfigs

      # Group-level permissions
      - resource:
          type: group
          name: schema-registry
          patternType: literal
        operation: Read
    {{- end }}
{{- end }}
