#!/bin/sh

# Port forward to the Jaeger pod to view Istio dashboard
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686 &

# Browse to http://localhost:16686/ and you should be able to see the Jaeger UI

# Port forward to the Grafana pod to view Istio dashboard
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &

# Start traffic, so we can view metrics
while sleep 1; do curl -s -o /dev/null -w "%{http_code}" "http://$INGRESS_HOST/productpage"; echo; done
# Browse to http://localhost:3000/ for viewing Grafana
