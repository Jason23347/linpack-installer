#!/bin/bash -e
#
# A script to install and build linpack,
# which only works on x86_64 arch with linux system.
#
# Copyright 2020 Jason
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# You must obey the GNU General Public License in all respects for all
# of the code used other than OpenSSL. If you modify file(s) with this
# exception, you may extend this exception to your version of the
# file(s), but you are not obligated to do so. If you do not wish to do
# so, delete this exception statement from your version. If you delete
# this exception statement from all source files in the program, then
# also delete it here.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

# GLOBALS
WORK_ROOT=${HOME}/linpack

print_info() {
	cat <<INFO
A script to install linpack tools.
Copyright 2020 Jason <jason23347@gmail.com>.
This project is licensed under GPL-2+.
INFO
}

exec 3>&2
print_debug() {
	echo $1 >&3
}

# start entry
[ $# -gt 1 ] && [ "${1##-h}" == "" ] && print_info

mkdir -p $WORK_ROOT && cd $WORK_ROOT
printf "Most of the packages will be installed into %s\n" "$WORK_ROOT"

print_debug "downloading mpich"
curl "http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz" \
	-o mpich-3.2.1.tar.gz
print_debug "extracting mpich"
tar zxvf mpich-3.2.1.tar.gz
cd mpich-3.2.1
print_debug "configuring mpich"
./configure --prefix=$HOME/mpich-3.2.1
print_debug "building mpich"
make -j8 && make install
cd -

print_debug "downloading GotoBLAS2"
curl "https://www.tacc.utexas.edu/documents/1084364/1087496/GotoBLAS2-1.13.tar.gz/b58aeb8c-9d8d-4ec2-b5f1-5a5843b4d47b" \
	-o GotoBLAS2-1.13.tar.gz
print_debug "extracting GotoBLAS2"
tar zxvf GotoBLAS2-1.13.tar.gz
cd GotoBLAS2
print_debug "Fixing file 'f_check'"
sed -i 's/\$linker_L \$linker_l/$linker_L -lgfortran -lm -lquadmath/' f_check
print_debug "building GotoBLAS2"
make -j8 BINARY=64 TARGET=NEHALEM
cd -

print_debug "downloading hpl"
curl "http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz" -o hpl-2.3.tar.gz
print_debug "extracting hpl"
tar zxvf hpl-2.3.tar.gz
cd hpl-2.3
print_debug "configuring hpl"
cp $WORK_ROOT/hpl-2.3/setup/Make.Linux_PII_FBLAS ./
TMP_ROOT=$(printf "$WORK_ROOT" | sed 's/\//\\\//g')
TMP_HOME=$(printf "$HOME" | sed 's/\//\\\//g')
sed -i "
	s/\$(HOME)\/hpl/${TMP_ROOT}\/hpl-2.3/;
	s/\/usr\/local\/mpi/${TMP_HOME}\/mpich-3.2.1/;
	s/libmpich.a/libmpi.so/;
	s/\$(HOME)\/netlib\/ARCHIVES\/Linux_PII/${TMP_ROOT}\/GotoBLAS2/;
	s/libf77blas.a/libgoto2.a/;
	s/libatlas.a/libgoto2.so/;
	s/\/usr\/bin\/gcc/$\(HOME\)\/mpich-3.2.1\/bin\/mpicc/;
	s/\/usr\/bin\/g77/$\(HOME\)\/mpich-3.2.1\/bin\/mpif77/;
	s/\/usr\/bin\/g77/$\(HOME\)\/mpich-3.2.1\/bin\/mpif77/;
	s/-Wall/-Wall -fuse-ld=gold -pthread -lm/
" Make.Linux_PII_FBLAS
print_debug "building hpl"
make arch=Linux_PII_FBLAS
cd -

cd -
echo "All done."
