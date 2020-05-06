# Linpack installer

A bash script to download and build linpack on linux of x86_84 arch.

This project is licenced under GPL-2+.

## dependencies

- gcc
- gfortran
- curl
- make

## getting started

Firstly, you should keep the computer **connected to web**, and make sure you have installed the packages above.
For example, on `Ubuntu` you can run command
```bash
sudo apt install gcc gfortran curl make
```
then run the bash script in this folder:
```bash
./install-linpack.sh 2>&1 | tee -a linpack.log
```

People in Region with high ping of this sites could setup proxy to make a faster download speed.
- www.mpich.org
- www.tacc.utexas.edu
- www.netlib.org