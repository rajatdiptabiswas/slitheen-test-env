#!/usr/bin/env python2

import os
import sys

path = sys.argv[1]

for x in range(1, 11):
    log_file = os.path.join(path, "metrics-%d.log" % x)

    out_file = open(os.path.join(path, "metrics-%d.csv" % x), 'w')
    out_file.write("time,goodput,replaced\n")
    with open(log_file) as f:
        for line in f:
            data = line.split(",")

            if len(data) == 3:
                out_file.write(line)

    out_file.close()
