#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "renders k8s-ad-reporter Application pointing at its own repo/namespace" {
  repo_url=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-ad-reporter") | .spec.source.repoURL
  ' -)
  path=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-ad-reporter") | .spec.source.path
  ' -)
  namespace=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-ad-reporter") | .spec.destination.namespace
  ' -)
  automated=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-ad-reporter") | .spec.syncPolicy.automated.selfHeal
  ' -)

  [ "$repo_url" = "https://github.com/mattjmorrison-homelab/k8s-ad-reporter" ]
  [ "$path" = "manifests" ]
  [ "$namespace" = "ad-reporter" ]
  [ "$automated" = "true" ]
}
