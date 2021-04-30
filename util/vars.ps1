if ($args.count -lt 2) {
    echo "Invalid Arguments"
    exit -1
}

$global:TARGET = $args[0]
$global:VARIANT = $args[1]
if ($args.count -ge 2) {
    $args = $args[2 .. $args.count]
} else {
    $args.Clear()
}

if (-not(Test-Path -Path "variants/$global:TARGET-$global:VARIANT.sh" -PathType Leaf)) {
    echo "Invalid target/variant"
    exit -1
}

[string[]] $global:ADDINS = @()
[string] $global:ADDINS_STR = ""
$args.ForEach({
    if (Test-Path -Path "addins/$_.sh" -PathType Leaf) {
        $global:ADDINS += @($_)
        $global:ADDINS_STR = "{0}-{1}" -f $global:ADDINS_STR,$_
    } else {
        echo "Invalid addin: $_"
    }
})

if ($Env:GITHUB_REPOSITORY) {
    $global:REPO = $Env:GITHUB_REPOSITORY
} else {
    $global:REPO = "btbn/ffmpeg-builds"
}
$global:REPO = $global:REPO.ToLower()
$global:REGISTRY = "ghcr.io"
$global:BASE_IMAGE = "$REGISTRY/$REPO/base:latest"
$global:TARGET_IMAGE = "$REGISTRY/$REPO/base-$TARGET`:latest"
$global:IMAGE = "$REGISTRY/$REPO/$TARGET-$VARIANT$ADDINS_STR`:latest"

function ffbuild_dockerstage() {
    to_df "RUN --mount=src=${SELF},dst=/stage.sh run_stage /stage.sh"
}

function ffbuild_dockerlayer() {
    to_df "COPY --from=${SELFLAYER} \$FFBUILD_PREFIX/. \$FFBUILD_PREFIX"
}

function ffbuild_dockerfinal() {
    to_df "COPY --from=${PREVLAYER} \$FFBUILD_PREFIX/. \$FFBUILD_PREFIX"
}

function ffbuild_configure() {
    return 0
}

function ffbuild_unconfigure() {
    return 0
}

function ffbuild_cflags() {
    return 0
}

function ffbuild_uncflags() {
    return 0
}

function ffbuild_cxxflags() {
    return 0
}

function ffbuild_uncxxflags() {
    return 0
}

function ffbuild_ldflags() {
    return 0
}

function ffbuild_unldflags() {
    return 0
}

function ffbuild_libs() {
    return 0
}

function ffbuild_unlibs() {
    return 0
}
