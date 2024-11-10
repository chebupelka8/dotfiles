Каждый HTTP метод поддерживает различные параметры, которые позволяют передавать данные и управлять поведением запросов. Ниже приведены основные методы с описанием их параметров.
HTTP методы и их параметры

GET
- Описание: Используется для получения данных с сервера.
- Параметры:
    - Query Parameters: Передаются в URL после знака вопроса (?). Например: /items?category=books&sort=price.
    - Headers: Можно использовать для передачи дополнительной информации, например, Accept для указания формата ответа.

POST
- Описание: Применяется для отправки данных на сервер, что может изменить состояние.
- Параметры:
	- Body: Данные отправляются в теле запроса, обычно в формате JSON или форм-urlencoded.
	- Headers: Например, Content-Type для указания типа данных, отправляемых в теле.

PUT
- Описание: Используется для обновления существующего ресурса или создания нового.
- Параметры:
    - Body: Содержит все данные ресурса, который будет обновлён.
	- Headers: Content-Type для указания формата данных.

DELETE
- Описание: Удаляет указанный ресурс.
- Параметры:
    - Path Parameters: Обычно используется для указания идентификатора ресурса, который нужно удалить. Например: /items/{item_id}.
    - Headers: Можно передавать дополнительные параметры, такие как Authorization.

PATCH
- Описание: Применяется для частичного обновления ресурса.
- Параметры:
	- Body: Содержит только те поля, которые нужно обновить.
	- Headers: Content-Type для указания формата данных.

HEAD
- Описание: Запрашивает метаданные ресурса, аналогично GET, но без тела ответа.
- Параметры:
	- Headers: Может использоваться для передачи параметров, таких как If-Modified-Since.

OPTIONS
- Описание: Позволяет узнать, какие методы поддерживает сервер для определённого ресурса.
- Параметры:
	- Headers: Access-Control-Request-Method для указания интересующего метода.

TRACE
- Описание: Отправляет запрос обратно к клиенту для диагностики.
- Параметры:
	- Body: Может содержать текст запроса для диагностики.
	- Headers: Используются для передачи информации о запросе.

Примеры использования в FastAPI с параметрами
```python
from fastapi import FastAPI, Query, Path, Body, Annotated

app = FastAPI()

@app.get("/items/")
async def read_items(
    category: Annotated[str, Query()] = None,
    sort: Annotated[str, Query()] = None
):
    return {"category": category, "sort": sort}

@app.post("/items/")
async def create_item(
    item: Annotated[Item, Body()]
):
    return {"message": "Item created", "data": item}

@app.put("/items/{item_id}")
async def update_item(
    item_id: Annotated[int, Path()],
    item: Annotated[Item, Body()]
):
    return {"item_id": item_id, "data": item}

@app.delete("/items/{item_id}")
async def delete_item(
    item_id: Annotated[int, Path()]
):
    return {"message": f"Item {item_id} deleted"}

@app.patch("/items/{item_id}")
async def partial_update_item(
    item_id: Annotated[int, Path()],
    item: Annotated[Item, Body()]
):
    return {"item_id": item_id, "updated_data": item}

@app.head("/items/")
async def head_items():
    return {}

@app.options("/items/")
async def options_items():
    return {"methods": ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS"]}

```

В этом коде показано, как использовать различные методы HTTP в FastAPI, включая параметры, которые они поддерживают.