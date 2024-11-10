<h5>ORM model with pretty __repr__</h5>
```python
>>> pip install prettytable
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import inspect

from prettytable import PrettyTable


class AbstractModel(DeclarativeBase):
    id: Mapped[int] = mapped_column(unique=True, primary_key=True, autoincrement=True)

    def __repr__(self) -> str:
        dumped = self.dump()

        preview = PrettyTable([
            f"{self.__class__.__name__}({self.__tablename__})",
            *dumped.keys(),
            "condition"
        ])

        insp = inspect(self)
        conditions = filter(lambda attr: getattr(insp, attr), ["transient", "pending", "persistent", "deleted", "detached"])

        preview.add_row(["", *dumped.values(), "\n".join(conditions)])

        return preview.get_string()
    
    @property
    def column_names(self) -> list[str]:
        return [column.name for column in self.__table__.columns]
    
    def dump(self) -> dict:
        return {
            key: self.__dict__[key] for key in self.__dict__ if isinstance(key, str) and not key.startswith("_")
        } 

"""
+------------------+--------------+----------------------------+----+------------+----------------------------+------------+
| UserModel(users) |  last_name   |         updated_at         | id | first_name |         created_at         | condition  |
+------------------+--------------+----------------------------+----+------------+----------------------------+------------+
|                  | asdfasdfasdf | 2024-07-29 12:46:15.428413 | 1  | aasdfasdf  | 2024-07-29 12:46:15.428410 | persistent |
+------------------+--------------+----------------------------+----+------------+----------------------------+------------+
"""
```