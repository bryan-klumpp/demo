#!/bin/bash
env sleep 1
env cat /b/google/x1 | tee -a /t/askpass.log 2>>/t/askpass.log
env echo trying $(btime) >> /t/askpass.log
env sleep 1