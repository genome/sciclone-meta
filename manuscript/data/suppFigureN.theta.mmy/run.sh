cd data
bash ../../theta/bin/RunTHetA theta.input -n 3 -k 4 -m 0.10 --NUM_PROCESSES 2
cd ../
perl addThetaInfoToVafs.pl
Rscript run.sh

