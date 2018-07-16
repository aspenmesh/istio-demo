#!/bin/sh

cat security-demo/istio-rbac-enable.yaml

istioctl create -f security-demo/istio-rbac-enable.yaml

# INGRESS_HOST=$(kubectl -n istio-system get svc -l istio=ingressgateway -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'
# Browse to http://$INGRESS_HOST/productpage

cat security-demo/istio-rbac-namespace.yaml
istioctl create -f  security-demo/istio-rbac-namespace.yaml

kubectl -n default get servicerole -o yaml
kubectl -n default get servicerolebinding -o yaml

# Browse to http://$INGRESS_HOST/productpage
# You should be able to see red and black stars
