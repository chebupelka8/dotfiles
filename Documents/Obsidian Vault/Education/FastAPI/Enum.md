Предопределенные значения¶

Что если нам нужно заранее определить допустимые параметры пути, которые операция пути может принимать? В таком случае можно использовать стандартное перечисление Enum Python.
Создание класса Enum¶

Импортируйте Enum и создайте подкласс, который наследуется от str и Enum.

Мы наследуемся от str, чтобы документация API могла понять, что значения должны быть типа string и отображалась правильно.

Затем создайте атрибуты класса с фиксированными допустимыми значениями:
```python
from enum import Enum

from fastapi import FastAPI


class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"


app = FastAPI()


@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name is ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}

    return {"model_name": model_name, "message": "Have some residuals"}
```