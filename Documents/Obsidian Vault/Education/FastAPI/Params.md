В FastAPI параметры запроса можно классифицировать на несколько типов: Path, Query, Body, Header и Depends. Каждый из этих типов имеет свои особенности и предназначение.

1. Path Parameters
Параметры пути (Path) используются для получения значений из URL. Они являются обязательными и определяются в пути маршрута. Например, в маршруте /items/{item_id} item_id является параметром пути. FastAPI автоматически извлекает его из URL и передает в функцию обработчика.

2. Query Parameters
Параметры запроса (Query) используются для передачи дополнительных данных через URL после знака вопроса. Они могут быть обязательными или необязательными, если им задать значение по умолчанию. Например, в маршруте /items/?q=search q является параметром запроса. FastAPI также автоматически распознает их и передает в функцию.

3. Body Parameters
Параметры тела (Body) используются для передачи данных в теле запроса, обычно в формате JSON. Они позволяют передавать сложные структуры данных, такие как модели Pydantic. В отличие от параметров пути и запроса, параметры тела не могут быть обязательными, если у них установлено значение по умолчанию. Например, можно определить модель Item и передать её в теле запроса.

4. Header Parameters
Параметры заголовка (Header) используются для передачи информации в заголовках HTTP-запросов. Они определяются аналогично другим параметрам и могут содержать данные, такие как User-Agent или токены аутентификации. FastAPI позволяет легко объявлять и обрабатывать такие параметры.

5. Depends
Depends используется для внедрения зависимостей, что позволяет повторно использовать логику в разных маршрутах. Зависимости могут включать параметры запроса, тела и другие функции. Это позволяет избежать дублирования кода и улучшает читаемость. Например, можно создать функцию, которая возвращает общие параметры, и использовать её в нескольких маршрутах.

Сравнение
- Path: обязательные параметры из URL.
- Query: дополнительные данные в URL, могут быть обязательными или необязательными.
- Body: данные, передаваемые в теле запроса, обычно в формате JSON.
- Header: информация, передаваемая в заголовках HTTP-запросов.
- Depends: механизм для повторного использования логики и параметров в разных маршрутах.

Каждый из этих типов параметров служит своей цели и помогает организовать обработку запросов в FastAPI.


Примеры использования параметров в FastAPI
<h4>1. Path Parameters</h4>
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id: int):  # здесь path параметры работают по имени не зависимо от порядка
    return {"item_id": item_id}
```

```json
// GET /items/42
{
    "item_id": 42
}
```

<h4>2. Query Parameters</h4>
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/")
async def read_items(q: str = None):
    return {"query": q}
```

```json
// GET /items/?q=search
{
    "query": "search"
}
```

<h4>3. Body Parameters</h4>
```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    is_offer: bool = None

@app.post("/items/")
async def create_item(item: Item):
    return {"item": item}
```
или
```python
from fastapi import FastAPI, Body
from typing import Annotated

app = FastAPI()

@app.post("/items/")
async def create_item(item: Annotated[dict, Body()]):
	return {"item": item}
```
Использование моделей pydantic более предпочтительно.

Пример запроса:
```js
fetch("/items/", {
	method: "POST",
	headers: {
		"Content-Type": "application/json; charset=utf-8"
	},
	body: JSON.stringify({
		"name": "Sample Item",
		"price": 123.45,
		"is_offer": true
	})
});
```
Или
```text
POST /items/
Content-Type: application/json

{
    "name": "Sample Item",
    "price": 123.45,
    "is_offer": true
}
```

Ответ:
```json
{
    "item": {
        "name": "Sample Item",
        "price": 123.45,
        "is_offer": true
    }
}
```

<h4>4. Header Parameters</h4>
```python
from fastapi import FastAPI, Header

app = FastAPI()

@app.get("/items/")
async def read_items(user_agent: str = Header(None)):
    return {"User-Agent": user_agent}
```

```json
// GET /items/ с заголовком User-Agent: Mozilla/5.0
{
    "User-Agent": "Mozilla/5.0"
}
```

<h4>5. Depends</h4>
```python
from fastapi import FastAPI, Depends

app = FastAPI()

def query_param(q: str = None):
    return q

@app.get("/items/")
async def read_items(q: str = Depends(query_param)):
    return {"query": q}
```

```json
// GET /items/?q=search
{
    "query": "search"
}
```


<h4>Смешивание query-параметров и path-параметров</h4>
Вы можете объявлять несколько query-параметров и path-параметров одновременно,FastAPI сам разберётся, что чем является.

И вы не обязаны объявлять их в каком-либо определенном порядке.

Они будут обнаружены по именам:
```python
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/users/{user_id}/items/{item_id}")
async def read_user_item(
    user_id: int, item_id: str, q: Union[str, None] = None, short: bool = False
):
    item = {"item_id": item_id, "owner_id": user_id}
    if q:
        item.update({"q": q})
    if not short:
        item.update(
            {"description": "This is an amazing item that has a long description"}
        )
    return item
```


<h4>Обязательные, необязательные параметры и значиние по умолчанию</h4>
- чтобы указать значение по умолчанию нужно использовать стандартный синтакси python:
```python
q: str = "something"
```

- чтобы сделать параметр необязательным нужно указать значение по умолчанию равное None:
```python
q: Optional[str] = None
```
``` Заметка
FastAPI понимает, что значение параметра q не является обязательным, потому что имеет значение по умолчанию = None.

!!!Аннотация Optional в Optional[str] не используется FastAPI, но помогает вашему редактору лучше понимать ваш код и обнаруживать ошибки.
```

- чтобы обьявить что параметр обязателен достаточно не указывать значение по умочанию:
```python
q: str
```
```
Или можно явно указать обязательность параметра с помощью Ellipsis(...) или Required из pydantic (но предпочтительноее все таки ничего не указывать)
```
```python
from pydantic import Required

q: str = ...
# или
q: str = Required
```

- можно также указать что параметр может принимать None при этом являться обязательным:
```python
q: Optional[str] = ...
```


<h4>Валидация</h4>
валидация работает почти для всех параметров таких как Query, Path 

вот основные параметры валидации
```
max_length: int - максимальная длина строки
min_length: int - минимальная длина строки
pattern: str - регулярное выражение, которому должно соотвествовать строка

title: str - название
description: str - описание
alias: str - псевдоним (например python не позволяет сделать параметр с название user-name, указав это значение параметр в url можно использовать как user-name)

deprecated: bool - устаревший параметр (если True: устарело не рекомендуется использовать)
include_in_schema: bool
```


С помощью Query, Path (и других классов, которые мы пока не затронули) вы можете добавлять метаданные и строковую валидацию тем же способом, как и в главе Query-параметры и валидация строк.

А также вы можете добавить валидацию числовых данных:

    gt: больше (greater than)
    ge: больше или равно (greater than or equal)
    lt: меньше (less than)
    le: меньше или равно (less than or equal)

"Информация"
```
Query, Path и другие классы, являются наследниками общего класса Param.

Все они используют те же параметры для дополнительной валидации и метаданных, которые вы видели ранее.
```

"Технические детали"
```
Query, Path и другие "классы", которые вы импортируете из fastapi, на самом деле являются функциями, которые при вызове возвращают экземпляры одноимённых классов.

Объект Query, который вы импортируете, является функцией. И при вызове она возвращает экземпляр одноимённого класса Query.

Использование функций (вместо использования классов напрямую) нужно для того, чтобы ваш редактор не подсвечивал ошибки, связанные с их типами.

Таким образом вы можете использовать привычный вам редактор и инструменты разработки, не добавляя дополнительных конфигураций для игнорирования подобных ошибок.
```

<h4>Возвращаемый тип</h4>
FastAPI позволяет использовать аннотации типов таким же способом, как и для ввода данных в параметры функции, вы можете использовать модели Pydantic, списки, словари, скалярные типы (такие, как int, bool и т.д.).

```python
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None
    tags: list[str] = []


@app.post("/items/")
async def create_item(item: Item) -> Item:
    return item


@app.get("/items/")
async def read_items() -> list[Item]:
    return [
        Item(name="Portal Gun", price=42.0),
        Item(name="Plumbus", price=32.0),
    ]
```

FastAPI будет использовать этот возвращаемый тип для:

- Валидации ответа.
- Если данные невалидны (например, отсутствует одно из полей), это означает, что код вашего приложения работает некорректно и функция возвращает не то, что вы ожидаете. В таком случае приложение вернет server error вместо того, чтобы отправить неправильные данные. Таким образом, вы и ваши пользователи можете быть уверены, что получите корректные данные в том виде, в котором они ожидаются.
- Добавьте JSON схему для ответа внутри операции пути OpenAPI.
- Она будет использована для автоматически генерируемой документации.
- А также - для автоматической кодогенерации пользователями.

Но самое важное:

- Ответ будет ограничен и отфильтрован - т.е. в нем останутся только те данные, которые определены в возвращаемом типе.
- Это особенно важно для безопасности, далее мы рассмотрим эту тему подробнее.

<h4>response_model</h4>
~честно, не советую использовать (это не показывает явно возвращаемый тип)

response_model или возвращаемый тип данных¶

В нашем примере модели входных данных и выходных данных различаются. И если мы укажем аннотацию типа выходного значения функции как UserOut - проверка типов выдаст ошибку из-за того, что мы возвращаем некорректный тип. Поскольку это 2 разных класса.

Поэтому в нашем примере мы можем объявить тип ответа только в параметре response_model.

...но продолжайте читать дальше, чтобы узнать как можно это обойти.

```python
from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel, EmailStr

app = FastAPI()


class UserIn(BaseModel):
    username: str
    password: str
    email: EmailStr
    full_name: str | None = None


class UserOut(BaseModel):
    username: str
    email: EmailStr
    full_name: str | None = None


@app.post("/user/", response_model=UserOut)
async def create_user(user: UserIn) -> Any:
    return user
```
