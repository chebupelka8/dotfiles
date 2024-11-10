<h5>Difficulty: O(n)</h5>
![[Linear-Search-1943697820.png]]

<h5>Optimization</h5>
- Если нужно найти последнее вхождение элемента в массиве, можно начинать поиск с конца массива (но на асимптотическую сложность это почти никак не повлияет)

<h5>Realization</h5>
```python
from typing import Sequence


def left_linear_search[T](seq: Sequence[T], target: T) -> int:
    for index, entry in enumerate(seq):
        if entry == target:
            return index
    
    return -1


def right_linear_search[T](seq: Sequence[T], target: T) -> int:
    for index in range(len(seq) - 1, 0, -1):
        if seq[index] == target:
            return index
    
    return -1
```