#!/bin/sh

kubectl -n default get pods

# Deploy sample bookinfo application
cat traffic-mgmt/bookinfo.yaml
kubectl -n default apply -f traffic-mgmt/bookinfo.yaml
watch kubectl -n default get pods

cat traffic-mgmt/bookinfo-gateway.yaml
istioctl -n default create -f traffic-mgmt/bookinfo-gateway.yaml

# Browse to productpage application
# INGRESS_HOST=$(kubectl -n istio-system get svc -l istio=ingressgateway -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')
# http://$INGRESS_HOST/productpage
# http://$INGRESS_HOST/api/v1/products

# curl using a different method and it should fail
curl -v -X HEAD http://$INGRESS_HOST/api/v1/products

# curl with GET should work
curl -s -X GET http://$INGRESS_HOST/api/v1/products | jq .

# Route all traffic from productpage to review v3 i.e. red stars
# Note that all host names are FQDN
# If you have MTLS enabled the Destination rule is required to have
# tls mode ISTIO_MUTUAL
cat traffic-mgmt/route-rule-review-v3.yaml
istioctl create -f traffic-mgmt/route-rule-review-v3.yaml
# Browse to productpage application
# http://$INGRESS_HOST/productpage
# and you should only see red stars now

# Configure traffic-shifting
cat traffic-mgmt/route-rule-review-traffic-shifting.yaml
istioctl replace -f traffic-mgmt/route-rule-review-traffic-shifting.yaml
