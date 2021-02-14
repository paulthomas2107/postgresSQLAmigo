CREATE TABLE person (
    id int,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(6),
    data_of_birth DATE);

CREATE TABLE person (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    email VARCHAR(150),
    data_of_birth DATE NOT NULL);

INSERT INTO person (
    first_name,
    last_name,
    gender,
    data_of_birth)
    VALUES ('Paul', 'Thomas', 'MALE', DATE '1966-07-21');
)

INSERT INTO person (
    first_name,
    last_name,
    gender,
    email,
    data_of_birth)
    VALUES ('Janice', 'Jones', 'FEMALE', 'jj@ibm.com', DATE '1950-12-25');
)

INSERT INTO person (
    first_name,
    last_name,
    gender,
    email,
    data_of_birth)
    VALUES ('Anne', 'Smith', 'FEMALE', 'anne@anne.com', DATE '1988-01-01');
)

INSERT INTO person (
    first_name,
    last_name,
    gender,
    email,
    data_of_birth)
    VALUES ('Jake', 'Jones', 'Male', 'jake@anne.com', DATE '1990-12-31');
)



select 
country_of_birth, 
gender, 
count(*) 
from person 
group by country_of_birth, gender  
order by 1,2;

// SQL
select distinct(country_of_birth) from person order by 1;
select * from person where date_of_birth > '1990-01-01';
select * from person where gender = 'Male' and country_of_birth = 'China' and date_of_birth > '1969-12-31';

select 1 < 1; 
select 2 > 1; 
select 3 >= 2;
select 2 <> 2;

// Limit
select * from person LIMIT 10;
select * from person where gender = 'Female' OFFSET 20 LIMIT 10;
select * from person where gender = 'Female' FETCH FIRST 5 ROWS ONLY;
select * from person where gender = 'Female' FETCH FIRST 1 ROWS ONLY;
select * from person where gender = 'Female' FETCH FIRST ROWS ONLY; // 1 ROWS

// "IN"
select * from person where country_of_birth IN ('China', 'France');
select * from person where country_of_birth IN ('China', 'France') AND gender NOT IN ('Male', 'Female');

// Between
select * from person where date_of_birth BETWEEN '1969-01-01' and '1980-01-01' order by date_of_birth ASC;
select * from person where date_of_birth BETWEEN '1969-01-01' and '1980-01-01' order by date_of_birth DESC;

// Like / NOT Like / ILIKE
select * from person where email like '%.com';
select * from person where email like 'p%.com';
select * from person where email not like 'p%' order by email;
select * from person where email like '_______@%' order by email;
select * from person where email like '___@%' order by email;
select * from person where country_of_birth ILIKE 'g%'; // ignores case with ILIKE

// Group by / Group by having
select distinct(country_of_birth), count(*) from person group by country_of_birth;
select distinct(country_of_birth), count(*) from person group by country_of_birth having (count(*) > 50); 

// Min MAX Average etc with ROUND
select MAX(price) from car;
select AVG(price) from car;
select MIN(price) from car;
select MAX(price), MIN(price), ROUND(AVG(price)) from car;
select make, model, MIN(price) from car group by make, model;
select make, MIN(price) from car  group by make order by MIN(price) DESC;

// --SUM--
select sum(price) from car;
select make, SUM(price) from car  group by make order by SUM(price) DESC LIMIT 10;

// Arithmetic and other maths ROUND etc
select 10 + 2;
select 10 * 2;
select 10 / 2;
select 10 % 3;
select make, model, price, ROUND(price * .10, 2) as Discount,  price - ROUND(price * .10, 2) as Final_Price from car limit 10;
select make, model, price, 10.00 as Percentage_Disc, ROUND(price * .10, 2) as Discount,  price - ROUND(price * .10, 2) as Final_Price from car limit 10;

// Nulls / nullifs
select id, first_name, last_name, gender, coalesce(email, '<NO EMAIL>') from person;
select coalesce(10 / nullif(0,0), 0);

// Timestamps and Dates
select now(); ==> current date and Time
select now()::date; ==> cast to date
select now()::time; ==> cast to time
select now() - interval '1 year';
select now() + interval '1 year';
select now() + interval '10 months';
select now()::date + interval '10 months';
select extract(year from now());
select extract(month from now());
select extract(dow from now());
select extract(century from now());
select first_name, last_name, date_of_birth, age(now(), date_of_birth) from person;

// Primary Keys
delete from person where id = 120;
ALTER TABLE person DROP CONSTRAINT person_pkey;
ALTER TABLE person ADD PRIMARY KEY(id);

// UNIQUE constraints;
alter table person add constraint unique_email UNIQUE (email);

// Check constrtaint
alter table person add constraint gender_constraint check (gender != 'Animal' or gender != 'SpaceAlien') ;

// Populate gender table    
CREATE TABLE gender (
    id BIGSERIAL NOT NULL,
    gender_code VARCHAR(50) NOT NULL PRIMARY KEY,
    gender_desc VARCHAR(50) NOT NULL,
    update_timestamp  TIMESTAMP NOT NULL);

insert into gender(gender_code, gender_desc, update_timestamp) values ('UKNOWN', 'Unknown Gender', now());
update gender set gender_code = 'UNKNOWN' where id = 13;

select distinct(substring(gender,1,4)), gender, now() from person;

insert into gender(gender_code, gender_desc, update_timestamp) select distinct(substring(gender,1,8)), gender, now() from person;

ALTER TABLE person ADD COLUMN gender_id integer;

update person set gender_id = (select id from gender where person.gender = gender_desc);

ALTER TABLE person DROP COLUMN gender_code CASCADE;
ALTER TABLE person DROP COLUMN gender CASCADE;


// Populate Country Table
CREATE TABLE country (
    id BIGSERIAL NOT NULL,
    country_code VARCHAR(50) NOT NULL PRIMARY KEY,
    country_desc VARCHAR(50) NOT NULL,
    update_timestamp  TIMESTAMP NOT NULL);


insert into country (country_code, country_desc, update_timestamp) select distinct(substring(country_of_birth,1,8)), country_of_birth, now() from person;
ALTER TABLE person ADD COLUMN country_id integer;
update person set country_id = (select id from country where person.country_of_birth = country_desc);
ALTER TABLE person DROP COLUMN country_of_birth CASCADE;

// Delete records
delete from person where country_id = 1234;
delete from person; ==> deletes all !!!

// Update records
update person set last_name = '<BLANKED>', first_name = '****' where last_name = 'whatever';

// Duplicate key and other errors
// try insert same id => ignore with on conflict
insert into person (id, first_name, last_name, email, date_of_birth, gender_id, country_id)
values (38, 'x', 'y', 'z', date '2011-11-11', 1, 2) ON CONFLICT(id) DO NOTHING;
insert into person (id, first_name, last_name, email, date_of_birth, gender_id, country_id)
values (38, 'x', 'y', 'z', date '2011-11-11', 1, 2) ON CONFLICT(email) DO NOTHING;

// UPSERT -- update may fail but upsert OK
insert into person (id, first_name, last_name, email, date_of_birth, gender_id, country_id)
values (38, 'x', 'y', 'z', date '2011-11-11', 1, 2) ON CONFLICT(id) DO UPDATE set EXCLUDED.email    ;

// -- Foreign keys / joins etc
// Person can have just 1 car
ALTER TABLE person DROP COLUMN car_id CASCADE;
ALTER TABLE person ADD COLUMN car_id integer NOT NULL;
ALTER TABLE person DROP CONSTRAINT fk_car_id;
ALTER TABLE person ADD CONSTRAINT fk_car_id FOREIGN KEY(car_id) REFERENCES car(id);
ALTER TABLE person ADD CONSTRAINT unique_car UNIQUE (car_id);

// Updating FK values
update person set car_id = 2 where id = 39;
update person set car_id = 1 where id = 38;
==> 
id | first_name | last_name |              email               | date_of_birth | gender_id | country_id | car_id
----+------------+-----------+----------------------------------+---------------+-----------+------------+--------
 38 | Clemens    | Poytress  |                                  | 1932-07-02    |        12 |        104 |      1
 39 | Alice      | Bacher    | abacher12@nationalgeographic.com | 1936-04-28    |        12 |         19 |      2

// -- Inner joins
select 
first_name, last_name, p.car_id, c.make, c.model
from person p, car c
where p.car_id is not null
and
p.car_id = c.id;

select 
first_name, last_name, p.car_id, c.make, c.model
from person p join car c on c.id = p.car_id
where p.car_id is not null;

// -- left joins includes Table A and Table B if no matches
select * from person LEFT JOIN car on car.id = person.car_id limit 20;

id | first_name | last_name  |              email               | date_of_birth | gender_id | country_id | car_id | id |    make    |  model  |  price
----+------------+------------+----------------------------------+---------------+-----------+------------+--------+----+------------+---------+----------
 38 | Clemens    | Poytress   |                                  | 1932-07-02    |        12 |        104 |      1 |  1 | Kia        | Sorento | 54702.20
 39 | Alice      | Bacher     | abacher12@nationalgeographic.com | 1936-04-28    |        12 |         19 |      2 |  2 | Volkswagen | Eurovan | 16589.70
 40 | Aloise     | Goodenough | agoodenough13@histats.com        | 1992-02-03    |         6 |         13 |        |    |            |         |
 41 | Arvie      | Grealish   | agrealish14@merriam-webster.com  | 1998-06-13    |         8 |        123 |        |    |            |         |

// -- Export to CSV
select * from person LEFT JOIN car on car.id = person.car_id limit 20;
\copy (select * from person left join car on car.id = person.car_id limit 20) TO '/Users/paulthomas/SQLDump/CarDumo.csv' DELIMITER ',' CSV HEADER;
==>
id,first_name,last_name,email,date_of_birth,gender_id,country_id,car_id,id,make,model,price
38,Clemens,Poytress,,1932-07-02,12,104,1,1,Kia,Sorento,54702.20
39,Alice,Bacher,abacher12@nationalgeographic.com,1936-04-28,12,19,2,2,Volkswagen,Eurovan,16589.70
40,Aloise,Goodenough,agoodenough13@histats.com,1992-02-03,6,13,,,,,
41,Arvie,Grealish,agrealish14@merriam-webster.com,1998-06-13,8,123,,,,,
42,Sydney,Vallery,,1992-04-13,11,106,,,,,
43,Ibrahim,Juarez,ijuarez16@squidoo.com,1997-12-31,12,123,,,,,

// -- Serials and Sequences reset too
BIGSERIAL - autoincrements actually is BIGINT

select * from person_id_seq;
==>
 last_value | log_cnt | is_called
------------+---------+-----------
       1000 |      23 | t

select nextval('person_id_seq'::regclass);
==>
 nextval
---------
    1001

ALTER SEQUENCE car_id_seq RESTART WITH 2000;
==>
 last_value | log_cnt | is_called
------------+---------+-----------
       2000 |      32 | t

// -- Extensions
select * from pg_<TAB> -==> shows all list of commands

 select * from pg_available_extensions;
 ==> 
           name          | default_version | installed_version |                                comment
------------------------+-----------------+-------------------+------------------------------------------------------------------------
 refint                 | 1.0             |                   | functions for implementing referential integrity (obsolete)
 postgis                | 3.1.1           |                   | PostGIS geometry and geography spatial types and functions
 unaccent               | 1.1             |                   | text search dictionary that removes accents
 btree_gin              | 1.3             |                   | support for indexing common datatypes in GIN
 plpython3u             | 1.0             |                   | PL/Python3U untrusted procedural language
 ltree                  | 1.2             |                   | data type for hierarchical tree-like structures
..etc etc

// - USING UUID Extensions
Guaranteed unique globally :)

Install UUID module in PLSQL:
CREATE EXTENSION IF NOT EXISTS 'uuid-ossp';
\df ==>
                                 List of functions
 Schema |        Name        | Result data type |    Argument data types    | Type
--------+--------------------+------------------+---------------------------+------
 public | uuid_generate_v1   | uuid             |                           | func
 public | uuid_generate_v1mc | uuid             |                           | func
 public | uuid_generate_v3   | uuid             | namespace uuid, name text | func
 public | uuid_generate_v4   | uuid             |                           | func
 public | uuid_generate_v5   | uuid             | namespace uuid, name text | func
 public | uuid_nil           | uuid             |                           | func
 public | uuid_ns_dns        | uuid             |                           | func
 public | uuid_ns_oid        | uuid             |                           | func
 public | uuid_ns_url        | uuid             |                           | func
 public | uuid_ns_x500       | uuid             |                           | func

select uuid_generate_v4();
           uuid_generate_v4
--------------------------------------
 d23e5ca4-3bff-4cc4-a918-4414636704ad

As PRIMARY Keys
================
// Populate Drink Table
CREATE TABLE drink (
    id uuid NOT NULL PRIMARY KEY,
    drink_code VARCHAR(50) NOT NULL,
    drink_desc VARCHAR(50) NOT NULL,
    update_timestamp  TIMESTAMP NOT NULL);

ALTER TABLE drink ADD CONSTRAINT unique_drink_code UNIQUE (drink_code);

insert into drink(id, drink_code, drink_desc, update_timestamp) values (uuid_generate_v4(),'Water', 'Fresh Water', now());

ALTER TABLE person ADD COLUMN drink_id uuid;
ALTER TABLE person ADD CONSTRAINT fk_drink_id FOREIGN KEY(drink_id) REFERENCES drink(id);
ALTER TABLE person ADD CONSTRAINT unique_drink UNIQUE (drink_id);

select person.id, first_name, last_name, drink_id from person join drink on person.drink_id = drink.id limit 10;


select person.id, first_name, last_name, drink_id, drink.* from person join drink on person.drink_id = drink.id limit 10;
==>
  id | first_name | last_name |                  id                  | drink_code | drink_desc  |      update_timestamp
----+------------+-----------+--------------------------------------+------------+-------------+----------------------------
 41 | Arvie      | Grealish  | 05e666c2-ffb5-484c-8f43-55ac52ef4c14 | Water      | Fresh Water | 2021-02-14 17:28:32.116276