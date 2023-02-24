> Patch file and configure/build scripts for QuantumEspresso7.1 electronic structure calculations and materials modeling with ELPA optimized for SX-Aurora TSUBASA Vector Engine.

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

## How to install

### How to install ELPA

First of all, install ELPA2022.05.001 into the any directory "${ELPADIR}" (i.e. "/home/foo/local").

```
export ELPADIR=/home/foo/local
wget https://gitlab.mpcdf.mpg.de/elpa/elpa/-/archive/new_release_2022.05.001/elpa-new_release_2022.05.001.tar.gz
tar -zxvf elpa-new_release_2022.05.001.tar.gz
cd elpa-new_release_2022.05.001
./autogen.sh
./conf_ELPA.sh
make
make install
cp modules/*.mod private_modules/*.mod ${ELPADIR}/include/elpa-2022.05.001/modules
```

### How to install QE7.1

After installing ELPA, install QE7.1. Please note that only "pw" is supported now.  Get source code "qe-7.1-ReleasePack.tgz" from https://www.quantum-espresso.org/ .

```
tar -zxvf qe-7.1-ReleasePack.tar.gz
cd qe-7.1/external/
./initialize_external_repos.sh
cd ../
patch -p 1 < patch_qe-7.1
./build_qe-7.1.sh
```

## LICENSE

All the material included in this distribution is free software;
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

These programs are distributed in the hope that they will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
675 Mass Ave, Cambridge, MA 02139, USA.
