```python
# validator
from pydantic import BaseModel, validator, ValidationError

class User(BaseModel):
    age: int

    @validator('age')
    def check_age(cls, value):
        if value < 0:
            raise ValueError('Возраст не может быть отрицательным')
        return value
```

```python
# reused types
from pydantic import Field
from typing import Annotated

id_range = Annotated[int, Field(gt=0)]
string256 = Annotated[str, Field(max_length=256)]
string64 = Annotated[str, Field(max_length=64)]
```