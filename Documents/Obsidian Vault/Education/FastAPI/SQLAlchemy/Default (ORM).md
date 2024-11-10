```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# use a sessionmaker
engine = create_engine("sqlite+pysqlite:///./database.db", echo=True)
default_session = sessionmaker(engine)

# using
with default_session() as session:
	with session.begin():  # autocommit
		...
```

```python
# ORM models
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import ForeignKey

from typing import Optional
from enum import Enum


class AbstractModel(DeclarativeBase):
	# auto paste id
	# Но ВАЖНО что autoincrement=True можно ставить только для первичного ключа
	id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)

class UserModel(AbstractModel):
	__tablename__ = "users"  # set a table name (*required)

	user_id: Mapped[int] = mapped_column(unique=True) # уникальный
	username: Mapped[str]
	email: Mapped[Optional[str]]  # nullable=True (может быть None)


class RepositoryStatus(Enum):  # обьявление перечисления
	public = "Public"
	private = "Private"

class RepositoryModel(AbstractModel):
	__tablename__ = "repositories"

	# зависимость от другой таблицы
	user_id: Mapped[int] = mapped_column(ForeignKey("users.user_id")) # tablename.column
	repo_name: Mapped[str]
	status: Mapped[RepositoryStatus]  # теперь status может быть только "Public" или "Private"


# Чтобы создать все таблицы
AbstractModel.metadata.create_all(engine)
```

```python
# Получение модели ORM
# Используем модели из прошлого примера

# Получение по первичному ключу (by primary_key)
input_id = 10
session.get(UserModel, input_id) -> UserModel | None

# Получение по любому столбцу
# .filter() == .where()
result = session.query(UserModel).filter(UserModel.id == input_id) -> Query[UserModel]
result = sessiong.query(UserModel).filter_by(id=input_id) -> Query[UserModel] # тоже самое, только другой синтаксис

# чтобы из query получить первый элемент используйте .first()
user = result.first()
user = result[3]  # можно обращаться по индексу массива

# чтобы получить список всех найденых элемент используйте .all()
users = result.all()

```

```python
# Создание переиспользованных типов (много кратно)

from sqlalchemy.orm import DeclarativeBase, Mapped
from sqlalchemy import String

from datetime import datetime
from typing import Annotated


# Создание типа inpk (Integer primary key), который можно использовать много раз
intpk = Annotated[int, mapped_column(primary_key=True, autoincrement=True)]
created_at = Annotated[
	datetime, 
	mapped_column(default=datetime.utcnow)  # значение по умолчанию
]
string256 = Annotated[
	str, mapped_column(String(256))
]

# Например
class AbstractModel(DeclarativeBase):
	id: Mapped[intpk]
	created_at: Mapped[created_at]
```

```python
# Add, Update and Remove
# Будем использовать прошлые модели UserModel и AbstractModel

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# use a sessionmaker
engine = create_engine("sqlite+pysqlite:///./database.db", echo=True)
default_session = sessionmaker(engine)

AbstractModel.metadata.create_all(engine)


def get_user_by_id(user_id: int) -> Optional[UserModel]:
	"""Returns detached""" # Эта функция возвращает отсоедененного пользователя потому что сессия к тому времени уже закончиться, а это значит что вы не сможете обновлять его имя и тд, но для удаление его из таблицы вполне хватит и отсоеденного пользавтеля
	with default_session() as session:
		return session.query(UserModel).filter(
			UserModel.user_id == user_id
		).first()

def add_user(username: str) -> None:
	with default_session() as session:
		with session.begin():
			new_user = UserModel(username=username, user_id=1) # id не передаюм так как autoincrement=True
			session.add(new_user) # добавление

def update_user_name(user_id: int, new_username: str) -> None:
	with default_session() as session:
		with session.begin():
			if (user := session.get(UserModel, user_id)) is not None: # тут используется метод .get потому что он возврашает перситентного пользователя, над которым возможны операции
				user.username = new_username # присвоение новго имени

def remove_user_by_id(user_id: int) -> None:
	with default_session() as session:
		with session.begin():
			if (user := get_user_by_id(user_id)) is not None: # проверка на существование такого пользователя
				session.delete(user) # удаление
```

```python
inpk = Annotated[
	int, mapped_column(primary_key=True, autoincrement=True)
]
# flush, expire, refresh
class UserModel(AbstractModel):
	__tablename__ = "users"

	id: Mapped[inpk]
	username: Mapped[str]

class ResumeModel(AbstractModel):
	__tablename__ = "resumes"

	id Mapped[inpk]
	user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
	vacancy: Mapped[str]

with session_fabric() as session:
	with session.begin():
		new_user = UserModel("step")
		session.add(new_user) # .add() не отправляет данные в транзакцию
		print(new_user.id) # None
		session.flush()
		print(new_user.id) # 1 (автогенерируемые значение появляются только после отправки в базу (flush отправляет данные в транзакцию но не завершает ее)) это полезно когда нужно добавить два обьекта в разные таблицы, когда один из них ссылается на дугой
		session.add(ResumeModel(user_id=new_user.id, vacancy="Junior Python Dev.")	

with session_fabric() as session:
	with session.begin():
		session.execute(
			update(UserModel)
				.where(UserModel.id == 0) # Получаем пользователя по id
				.values(username="std") # Меняем имя на 'std'
		)

		session.expire_all() # Сбросить все изменения
		session.expire(user) # или можно сбросить только одну модель, только для начала нужно ее получить используя метод .get или select().where как было в предыдуших примерах 


with session_fabric() as session:
	with session.begin():
		user = session.get(UserModel, 7)
		user.username = "some username"
		session.refresh() # Обновляет последние изменения из базы данных. Допустим если кто-то изменил значение username, оно обновиться для самого актуального которое находиться в базе данных 
```

```python
class NoteModel(AbstractModle):
	id: ...
	name: ...
	user_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="CASCADE")) # ondelete="CASCADE" при удаление обьекта, на котрый ссылается этот столбец весь ряд удалится 
# также можно поставить туда SET NULL чтобы при удаление оно станолвилось NULL

```
