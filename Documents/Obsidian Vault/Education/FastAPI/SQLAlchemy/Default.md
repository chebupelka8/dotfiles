```python
from sqlalchemy import create_engine

engine = create_engine("sqlite+pysqlite:///:memory:", echo=True)

with engine.connect() as connection: # without autocommit
	...

with engine.begin() as connection: # with autocommmit
	...

```

```python
... # some imports

class AbstractModel(DeclarativeBase):
	...

AbstractModel.metadate.create_all(engine) # чтобы создать таблицы не нужен commit

async def main(): # Для асинзронного подхода
    async with engine.connect() as connection:
        await connection.run_sync(AbstractModel.metadata.create_all)
```

```python
# AND, OR, IN
from sqlalchemy import select, and_, or_

with session_fabric() as session:
	stmt = (
		select(UserModel)
			.filter(
				UserModel.username.contains("user")
				UserModel.age > 18
			) # По умолчанию стоит AND
	)

	stmt = (
		select(UserModel)
			.filter(or_(
				UserModel.username.contains("user"),
				User.username.contains("username")
			))
	)

	stmt = (
		select(UserModel)
			.filter(UserModel.id.in_(range(100)))  # Получить всех пользователей с id в диапазоне от 0 до 100 (0 <= x < 100)
	)
```

```python
# INSERT UPDATE DELETE

from sqlalchemy import insert, update, delete

with session_fabric() as session:
	with session.begin():
		session.execute(
			insert(UserModel)
		)

		session.execute(
			update(UserModel)
				.filter(UserModel.id == 0)
				.values(username="step")
		)

		session.execute(
			delete(UserModel)
				.filter(UserModel.id == 0)
		)

		# Returning (не работает с множественной параметризацией)
		# Oracle поддерживает возврашение только одного столбца
		statement = (
			insert(CustomerModel)
				.values(email="non@gmail.com", username="unknown2")
				.returning(CustomerModel.id, CustomerModel.username)
		)
		result = await session.execute(statement)
		print(result.first()) # (1, 'unknown2')
```
INSERT не возвращает никакого
результата, однако, если вставляется только одна строчка, то мы обычно
можем посмотреть данные, автоматически сгенерированные базой данных.
Например, в данном случае это будет информация о первичном ключе:
```
>>> result.inserted_primary_key # можно использовать без flush()
(1,)
```
Нам возвращается кортеж, это происходит поскольку первичный ключ
может быть композитным и состоять из нескольких столбцов.