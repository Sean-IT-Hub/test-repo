create database if not exists InstantCover;
drop database instantcover;
use InstantCover;

drop table if exists Staff;
drop table if exists Hotel;
drop table if exists Contract;
drop table if exists WorkHours;

create table if not exists Staff (
NIN varchar(50) primary key
, eName varchar(50) );

insert into Staff (NIN, eName)
values 
('113567WD', 'John Smith'),
('234111XA', 'Diane Hocine'),
('712670YD', 'Sarah White');

create table if not exists Hotel (
hotelNo varchar(50) primary key
, hotelLocation varchar(50) 
);

insert into Hotel (hotelNo, hotelLocation)
values
('H25', 'Edinburgh'),
('H4', 'Glasgow');

create table if not exists Contract (
contractNo varchar(50) primary key
, hotelNo varchar(50) 
, foreign key (hotelNo) references Hotel(hotelNo)
);

insert into Contract (contractNo, hotelNo)
values 
('C1024', 'H25'),
('C1025', 'H4');

create table if not exists WorkHours (
NIN varchar(50) 
, contractNo varchar(50) 
, hours int 
, foreign key (NIN) references Staff (NIN)
, foreign key (contractNo) references Contract(contractNo)
);

insert into Workhours (NIN, contractNo, hours)
values 
('113567WD', 'C1024', 16),
('234111XA', 'C1024',  24),
('712670YD', 'C1025', 28),
('113567WD', 'C1025', 16);

select * from Staff;
select * from Hotel;
select * from Contract;
select * from WorkHours;

create view total_hours as 
select 
s.eName as Employee, h.total_hours 
from Staff s
inner join (
select NIN, sum(hours) as total_hours
from WorkHours
group by NIN ) h
on s.NIN = h.NIN;

drop view if exists total_hours;
select * from total_hours;

create index idx_staff_eName on Staff(eName);
show index from Staff;
drop index idx_staff_eName on Staff;

delimiter $$

create function get_hours(inputName varchar(50), inputHotel varchar(50))
returns int
deterministic
begin

declare result int;

select w.hours into result
from WorkHours w
inner join Staff s on w.NIN = s.NIN
inner join Contract c on w.contractNo = c.contractNo
inner join Hotel h on c.hotelNo = h.hotelNo
where s.eName like inputName and h.hotelLocation like inputHotel
limit 1;

return result;
end$$

delimiter ;

drop function if exists get_hours;
select get_hours('John Smith', 'Glasgow') as Hours_per_week;


delimiter $$
create trigger monitor_hotel
after insert on Hotel
for each row
begin

insert into Contract (contractNo, hotelNo)
values (concat('new-', new.hotelNo), new.hotelNo);

update WorkHours
set contractNo = concat('new-', new.hotelNo),
hours = 16
where contractNo is null
and hours = 0;

end $$
delimiter ;

drop trigger if exists monitor_hotel; 
insert into Hotel (hotelNo, hotelLocation) 
values ('H101', 'Manila');

select * from Hotel where hotelNo = 'H101';

delimiter $$

commit ;

