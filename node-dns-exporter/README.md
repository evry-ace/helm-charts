# Node-DNS-Exporter

[Node-dns-exporter](https://github.com/evry-ace/node-dns-exporter) is a prometheus exporter for node level DNS metrics. This is intended to run as a DaemonSet in your Kubernetes cluster to report DNS client metrics from each node.

## TL;DR

```console
  helm repo add evry-ace https://evry-ace.github.io/helm-charts/
  helm install my-release evry-ace/node-dns-exporter --set nodeDns.testHosts='vg.no\,bt.no'
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
Add testHosts to the valuefile
$  helm repo add evry-ace https://evry-ace.github.io/helm-charts/
$  helm install my-release evry-ace/node-dns-exporter -f path/to/values.yaml
```

These commands deploy a node-dns-exporter deamonset in the Kubernetes cluster with the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


### nodeDns parameters (see values for examples)

| Name                            | Description                                                         | Value                           |
| -------------------------       | -----------------------------------------------------------         | ----------------------------    |
| `nodeDns.testHosts`             | A string with targets to resolve, splitted by commas                | `""`                            |
| `nodeDns.requiredSearcdomains`  | A string with searchdomains, splitted by commas                     | `""`                            |
| `nodeDns.testInterval`          | Frequency to resolve test host                                      | `120`                           |
