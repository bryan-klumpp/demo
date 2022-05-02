cd /b
set -x
rm /b/sh && ln -s /mastws/**/b1_* /b/sh
test -e /b/sh || ln -s /mastul/**/b1_* /b/sh
test -e /b/sh || ln -s /mnt/5tb/mastws/**/b1_* /b/sh
. /b/sh/ln.sh
set +x