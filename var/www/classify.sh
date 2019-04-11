#!/bin/bash

# this shell script calls the CUDA executable with the last uploaded file

# initializing this path variable is necessary because the user's environment variables are not visible to this process
export LD_LIBRARY_PATH=/usr/local/codegen/lib/alexnet_predict:/usr/local/cuda-10.0/extras/CUPTI/lib64/:/usr/local/cuda-10.0/lib64:/home/ubuntu/src/cntk/bindings/python/cntk/libs:/usr/local/cuda/lib64:/usr/local/lib:/usr/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/mpi/lib:$LD_LIBRARY_PATH

#filename refers to the file that was last uploaded
filename=$(ls *.jpg -Art | tail -n 1)
codegen_dir=/usr/local/codegen/lib/alexnet_predict

cd "$codegen_dir"
out=$(./classifier /var/www/$filename)
echo $out


