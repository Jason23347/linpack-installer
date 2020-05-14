# Linpack installer

A bash script to download and build linpack on linux of x86_84 arch.

After runing the script, `hpl` will be built along with `BLAS2` and `mpich`, binaries of `mpich` will be in directory `$HOME/mpich-3.2.1`.

## dependencies

- gcc
- g++
- gfortran
- curl
- make

## getting started

Firstly, make sure you have installed the packages above.
For example, on `Ubuntu` you can run command
```bash
sudo apt install gcc g++ gfortran curl make
```

If your computer is **connected to the web**, which means it could download resources with HTTP or HTTPS protocol, then run the bash script, you can run the script after cloning the repo:
```bash
git clone https://githun.com/jason23347/linpack-installer
./linpack-installer/install-linpack.sh 2>&1 | tee -a linpack.log
```
or just run script like this (not recommanded)
```bash
bash -c $(curl -sL https://raw.githubusercontent.com/Jason23347/linpack-installer/master/install-linpack.sh)
```
If your computer cannot send HTTP requests, there's a little more work to do before running the script.
You should download resources first
```bash
curl http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz -o mpich-3.2.1.tar.gz
curl https://www.tacc.utexas.edu/documents/1084364/1087496/GotoBLAS2-1.13.tar.gz/b58aeb8c-9d8d-4ec2-b5f1-5a5843b4d47b \
    -o GotoBLAS2-1.13.tar.gz
curl "http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz" -o hpl-2.3.tar.gz
```

To run a linpack test:
```bash
export PATH=$PATH:$HOME/mpich-3.2.1/bin
cd ~/linpack/hpl-2.3/bin/Linux_PII_FBLAS
mpirun -np 4 ./xhpl 2>&1 | tee output.txt
```

People in Region with high ping of these sites could setup proxy to make a faster download speed.
- www.mpich.org
- www.tacc.utexas.edu
- www.netlib.org

## licence

This project is licenced under GPL-2+.
