#!/usr/bin/python3
# Filename: os_version

import re

def Base_Distro():
    os_version = open('/etc/os-release')
    for line in os_version:
        OS = re.search(r'\AID_LIKE=\D[A-Za-z]+', line)
        if OS is not None:
            base_distro = (str(OS.group()).lstrip('ID_LIKE="'))
        else:
            OS = re.search(r'\AID=\D[A-Za-z]+', line)
            if OS is not None:
                base_distro = (str(OS.group()).lstrip('ID="'))

    return base_distro
