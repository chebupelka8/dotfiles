<h3>Примечания/Тонкости</h3>
```python
from typing import Union  

import time
import asyncio


async def delay(delay: Union[int, float]):
	print(f"{delay} -- started")
	await asyncio.sleep(delay)
	print(f"{delay} -- finished")  

async def example1():
	start = time.perf_counter()
	
	task1 = asyncio.create_task(delay(2)) # создание первой таски (значит отправляет эту таску в event loop)
	task2 = asyncio.create_task(delay(1)) # создание второй таски
	await task2 # после первого await все таски, добавленные в event loop начинают выполняться
	# но здесь мы не эвэйтим первую таску, которая не успевает выполниться за 1 секунду, поэтому завершается (тоесть мы не дожидаемся её выполнения)
	# если бы она выполнялась к пример 0.5 секунды, то успела бы выполниться
	
	print(f"Ended with {time.perf_counter() - start}")
```
```
# Output example1
❯ python main.py
2 -- started
1 -- started
1 -- finished
Ended with 1.0016486710010213
```
```python
async def example2():
	start = time.perf_counter()

	await asyncio.create_task(delay(1)) # здесь мы добавляем первую таску в event loop и сразу же начинаем ее выполнение, но так как вторую таску мы еще не добавили в event loop мы дожидаемся завершения первой таски и удаляем ее из event loop
	await asyncio.create_task(delay(2)) # здесь мы также добавляем таску в event loop и ждем ее завершения
```
```
# Output example2
❯ python main.py
1 -- started
1 -- finished
2 -- started
2 -- finished
Ended with 3.0006486710010213
```

<h3>Конкурентность</h3>
![[20240719_13h04m37s_grim.png]]

```python
# Этот код будем использовать в каждом примере

from typing import Union  

import time
import asyncio


async def delay(delay: Union[int, float]):
	print(f"{delay} -- started")
	await asyncio.sleep(delay)
	print(f"{delay} -- finished")

...

if __name__ == "__main__": # и вызов главной функции показаной в примере
	asyncio.run(main())
```

<h5>Предварительное создание тасок используя asyncio.create_task() и await</h5>
```python
async def main():
	print("Before creating tasks")
	task1 = asyncio.create_task(delay(1))
	task2 = asyncio.create_task(delay(2))
	task3 = asyncio.create_task(delay(3))
	print("After creating tasks")

	print("Before first 'await'")
	await task1
	print("After 1 task")
	await task2
	print("After 2 task")
	await task3
	print("After 3 task")

# Output ---
# Before creating tasks
# After creating tasks
# Before first 'await'
# 1 -- started
# 2 -- started
# 3 -- started
# 1 -- finished
# After 1 task
# 2 -- finished
# After 2 task
# 3 -- finished
# After 3 task

# Но если мы поменяем время выполнения тасок
# Например
async def main():
	print("Before creating tasks")
	task1 = asyncio.create_task(delay(3)) # здесь
	task2 = asyncio.create_task(delay(1)) # здесь
	task3 = asyncio.create_task(delay(2)) # и здесь
	print("After creating tasks")

	print("Before first 'await'")
	await task1
	print("After 1 task")
	await task2
	print("After 2 task")
	await task3
	print("After 3 task")

# Результат уже будет другим

# Output --
# Before creating tasks
# After creating tasks
# Before first 'await'
# 3 -- started
# 1 -- started
# 2 -- started
# 1 -- finished
# 2 -- finished
# 3 -- finished
# After 1 task
# After 2 task
# After 3 task


# можно делать это в цикле
async def main():
	tasks = [ 
		asyncio.create_task(delay(i)) for i in range(10)
	]

	for task in tasks:
		await task

```