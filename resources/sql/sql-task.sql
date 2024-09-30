-- Task1
select  aircraft_code ac, fare_conditions fc, count(seat_no)
from aircrafts_data ad
left join seats s  using (aircraft_code)
group by ac, fc
order by ac
--Task2
select  aircraft_code ac, count(seat_no) c
from aircrafts_data ad
left join seats s  using (aircraft_code)
group by ac
order by c desc
limit 3
--Task3
select  flight_id
from flights f
where actual_arrival is not null and extract(epoch from (actual_arrival - scheduled_arrival)) / 3600  > 2 
--Task4
select ticket_no, passenger_name, contact_data
from tickets t 
inner join bookings b using(book_ref)
where ticket_no in (select ticket_no
from ticket_flights tf 
where fare_conditions = 'Business')
order by book_date desc 
limit 10
--Task5
select f.flight_id 
from flights f
left join ticket_flights tf on f.flight_id = tf.flight_id and tf.fare_conditions = 'Business'
group by f.flight_id
having count(tf.ticket_no) = 0
--Task6
select airport_name ->> 'en' airport_name, city ->> 'en' city
from airports_data ad 
inner join flights f on airport_code = f.departure_airport 
where f.actual_departure is not null 
group by airport_code 
--Task7
select airport_name ->> 'en' airport_name, count(f.flight_id) 
from airports_data ad 
inner join flights f on airport_code = f.departure_airport 
group by airport_code
--Task8
select flight_id
from flights f 
where actual_arrival is not null and extract(epoch from (actual_arrival - scheduled_arrival)) > 0
--Task9
select ad.aircraft_code, ad.model ->> 'ru' model, s.seat_no 
from seats s
inner join aircrafts_data ad using (aircraft_code)
where  s.fare_conditions = 'Economy' and ad.model ->> 'ru' = 'Аэробус A321-200'
order by s.seat_no
--Task10
select ad.airport_code, ad.airport_name ->> 'en' as airport, ad.city ->> 'en' as city
from airports_data ad
where ad.city ->> 'en' in (select city ->> 'en' as city
from airports_data ad 
group by (ad.city ->> 'en')
having count(airport_code) > 1)
--Task11
select t.passenger_id, b.total_amount
from tickets t 
left join bookings b using(book_ref)
inner join (select book_ref, count (passenger_id) numbers
from tickets t 
left join bookings b using(book_ref)
group by book_ref) as qi on t.book_ref = qi.book_ref
where b.total_amount > (select avg(total_amount) from bookings b)
--Task12
select f.flight_id , adfrom.airport_name, adto.airport_name 
from flights f 
inner join airports_data adfrom on f.departure_airport =adfrom.airport_code 
inner join airports_data adto on f.arrival_airport =adto.airport_code 
where f.status = 'On Time' 
and adfrom.city ->> 'ru' = 'Екатеринбург'
and adto.city ->> 'ru' = 'Москва'
--Task13
(select tick, costs
from (select t.ticket_no as tick, b.total_amount / bttemp.counts as costs
from tickets t 
inner join bookings b using(book_ref) 
inner join (select book_ref, count(ticket_no) as counts
from tickets tb 
group by book_ref ) as bttemp using(book_ref)
order by costs
) as minmaxtable
limit 1)
union all 
(select tick, costs
from (select t.ticket_no as tick, b.total_amount / bttemp.counts as costs
from tickets t 
inner join bookings b using(book_ref) 
inner join (select book_ref, count(ticket_no) as counts
from tickets tb 
group by book_ref ) as bttemp using(book_ref)
order by costs desc 
) as minmaxtable
limit 1)
--Task14
create table public.customers(
customer_id bigserial PRIMARY KEY,
firstname varchar  not null,
lastname varchar  not null,
email varchar  unique, 
phone varchar  unique not null
)
--Task15
create table public.orders(
order_id bigserial primary key ,
customer_id bigint references public.customers (customer_id),
product_name varchar  not null,
price decimal(100,2)  not null,
quantity int  not null, 
sum  decimal(100,2) not null
)
--Task16
insert into public.customers 
(firstname, lastname, email, phone)
values ('Сидр', 'Сидоров', 'wqer@mail.ru', '+375291285697'), ('Петр', 'Петров', 'Petrovich@yandex.ru', '375291597536'),
('Иван', 'Иванович', 'jan@yandex.ru', '375448527411'), ('Гена', 'Генадьев', 'gen@mail.ru', '375297896541'),
('Ольга', 'Петровна', 'Olja@gmail.ru', '375335648532');
insert into public.orders 
(customer_id, product_name, price, quantity, sum) 
values (1, 'iphone16', 1000, 1, 1000), (2, 'macbook', 3000, 2, 6000),
(3, 'vacuumrobot', 500, 3, 1500), (4, 'yandexstation', 500, 2, 1000),
(5, 'kettle', 50, 10, 500)
--Task17
drop table orders, customers;