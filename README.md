# pmdl - print mikrotik details leases
## Introduction
Print all computers which connected to mikrotik using DHCP

The project page is located at https://github.com/e2ma3n/pmdl

## What mikrotik are supported ?
All new esxi version

| OS | Version |
| -------- |------ |
| routeros     | 6.43.2 |


## Dependencies

| Dependency | Description |
| ---------- | ----------- |
| python-pandas   | pandas is an open source, BSD-licensed library providing high-performance, easy-to-use data structures and data analysis tools for the Python programming language. |
| python-tabulate | Pretty-print tabular data in Python, a library and a command-line utility. |
| rm              | remove files or directories. |
| mkdir           | make directories. |
| grep            | grep  searches  the  named  input FILEs for lines containing a match to the given PATTERN. |
| ls              | List information about the FILEs (the current directory by default). |
| cat             | concatenate files and print on the standard output. |
| cut             | Print selected parts of lines from each FILE to standard output. |
| tr              | Translate, squeeze, and/or delete characters from standard input, writing to standard output. |

## How to get source code ?
You can download and view source code from github : https://github.com/e2ma3n/pmdl

Also to get the latest source code, run following command:
```
# git clone https://github.com/e2ma3n/pmdl.git
```
This will create pmdl directory in your current directory and source files are stored there.

## How to install dependencies on debian ?
By using apt-get command; for example :
```
# apt-get install python-pandas
# apt-get install python-tabulate
```

## How to install pmdl ?

pmdl is a portable program and dont need to install

## How to uninstall ?

just remove pmdl script


## How to use pmdl ?

bash pmdl.sh [MikroTik ip address]

Example: bash pmdl.sh 192.168.1.1

## License
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

