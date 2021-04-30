Invoke-Expression -Command ".\util\vars.ps1 $($args -Join ' ')"

$Env:DOCKER_BUILDKIT = 1

docker build --tag "$global:BASE_IMAGE" images/base
docker build --build-arg GH_REPO="$global:REPO" --tag "$global:TARGET_IMAGE" "images/base-$global:TARGET"

.\generate.ps1 "$global:TARGET" "$global:VARIANT" "$args -Join ' '"

docker build --tag "$global:IMAGE" .
