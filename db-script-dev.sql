-- 1. drop ko si user ya kung meron, gawa tayo bagong user hakhakahakhak
drop user if exists rcis;

create user if not exists 'rcis'@'localhost'
identified by '1234';

-- 2. grant na naten nakita ko to kay sir kanina hakhakhak
grant create on rcis.*
to 'rcis'@'localhost';

-- para san to ya hhaahah 
flush privileges;

grant select, insert, update, delete on rcis.*
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
-- alter table patient

-- =====================================================================
-- 7. PART 2: DATA MANIPULATION LANGUAGE (DML)
-- =====================================================================

-- ---------------------------------------------------------------
-- 7a. INSERT DATA
--     (may dagdag na 1 medication at 1 staff na walang
--     prescription/visit -- gagamitin sa Delete Data section)
-- ---------------------------------------------------------------

insert into patient (first_name, last_name, date_of_birth, student_id, grade, email, emergency_phone)
values
    ('Juan', 'Dela Cruz', '1995-03-14', 'CT22-0001', '9', 'juandlacruz@gmail.com', '09171234567'),
    ('Maria', 'Santos', '1988-07-22', 'CT22-0002', '10', 'mariasantos@gmail.com', '09182345678'),
    ('Pedro', 'Reyes', '2001-11-05', 'CT22-0003', '11', 'perdoreyes@gmail.com', '09193456789');

insert into staff (first_name, last_name, role, license_number, phone, email, hire_date)
values
    ('Mark', 'Villanueva', 'Doctor', 'OOO1-001',    '09209876543', 'mark.villanueva@clinic.com', '2019-03-15'),
    ('Grace', 'Tan',       'Nurse',  '0102002-006', '09205551234', 'grace.tan@clinic.com',       '2022-01-10'),
    ('Ana', 'Lopez',       'Nurse',  '0103003-007', '09201112222', 'ana.lopez@clinic.com',       '2023-06-01');
    -- ^ Ana Lopez: walang visit na naka-assign, gagamitin sa "safe delete" task

insert into medication (medication_name, description, unit, stock_quantity, reorder_level)
values
    ('Ibuprofen',   'Pain reliever',               'tablet',  150, 20),
    ('Amoxicillin', 'Antibiotic',                  'capsule', 100, 30),
    ('Cetirizine',  'Antihistamine for allergies', 'tablet',  80,  15),
    ('Paracetamol', 'Pain reliever',                'tablet',  200, 25),
    ('Loperamide',  'Anti-diarrheal',               'tablet',  40,  10);
    -- ^ Loperamide: hindi pa naprescribe kailanman, gagamitin sa "delete unused medication" task

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
    (3, 1, '500mg', 'Every 6 hours', 3, 'For fever'),
    (4, 4, '200mg', 'Every 8 hours', 2, 'Take with food'),
    (5, 3, '10mg',  'Once a day',    5, 'Take at night');

select * from patient;
select * from staff;
select * from visit;
select * from medication;
select * from prescription;


-- ---------------------------------------------------------------
-- 7b. UPDATE DATA
-- ---------------------------------------------------------------

-- Q6. Change the grade of a specific patient (Maria Santos: 10 -> 11)
update patient
set grade = 11
where student_id = 'CT22-0002';

-- Q7. Increase the stock_quantity of a medication by 50 (Amoxicillin)
update medication
set stock_quantity = stock_quantity + 50
where medication_name = 'Amoxicillin';

-- Q8. Update the diagnosis of a visit ('Sore throat' -> 'Streptococcal pharyngitis')
update visit
set diagnosis = 'Streptococcal pharyngitis'
where diagnosis = 'Sore throat';


-- ---------------------------------------------------------------
-- 7c. DELETE DATA
-- ---------------------------------------------------------------

-- Q9. Delete a medication that has never been prescribed (Loperamide)
delete from medication
where medication_name = 'Loperamide';

-- Q10a. Attempt to delete a staff member who HAS existing visits --
--       this will FAIL due to the foreign key constraint on visit.staff_id
--       (uncomment lang para makita mo yung error)
-- delete from staff where staff_id = 1;

-- Q10b. Safely delete a staff member with NO visits (Ana Lopez)
delete from staff
where staff_id = (
    select staff_id from (
        select s.staff_id
        from staff s
        left join visit v on s.staff_id = v.staff_id
        where v.visit_id is null
        limit 1
    ) as no_visit_staff
);

select * from patient;
select * from staff;
select * from medication;


-- 8. tapos commit na pre, wala na commit na di na papakawalan yan
commit;


-- =====================================================================
-- 9. PART 3: DATA QUERY LANGUAGE (DQL) -- yung 10 questions
--     sa SQL_ACTIVITY.pdf
-- =====================================================================

-- Q1. List all patients (full name, grade, emergency phone)
--     sorted by grade descending, then by last name ascending
select
    concat(first_name, ' ', last_name) as full_name,
    grade,
    emergency_phone
from patient
order by grade desc, last_name asc;


-- Q2. Show all visits that occurred in the last 30 days,
--     with patient name, staff name, and the reason for the visit
select
    concat(p.first_name, ' ', p.last_name) as patient_name,
    concat(s.first_name, ' ', s.last_name) as staff_name,
    v.reason,
    v.visit_date
from visit v
inner join patient p on v.patient_id = p.patient_id
inner join staff s on v.staff_id = s.staff_id
where v.visit_date >= curdate() - interval 30 day;


-- Q3. Count how many visits each patient has had, showing patient
--     full name and visit count, only for patients with at least 2 visits
select
    concat(p.first_name, ' ', p.last_name) as patient_name,
    count(v.visit_id) as visit_count
from patient p
inner join visit v on p.patient_id = v.patient_id
group by p.patient_id, patient_name
having count(v.visit_id) >= 2;


-- Q4. Find the most prescribed medication -- display the medication
--     name and total number of times it has been prescribed
select
    m.medication_name,
    count(pr.prescription_id) as times_prescribed
from medication m
inner join prescription pr on m.medication_id = pr.medication_id
group by m.medication_id, m.medication_name
order by times_prescribed desc
limit 1;


-- Q5. List all prescriptions for a specific patient (patient_id = 1,
--     Juan Dela Cruz), showing visit date, medication name, dosage,
--     frequency, and duration
select
    v.visit_date,
    m.medication_name,
    pr.dosage,
    pr.frequency,
    pr.duration_days
from prescription pr
inner join visit v on pr.visit_id = v.visit_id
inner join medication m on pr.medication_id = m.medication_id
where v.patient_id = 1;


-- Q6. Show the average height and weight of patients who visited
--     the clinic in the month of September 2026
--     (note: kung walang September data pa sa visit table mo,
--     NULL ang ibabalik nito -- expected na, matic na mapo-populate
--     kapag may September visits na naitala)
select
    avg(height_cm) as avg_height_cm,
    avg(weight_kg) as avg_weight_kg
from visit
where year(visit_date) = 2026
  and month(visit_date) = 9;


-- Q7. Identify medications with stock below the reorder level --
--     display medication name, current stock, and reorder level
select
    medication_name,
    stock_quantity,
    reorder_level
from medication
where stock_quantity < reorder_level;


-- Q8. Find the busiest staff member (the one who handled the most
--     visits) -- show name and visit count
select
    concat(s.first_name, ' ', s.last_name) as staff_name,
    count(v.visit_id) as visit_count
from staff s
inner join visit v on s.staff_id = v.staff_id
group by s.staff_id, staff_name
order by visit_count desc
limit 1;


-- Q9. Retrieve all patients who have never had a follow-up visit
--     (i.e., no visit with follow_up_needed = 1) -- gamit ng NOT EXISTS
select
    concat(p.first_name, ' ', p.last_name) as patient_name
from patient p
where not exists (
    select 1
    from visit v
    where v.patient_id = p.patient_id
      and v.follow_up_needed = 1
);


-- Q10. Generate a monthly visit report -- show the year-month
--      (e.g. '2026-07') and total number of visits for each month,
--      sorted chronologically
select
    date_format(visit_date, '%Y-%m') as year_month,
    count(*) as total_visits
from visit
group by year_month
order by year_month;


-- =====================================================================
-- 10. INTERMEDIATE SQL SECTION (Joins) -- dagdag na hindi bahagi
--     ng SQL_ACTIVITY.pdf, pero pwede i-run pagkatapos ng lahat
-- =====================================================================

-- INNER JOIN: lahat ng visit kasama ang buong pangalan ng patient at staff
select
    v.visit_id,
    concat(p.first_name, ' ', p.last_name) as patient_name,
    concat(s.first_name, ' ', s.last_name) as staff_name,
    v.visit_date,
    v.reason
from visit v
inner join patient p on v.patient_id = p.patient_id
inner join staff s on v.staff_id = s.staff_id;

-- LEFT JOIN: LAHAT ng patients, kahit wala pang visit (NULL kung wala)
select
    p.patient_id,
    concat(p.first_name, ' ', p.last_name) as patient_name,
    v.visit_id,
    v.visit_date
from patient p
left join visit v on p.patient_id = v.patient_id;

-- RIGHT JOIN: LAHAT ng staff, kahit walang na-handle na visit (NULL kung wala)
select
    s.staff_id,
    concat(s.first_name, ' ', s.last_name) as staff_name,
    v.visit_id,
    v.visit_date
from visit v
right join staff s on v.staff_id = s.staff_id;

-- NATURAL JOIN: awtomatikong nag-jo-join base sa parehong column name
-- (patient at visit ay pareho may "patient_id" column, kaya awtomatikong
-- ginamit ito bilang batayan ng pag-join -- walang kailangang ON clause)
select
    patient_id,
    first_name,
    last_name,
    visit_id,
    visit_date
from patient
natural join visit;

-- CROSS JOIN: bawat row ng medication ay ikinukumbina sa BAWAT row ng staff
-- (walang ON clause -- Cartesian product; ginagamit lang para makita
-- halimbawa ng lahat ng posibleng kombinasyon, hindi ito kadalasang
-- gamit sa totoong report)
select
    m.medication_name,
    concat(s.first_name, ' ', s.last_name) as staff_name
from medication m
cross join staff s;

-- INNER JOIN (3 tables): prescription details kasama medication name
select
    pr.prescription_id,
    v.visit_id,
    m.medication_name,
    pr.dosage,
    pr.frequency
from prescription pr
inner join visit v on pr.visit_id = v.visit_id
inner join medication m on pr.medication_id = m.medication_id;
