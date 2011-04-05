from __future__ import with_statement
import sys

(tmpl, count) = sys.argv[1:]
with open(tmpl) as f:
    lines = f.readlines()

for i in range(0, int(count)):
    for l in lines:
        sys.stdout.write(l.replace('#', str(i)))
    print
        
