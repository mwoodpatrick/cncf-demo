# https://containers.fan/posts/using-k3d-to-run-development-kubernetes-clusters/
# https://github.com/k3s-io/k3s/releases
# https://hub.docker.com/r/rancher/k3s/tags
mkdir k3d
cd k3d
# k3d cluster create --config cncf-dev-cluster2.yml
k3d cluster create cncf-dev-cluster --api-port 6550 -p "8082:80@loadbalancer" --agents 3
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
curl http://hostname.127.0.0.1.nip.io:8082
# in firefox http://hostname.127.0.0.1.nip.io:8082/
