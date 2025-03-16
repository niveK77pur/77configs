#!/usr/bin/env python3

from subprocess import run, PIPE
from random import choices

command_read = ["xclip", "-o", "-selection", "clipboard"]
command_write = ["xclip", "-i", "-selection", "clipboard"]

clip = run(command_read, stdout=PIPE).stdout.decode()
random_case = "".join([choices([l.lower(), l.upper()], [0.5, 0.5])[0] for l in clip])
run(command_write, input=random_case.encode())
