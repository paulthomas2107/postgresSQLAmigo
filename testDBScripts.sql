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
