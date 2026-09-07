#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "renders k8s-zot Application, homelab-zot fully retired" {
  repo_url=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-zot") | .spec.source.repoURL
  ' -)
  namespace=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-zot") | .spec.destination.namespace
  ' -)
  old_name=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-zot") | .metadata.name
  ' -)

  [ "$repo_url" = "https://github.com/mattjmorrison-homelab/k8s-zot" ]
  [ "$namespace" = "zot" ]
  [ -z "$old_name" ]
}
