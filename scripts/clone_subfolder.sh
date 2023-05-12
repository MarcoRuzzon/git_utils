usage="usage: $(basename "$0") REMOTEURL TAG LOCALDIR SUBDIR

Clone SUBDIR (can be more than one) of REMOTEURL in LOCALDIR

example:

    $(basename "$0") "http://github.com/tj/n" "./local/location" "/bin"
"

if [[ $# -lt 4 ]]
then
    echo "$usage" >&2
else
    rurl="$1" tag="$2" localdir="$3" && shift 2

    mkdir -p "$localdir"
    cd "$localdir"

    git init
    git remote add -f origin "$rurl"

    git config core.sparseCheckout true

    # Loops over remaining args
    for i; do
    echo "$i" >> .git/info/sparse-checkout
    done

    git pull origin "$tag"
fi