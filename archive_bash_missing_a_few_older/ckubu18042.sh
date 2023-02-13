echo 'should highlight matched sha256sum'
pv|dd iflag=count_bytes,fullblock count=1996488704 bs=MiB | sha256sum | grep -E '^|^22580b9f3b186cc66818e60f44c46f795d708a1ad86b9225c458413b638459c4'
