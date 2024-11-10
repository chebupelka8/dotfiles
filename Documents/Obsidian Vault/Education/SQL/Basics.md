Practise: https://sql-academy.org/ru
```sql
-- creating tables
create table users(
	id bigint primary key,
	first_name varchar(64) not null,
	last_name varchar(64),
	created_at timestamp default now()
);
```

```sql
-- foreign key and autoincrement
create table spendings(
	id serial primary key,  -- будет автоматически вставляться начиная с 1
	price int not null,
	time_at timestamp default now(),
	user_id bigint,

	foreign key (user_id) references users(id) 
	-- либо можно использовать constraint чтобы задать имя
	-- если этого не сделать то имя будет по умолчание зависит от субд
	-- в postgres в даном примере будет users_user_id_fkey
	constaint user_id_fk forign key (user_id) refernces users(id)
);
```

```sql
-- select, where
select * from users;  -- выбирает все из таблицы users
select id from users;

select id, first_name, last_name from users
where id = 1;  -- выбирает id, first_name, last_name где id равен 1

select *.users from users
where id = 77 and first_name = 'step'

select users.first_name from users
where id > 10 or first_name = 'step'
```

```sql
-- insert, update, delete

insert into users(id, first_name, last_name) -- id можно не указывать если вы используете serial
values (1, 'step', 'zamytin');

update users
set email = "step@gmail.com"
where id = 1

update users
set email = "unknown@gmail.com", first_name = "xxxx" -- можно задавать несколь значений
where id = 1

delete users
where id = 1
```

```sql
-- JOINs
select *.spendings, users.first_name, users.last_name from spendings
join users on users.id = spendings.user_id and users.id = 1

+----+-------+---------+---------+------------+-----------+
| id | price | time_at | user_id | first_name | last_name |
+----+-------+---------+---------+------------+-----------+
| 1  | 10501 | 05.11.24|     1   |    'step'  | 'zamytin' |
+----+-------+---------+---------+------------+-----------+

```
![[Joins-2167278146.png]]