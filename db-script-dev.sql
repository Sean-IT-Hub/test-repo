-- 1. drop ko si user ya kung meron, gawa tayo bagong user hakhakahakhak
drop user if exists rcis;

create user if not exists 'rcis'@'localhost'
identified by '1234';

-- 2. grant na naten nakita ko to kay sir kanina hakhakhak
grant create on rcis.*
to 'rcis'@'localhost';

-- para san to ya hhaahah 
flush privileges;

grant select, insert, update on rcis.*
    to 'rcis'@'localhost';

flush privileges;

-- 3. tapos dito create tsaka use 
create database if not exists rcis;

use rcis;

-- 4. dito drop gago sunod sunod to ah
drop table if exists prescription;
drop table if exists visit;
drop table if exists medication;
drop table if exists staff;
drop table if exists patient;

-- 5. dito create table
create table if not exists patient (
patient_id int auto_increment primary key
, first_name varchar(50) not null
, last_name varchar(50) not null
, date_of_birth date not null
, student_id varchar(20) not null unique
, grade int check(grade between 1 and 12)
, email varchar(100) unique
, emergency_phone varchar(20) not null
);

create table if not exists staff (
staff_id int auto_increment primary key
, first_name varchar(50) not null
, last_name varchar(50) not null
, role varchar(30) not null
, license_number varchar(30) unique
, phone varchar(20) not null
, email varchar(100) not null unique
, hire_date date not null
);

create table if not exists visit (
visit_id int auto_increment primary key
, patient_id int not null
, staff_id int not null
, visit_date datetime not null default current_timestamp
, reason text not null
, diagnosis text
, follow_up_needed tinyint(1) default 0
, height_cm decimal(5,2)
, weight_kg decimal(5,2)

, foreign key (patient_id) references patient(patient_id)
, foreign key (staff_id) references staff(staff_id)
);

create table if not exists medication (
medication_id int auto_increment primary key
, medication_name varchar(100) not null unique
, description text
, unit varchar(20) not null
, stock_quantity int not null default 0 check (stock_quantity >= 0)
, reorder_level int not null default 10
);

create table if not exists prescription (
prescription_id int auto_increment primary key
, visit_id int not null
, medication_id int not null
, dosage varchar(50) not null
, frequency varchar(50) not null
, duration_days int not null check (duration_days > 0)
, instruction text

, foreign key (visit_id) references visit(visit_id)
, foreign key (medication_id) references medication(medication_id)
);

-- 6. dito alter pag meron
-- alter table 

-- 7. Ito na ya insert na 

insert into patient (first_name, last_name, date_of_birth, student_id, grade, email, emergency_phone)
values
    ('Juan', 'Dela Cruz', '1995-03-14', 'CT22-0001', '9', 'juandlacruz@gmail.com', '09171234567'),
    ('Maria', 'Santos', '1988-07-22', 'CT22-0002', '10', 'mariasantos@gmail.com', '09182345678'),
    ('Pedro', 'Reyes', '2001-11-05', 'CT22-0003', '11', 'perdoreyes@gmail.com', '09193456789');

insert into staff (first_name, last_name, role, license_number, phone, email, hire_date)
values
    ('Mark', 'Villanueva', 'Doctor',  'OOO1-001', '09209876543', 'mark.villanueva@clinic.com', '2019-03-15'),
    ('Grace', 'Tan',       'Nurse',  '0102002-006' ,'09205551234', 'grace.tan@clinic.com',       '2022-01-10');

insert into medication (medication_name, description, unit, stock_quantity, reorder_level)
values
    ('Ibuprofen',   'Pain reliever', 'tablet',  150, 20),
    ('Amoxicillin', 'Antibiotic',                        'capsule', 100, 30),
    ('Cetirizine',  'Antihistamine for allergies',       'tablet',  80,  15),
    ('Paracetamol', 'Pain reliever',     'tablet',  200, 25);

insert into visit (patient_id, staff_id, visit_date, reason, diagnosis, follow_up_needed, height_cm, weight_kg)
values
    (1, 1, '2026-07-05 09:00:00', 'Fever and cough',        'Common cold',       0, 150.50, 45.20),
    (2, 1, '2026-07-10 10:30:00', 'Sore throat',             'Sore throat',       1, 155.00, 50.00),
    (3, 2, '2026-07-15 08:45:00', 'Minor cut on hand',       'Superficial wound', 0, 160.20, 55.30),
    (1, 1, '2026-08-02 11:00:00', 'Follow-up checkup',       'Recovering well',   0, 150.80, 45.50),
    (3, 2, '2026-08-08 09:15:00', 'Headache',                'Tension headache',  0, 148.00, 40.00);

insert into prescription (visit_id, medication_id, dosage, frequency, duration_days, instruction)
values
    (1, 3, '500mg', 'Every 6 hours', 3, 'Take after meals'),
    (2, 2, '500mg', 'Every 8 hours', 7, 'Complete full course'),
    (3, 1, '500mg', 'Every 6 hours', 3, 'For fever/pain'),
    (4, 4, '200mg', 'Every 8 hours', 2, 'Take with food'),
    (5, 3, '10mg',  'Once a day',    5, 'Take at night');
 

-- 8. tapos commit na pre, wala na commit na di na papakawalan yan
commit;

