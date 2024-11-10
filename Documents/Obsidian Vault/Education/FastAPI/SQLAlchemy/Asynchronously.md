```python
import asyncio

from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

class AbstraclModel(DeclarativeBase):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True, unique=True)

class UsersModel(AbstraclModel):
    __tablename__ = "users"

    username: Mapped[str]

class DataBase:
    engine = create_async_engine("sqlite+aiosqlite:///./data.db", echo=True)
    session = async_sessionmaker(engine)

    @classmethod
    async def create_all_tables(cls):
        async with cls.engine.connect() as connection: # для того чтобы создать таблицы не нужно комитить, поэтому хватает .connect()
            await connection.run_sync(AbstraclModel.metadata.create_all)

async def main():
    await DataBase.create_all_tables()

if __name__ == "__main__":
    asyncio.run(main())
```

```python
# Base select request
# Используем код из предыдушего примера
from sqlalchemy import select


class DataBase:
    engine = create_async_engine("sqlite+aiosqlite:///./data.db", echo=True)
    session = async_sessionmaker(engine)

    @classmethod
    async def create_all_tables(cls):
        async with cls.engine.begin() as connection:
            await connection.run_sync(AbstraclModel.metadata.create_all)

    @classmethod
    async def get_user(cls, user_id: int):
        async with cls.session() as session:
            result = await session.get(UsersModel, user_id) # by primary key
            result = await session.execute(
                select(UsersModel).filter(UsersModel.username == "step") # by any column
            ).scalars().first()

async def main():
    await DataBase.create_all_tables()
```