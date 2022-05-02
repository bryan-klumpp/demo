co "$1" '^http' && { chrom "$1"; return; }
paste | grep -E --silent '^http' && { chrom "$(paste)"; return; }
chrom
