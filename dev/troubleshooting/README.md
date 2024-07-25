# Pod Log Collector

This script collects logs from all running pods in a Kubernetes cluster using `kubectl` commands.

## Prerequisites
access your Kubernetes cluster - sufficient permissions to access pod logs

## Usage
```
# collect all pods logs from namespace named "digma"
curl -o collect.sh https://raw.githubusercontent.com/digma-ai/digma/main/dev/troubleshooting/collect.sh && chmod +x collect.sh && ./collect.sh digma
```