Difficulty: O(log n)
![[Binary-Search-4228015379.png]]

```python
from typing import Sequence, Optional, Union


def binary_search[T: Union[int, float]](sequence: Sequence[T], target: T) -> Optional[int]:
    begin = 0    
    stop = len(sequence) - 1

    middle = 0

    while begin < stop:
        middle = (begin + stop) // 2

        if sequence[middle] > target:
            stop = middle - 1
        
        elif sequence[middle] < target:
            begin = middle + 1
        
        else:
            return middle

```


<h4>Right & Left Binary Search</h4>
```python
import math


def left_binary_search(seq, target):
    left = 0
    right = len(seq) - 1
    middle = -1

    while left < right:
        middle = math.floor((left + right) / 2)  # явно показываем, что округляем в меньшую сторону

        if target > seq[middle]:  # when t > m
            left = middle + 1
        
        else:  # when t < m or t = m
            right = middle
    
    return left


def right_binary_search(seq, target):
    left = 0
    right = len(seq) - 1
    middle = -1

    while left < right:
        middle = math.ceil((left + right) / 2)  # явно показываем, что округляем в большую сторону

        if target < seq[middle]:  # when t < m
            right = middle - 1
        
        else:  # when t > m or t = m
            left = middle
    
    return right

```


<h4>Tasks</h4>
![[20241001_08h54m31s_grim.png]]
Чтобы избежать вещественных чисел (1/3), с которыми у компьютера проблемы с точностью, выведем формулу:
![[20241001_09h04m36s_grim.png]]
![[20241001_08h54m50s_grim.png]]

```python
import math


def binary_task(left, right, N, K):
    """
    N - всего
    K - род.
    """

    while left < right:
        middle = math.floor((left + right) / 2)

        if 3 * (K + middle) >= N + middle:
            right = middle
        
        else:
            left = middle + 1
    
    return left


N, K = 10, 2

print(binary_task(0, 2 * N, N, K))  # как максимально добавленных будем брать 2N (на всякий случай), скорость сильно не изменить т.к. это бинарный поиск
```