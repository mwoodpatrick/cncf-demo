# Deploy The App Defined As Helm Chart To Production With GitOps

TODO: Intro

## Setup

```bash
export REPO_URL=$(git config --get remote.origin.url)

export GITOPS_APP=$(yq ".gitOps.app" settings.yaml)

# Execute the command that follows only if you are using Argo CD
yq --inplace ".spec.source.repoURL = \"$REPO_URL\"" \
    $GITOPS_APP/cncf-demo-helm.yaml

# Execute command that follows only if you jumped directly into
#   this chapter (if you did not go through the steps that built
#   and pushed the image to a registry).
export TAG=v0.0.1

export INGRESS_IP=$(yq ".production.ingress.ip" settings.yaml)

echo $INGRESS_HOST

# Configure DNS for the following subdomains (skip this step if
#   you chose to use `nip.io` instead of a "real" domain):
# - cncf-demo
```

## Do

```bash
cat $GITOPS_APP/cncf-demo-helm.yaml

cp $GITOPS_APP/cncf-demo-helm.yaml apps/cncf-demo.yaml

# Execute the command that follows only if you are using Argo CD
export VALUES=$(\
    yq ".spec.source.helm.values" apps/cncf-demo.yaml \
    | yq ".spec.values.image.tag = \"$TAG\"" \
    | yq ".spec.values.ingress.host = \"cncf-demo.$DOMAIN\"" \
    | yq ".spec.values.ingress.className = \"$INGRESS_CLASS_NAME\""
)

# Execute the command that follows only if you are using Argo CD
yq --inplace ".spec.source.helm.values = \"$VALUES\"" \
    apps/cncf-demo.yaml

# Execute the command that follows only if you are using Flux
yq --inplace ".spec.values.image.tag = \"$TAG\"" \
    apps/cncf-demo.yaml

# Execute the command that follows only if you are using Flux
yq --inplace \
    ".spec.values.ingress.host = \"cncf-demo.$DOMAIN\"" \
    apps/cncf-demo.yaml

# Execute the command that follows only if you are using Flux
yq --inplace \
    ".spec.values.ingress.className = \"$INGRESS_CLASS_NAME\"" \
    apps/cncf-demo.yaml

cat apps/cncf-demo.yaml

git add .

git commit -m "cncf-demo v0.0.1"

git push

kubectl --namespace production get all,ingresses

# If you chose to use `nip.io` instead of a "real" domain,
#   replace `https` with `http`.
echo "https://cncf-demo.$DOMAIN"

# Open it in a browser.
```

## Continue The Adventure

[Setup PostgreSQL DB In The Production Environment](../db-production/story.md)