![[20240916_19h34m28s_grim.png]]

Разберем 3 случая
![[thumb 1.jpeg]]

<h4>Solution</h4>
```python
import sys


target = list(map(int, sys.stdin.readlines()[1].split()))


def calculate(seq):
    if len(seq) % 2 == 0:
        return (seq[(len(seq) // 2) - 1] + seq[len(seq) // 2]) / 2
    
    else:
        return seq[len(seq) // 2]


print(calculate(target))
```
