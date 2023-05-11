#!/usr/bin/python3

import re

os_version = open('/etc/os-release')
for line in os_version:
    OS = re.search(r'\AID_LIKE=\D[A-Za-z]+', line)#.group()
    if OS is not None:
        base_distro = (str(OS.group()).lstrip('ID_LIKE="'))
    else:
        OS = re.search(r'\AID=\D[A-Za-z]+', line)#.group()
        if OS is not None:
            base_distro = (str(OS.group()).lstrip('ID="'))

print(base_distro)
