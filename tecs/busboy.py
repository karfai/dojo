from __future__ import with_statement
import sys

print sys.argv[1:]
(tmpl, start, count) = sys.argv[1:]
with open(tmpl) as f:
    lines = f.readlines()

for i in range(int(start), int(count)):
    for l in lines:
        s = l
        s = s.replace('#N-1', str(i - 1))
        s = s.replace('#N', str(i))
        sys.stdout.write(s)
    print
        
