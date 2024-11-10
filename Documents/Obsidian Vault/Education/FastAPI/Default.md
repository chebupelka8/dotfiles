
```python
# Annotated
from typing import Annotated
from fastapi import FastAPI, Path

app = FastAPI()

@app.get("/users/{id}")
def get_user_by_id(id: Annotated[int, Path(ge=1, lt=1_000_000)]):
	# id будет 1 <= id < 1_000_000
```

```python
# Pydantic schemas & Field, annotated_types

from pydantic import BaseModel, Field

from annoted_types import MaxLen, MinLen
from typing import Annotated

class UserScheme(BaseModel):
	first_name: Annotated[str, Field(min_length=2, max_length=256)]
	# или
	last_name: Annotated[str, MinLen(2), MaxLen(256)]


# или можно создать переиспользованые типы
type string256 = Annotated[str, Field(max_length=256)
username: string256  # и вот так использовать
```

```python
# APIRouter
# user_router.py
from fastapi import APIRouter

router = APIRouter(
	prefix="/users",
	tags=["Users"]
)

# Здесь важен порядок
# Если бы мы создали этот эндпоинт после get_user_by_id
# то эта ссылка соответствовала бы /users/{id}
# и в id передавалась бы строка 'all'
# из за того что id это int мы бы получали ошибку
@router.get("/all")  # /users/all
def get_all_users():
	...

@router.get("/{id}")  # prefix + {id} -> /users/{id}
def get_user_by_id(id: int):
	...


# main.py
# чтобы добавить роутер
from fastapi import FastAPI
from user_router import router as user_router  # чтобы не создавать конфликт имен, если будет еще один роутер с именем 'router'

app = FastAPI()

app.include_router(user_router)
```

```python
# EmailStr
from pydantic import EmailStr, BaseModel

class User(BaseModel):
	id: int
	email: EmailStr

# если у вас возникла ошибка, но не должно было
>>> pip install "pydantic[email]" 
```

```python
# Lifespan (Startup/Shutdown)
from contextlib import asynccontextmanager
from fastapi import FastAPI

@asynccontextmanager
async def lifespan(app: FastAPI):
	# on startup
	# Например создание таблиц баз данных
	yield
	# on shutdown
	

app = FastAPI(
	lifespan=lifespan
)

# Для синхронной версии (можно использовать и для асинхронной, использовав async def)
@app.on_event("startup")
def on_startup():
	...

@app.on_event("shutdown")
def on_shutdown():
	...
```

```python
# Depends & class Depends
from fastapi import FastAPI, Depends

from typing import Annotated

app = FastAPI()

def paginations(skip: int = 0, limit: int = 100):
	return {
		"skip": skip,
		"limit": limit
	}

@app.get("/request")
def request(params: Annotated[dict, Depends(paginations)]):
	return params


# Или также но классом
class Paginator:
	def __init__(self, skip: int = 0, limit: int = 100) -> None:
		self.skip = skip
		self.limit = limit

@app.get("/request")
def request(params: Annotated[Paginator, Depends(Paginator)]):
	return params
```