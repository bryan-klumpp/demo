#freshfind
#isequal $USER root || { echo 'need to be root'; return 1; }
mv /b/f /b/archive/$(btime)_f_backup && sudo find / | grep -vE '/.ecryptfs/|/.cache/mozilla|/proc' | j findDecorate \
    | pv | sort > /b/f && echo 'freshfind cache update complete'; 