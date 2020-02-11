package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
  kubernetes.is_deployment
  not input.spec.template.spec.securityContext.runAsNonRoot

  msg = sprintf("Containers must not run as root in Deployment %s", [name])
}

podSelectors {
  input.metadata.labels["app.kubernetes.io/name"] == input.spec.selector.matchLabels["app.kubernetes.io/name"]
  input.metadata.labels["app.kubernetes.io/instance"] == input.spec.selector.matchLabels["app.kubernetes.io/instance"]
  input.metadata.labels["app.kubernetes.io/version"] == input.spec.selector.matchLabels["app.kubernetes.io/version"]
}

deny[msg] {
  kubernetes.is_deployment
  not podSelectors

  msg = sprintf("Deployment %s must provide have correct labels for pod selectors", [name])
}

svcSelectors {
  input.metadata.labels["app.kubernetes.io/name"] == input.spec.selector["app.kubernetes.io/name"]
  input.metadata.labels["app.kubernetes.io/instance"] == input.spec.selector["app.kubernetes.io/instance"]
  input.metadata.labels["app.kubernetes.io/version"] == input.spec.selector["app.kubernetes.io/version"]
}

deny[msg] {
  kubernetes.is_service
  not svcSelectors
  msg = sprintf("Service %s must provide have correct labels for pod selectors", [name])
}

deny[msg] {
  not input.metadata.namespace
  msg = sprintf("Object should be namespaced %s", [name])
}