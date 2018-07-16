#!/bin/sh

# If using kops to setup your cluster use kops version > 1.9
# kops version

kubectl version
# Validate version of client & apiserver
# Server Version: version.Info{Major:"1", Minor:"9"}

kubectl -n kube-system get pods -L k8s-app=kube-apiserver -o yaml | grep "admission-control"
# Make sure admission controllers are enabled specially mutating and validating
# webhooks. This is needed for automatci injection of sidecars.
# Output /usr/local/bin/kube-apiserver --address=127.0.0.1
# --admission-control=Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,NodeRestriction,ResourceQuota

# Download Istio release
# curl -L https://git.io/getLatestIstio | sh -
# cd istio-0.8.0
# export PATH=$PWD/bin:$PATH
# Using istioctl

# Install Istio with mTLS enabled or disabled.
# We will install Istio with mTLS turned on
kubectl apply -f install-demo/istio-demo-auth.yaml

# Verify the installation
watch kubectl -n istio-system get pod,svc

# Add istio-injection label to namespaces
kubectl get ns -L istio-injection
kubectl label namespace default istio-injection=enabled

# Deploy your first application!
cat install-demo/sleep.yaml
kubectl -n default apply -f install-demo/sleep.yaml
watch kubectl -n default get pods
# Verify sidecar is automatically injected i.e. 2 containers
kubectl -n default get pods -l app=sleep -o yaml
