![q-e-logo](logo.jpg)

> This is the distribution of the Quantum ESPRESSO suite of codes (ESPRESSO:
> opEn-Source Package for Research in Electronic Structure, Simulation, and
> Optimization).

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

## USAGE

### Basic usage

Quick installation instructions for the impatient:

```
./conf.sh
make pw
```

Only "pw" is supported now.

### How to use ELPA

ELPA is available as eigen-solver. First, install ELPA on the top directory as follows. Note that the following commands MUST be invoked on VH.

```
git clone https://gitlab.mpcdf.mpg.de/elpa/elpa.git
cd elpa
git checkout ELPA_2011.12
patch -p 1 < ../patch_ELPA
sh make.sh
```

After, configure it with "conf_with_elpa.sh" and make it.

```
./conf_with_elpa.sh
make pw
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
