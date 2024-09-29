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
