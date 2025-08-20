  ____              ____  _  ____ 
 / ___|  ___  _   _|  _ \(_)/ ___|
 \___ \ / _ \| | | | |_) | | |    
  ___) | (_) | |_| |  __/| | |___ 
 |____/ \___/ \__,_|_|   |_|\____|
                                  
# Kafka User & Topic Helm Chart

## 📘 What is this chart?

This Helm chart is designed to be deployed **alongside your application as a sub-chart**. Its purpose is to automatically manage relevant **Kafka custom resources (CRs)** during application deployment.

## ⚙️ What does it do?

- **Kafka Connect** is deployed in the **same namespace** as your application.
- A **set of KafkaUsers** is created in the **Kafka cluster namespace**.
- KafkaUser-generated secrets are **copied** into your application namespace using the **`copy-kafka-user-secrets`** job.
- A **set of KafkaTopics** is created in the **Kafka cluster namespace**.
- The `_helpers.tpl` file includes logic to override `global.kafkabootstrap` and `global.kafkacschemareg` **only if** a Kafka CR is found in the configured `$kafkaNamespace`.

> If a Kafka cluster **is found**, its bootstrap and schema registry URLs are used. Otherwise, no override will occur.

In your `configmap.yaml`, reference this logic as:

```yaml
{{- if .Values.kafka.overrideEnabled }}
  {{- include "kafka-config.override-kafka-values" . }}
{{- end }}
```

---

## 🛠️ Configurable Values

### `global.kafkaTopics`
| Key             | Description                         |
|------------------|-------------------------------------|
| `name`          | Kafka topic name                    |
| `kafka_cluster` | Kafka cluster name                  |
| `kafka_namespace` | Namespace of the Kafka cluster     |
| `type`          | Topic type (`external`, `shared`, `internal`, `changelog`, `repartition`, `audit`, `deadletter`, `retry`) |

### `global.kafkaUsers`
| Key             | Description                         |
|------------------|-------------------------------------|
| `name`          | Kafka user name                     |
| `kafka_cluster` | Kafka cluster name                  |
| `authentication`| Authentication type (`TLS`, `PLAIN`) <br> *(Support for `SCRAM` doesnt exist heroes are welcomed with PR's)* |
| `user_type`     | Purpose (`microservice`, `console-user`, `customer`, `connect`, `mm2`, `schema-registry`) |

---

## 🌟 Additional Features

- Comes with a `_helpers.tpl` that **dynamically modifies Kafka bootstrap parameters**.

---

## 🚀 How to Use

This chart is intended to be used as a **sub-chart** in your application's Helm chart.

No special installation steps are required. Simply ensure you **populate the `global` section** of your `values.yaml` with the appropriate topic and user definitions.
