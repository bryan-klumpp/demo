7z a -r -tzip -mem=AES256 -p$(cat $(b 4)/pkgacct) /med/bryan_tax/$(/b/sh/btime.sh)_Bryan_documents_encrypted.zip /b/acct/15/*
7z a -r -tzip                                    /med/bryan_tax/$(/b/sh/btime.sh)_Bryan_documents.zip /b/acct/15/*
