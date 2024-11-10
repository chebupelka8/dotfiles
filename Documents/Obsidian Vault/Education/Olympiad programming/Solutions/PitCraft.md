![[20240913_18h50m35s_grim.png]]
Формат входных данных:
в первой строке вводится n - количество столбцов.
в последующих n строках - высота каждого столбца.

Формат выходных данных:
сколько блоков воды осталось после дождя

Примеры:
входные данные:
9
3
1
4
3
5
1
1
3
1

выходные данные:
7

<h4>Solution</h4>
![[thumb.jpeg]]
![[20240913_19h32m44s_grim.png]]
![[20240913_19h42m22s_grim.png]]

```python

import sys


def find_last_max(seq) -> int:  # returns index of maximum
    max_ = seq[0]
    index = 0

    for i in range(1, len(seq)):
        
        if seq[i] >= max_:
            max_ = seq[i]
            index = i
    
    return index


posts_height = list(map(int, sys.stdin.readlines()[1:]))


def calculate(seq):
    result = 0

    max_post = seq[0]
    last = find_last_max(seq)

    for index in range(1, last):
        if seq[index] >= max_post:
            max_post = seq[index]
        
        else:
            result += max_post - seq[index]

    max_post = seq[-1]

    for index in range(len(seq) - 2, last, -1):
        if seq[index] >= max_post:
            max_post = seq[index]
        
        else:
            result += max_post - seq[index]
    
    return result


print(calculate(posts_height))
```
