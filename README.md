# helm-charts
Official Helm Charts for the ACE Platform

# Configuring egress for Istio (Allow outbound traffic)
egress:
  https: &sanity_api
  - name: sanity-api
    targets: 
    - host: api.sanity.io
  http: *sanity_api

  http defaults to port 80
  https defaults to port 443