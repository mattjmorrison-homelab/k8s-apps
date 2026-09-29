#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "homelab-cert-manager-crds Application excludes catalog-info.yaml from directory source" {
  exclude=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-cert-manager-crds") | .spec.source.directory.exclude
  ' -)

  [ "$exclude" = "catalog-info.yaml" ]
}

@test "homelab-external-secrets-crds Application excludes catalog-info.yaml from directory source" {
  exclude=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-external-secrets-crds") | .spec.source.directory.exclude
  ' -)

  [ "$exclude" = "catalog-info.yaml" ]
}
