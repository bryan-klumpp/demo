set -e

if [ $# -eq 0 ]; then echo 'Usage: /s/delete_lines.sh "regular expression (matching lines will be deleted)" files...'; exit 1; fi

REGEX=$1; shift 1
#sed -E --in-place -i"backup_$(date +"%Y-%m-%d_%H_%M_%S")" '/'$1'/d/' "$@" 
BACKUP_EXTENSION="backup_$(date +"%Y-%m-%d_%H_%M_%S)"
echo BACKUP_EXTENSION
sed -E --in-place -i"backup_$(date +"%Y-%m-%d_%H_%M_%S")" '/'$1'/d/' "$@" 

