# https://containers.fan/posts/using-k3d-to-run-development-kubernetes-clusters/
# https://github.com/k3s-io/k3s/releases
# https://hub.docker.com/r/rancher/k3s/tags
mkdir k3d
cd k3d
# k3d cluster create --config cncf-dev-cluster2.yml
# k3d cluster create cncf-dev-cluster --api-port 6550 -p "8083:80@loadbalancer" --agents 3
k3d cluster create --config cncf-dev-cluster2.yml --k3s-arg "--disable=traefik@server:0"
watch kubectl get pods -A
kubectl create namespace dev
helm upgrade --install traefik traefik --repo https://helm.traefik.io/traefik --namespace traefik --create-namespace --wait
export INGRESS_HOST=$(kubectl --namespace traefik \
    get service traefik \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "INGRESS_HOST=$INGRESS_HOST"
export DOMAIN=hostname.127.0.0.1.nip.io

# Execute this step ONLY if you chose to use `nip.io` instead of
#   a "real" domain
alias curl="curl --insecure"
kubectl config get-contexts
kubectl cluster-info
kubectl create namespace dev
kubectl get pods -A
kubectl get svc -A
kubectl -n kube-system get service traefik --output jsonpath="{.status.loadBalancer.ingress[0].hostname}"
kubectl -n kube-system get service traefik --output json
k3d cluster list
kubectl apply -f deployment.yml
kubectl get deployments --output wide
kubectl get pods --output wide
kubectl get services --output wide
kubectl get ingress --output wide
kubectl describe ing hostname-ingress
sudo nvim /etc/hosts # add hostname.127.0.0.1.nip.io
curl http://hostname.127.0.0.1.nip.io:8083
# in firefox http://hostname.127.0.0.1.nip.io:8083/
