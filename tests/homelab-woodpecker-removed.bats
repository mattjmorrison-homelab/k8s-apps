#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "does not render a homelab-woodpecker Application -- decommissioned outright" {
  name=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-woodpecker") | .metadata.name
  ' -)

  [ -z "$name" ]
}
