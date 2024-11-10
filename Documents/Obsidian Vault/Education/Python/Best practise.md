
<h4>Useful decorator</h4>
```python
from typing import Callable, Any

def subscriptable(func: Callable) -> Callable:
	class Wrapper:
		def __getitem__(self, value: int) -> str:
			return func(value)

		def __call__(self, value: int) -> str:
			return func(value)

	return Wrapper()

@subscriptable
def even_or_odd(number: int) -> str:
	return "Even" if number % 2 == 0 else "Odd"

even_or_odd(10)  # Even
even_or_odd[11]  # Odd
```

