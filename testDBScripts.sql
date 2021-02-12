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













