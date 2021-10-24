# SQL database for movie tickets

The following is an exercise in designing a SQL database for a cinema ticket
selling system. The subject seems to pop up frequently as a database management
course assignment or as a job interview question:

- [SQL Database Movie Tickets](https://stackoverflow.com/questions/30854439/sql-database-movie-tickets)
- [Theater database schema](https://stackoverflow.com/questions/13051414/theater-database-schema)
- [sql cinema reservation schema, get the proper data](https://stackoverflow.com/questions/52938427/sql-cinema-reservation-schema-get-the-proper-data)
- [MySql Movie Reservation System Design](https://stackoverflow.com/questions/17988257/mysql-movie-reservation-system-design)
- [Movie Ticket System (DB)](https://stackoverflow.com/questions/41441406/movie-ticket-system-db)
- [How to Design a Database Model for a Movie Theater Reservation System](https://vertabelo.com/blog/a-database-model-for-a-movie-theater-reservation-system/)


## Business requirements

We assume that some of the business requirements are to be enforced by the
database design (whether this is a good idea or not is another issue).

The requirements are:

- only one showing can take place in a given hall at selected time,
- tickets can only be sold for scheduled showings,
- seats are numbered and each ticket must be assigned to a seat,
- only one ticket can be sold for a given seat and showing.


## Scope

The scope of the exercise is limited to basic functionality. The solution
doesn't handle time slots, orders, cancellations, employees etc. It can be used,
however, as a basis for discussion and improvements.

Technical details like id generation strategy or partitioning of old data are
also out of scope.


## Setup

First, make sure that SQLite actually enforces foreign key constraints:

    alias sqlite3fk="sqlite3 -cmd 'PRAGMA foreign_keys = ON'"

Then create the database:

    rm -f cinema.sqlite
    sqlite3fk cinema.sqlite < cinema.sql

For demonstration purposes, we have created a very small cinema with two halls
and 7 seats total:

    sqlite3fk -header cinema.sqlite < use_cases/list_all_halls_and_seats.sql

    hall_name|seat_number
    small hall|A1
    small hall|A2
    big hall|A1
    big hall|A2
    big hall|B1
    big hall|B2
    big hall|B3


## Use cases

The queries presented here make use of subqueries in order to clarify entity
relationships. In a real application, you would probably present relevant
entries in a drop-down list and utilize entry ids instead. Also, some subqueries
can be optimized as joins, but that's left as an exercise for the reader.


### Schedule a showing

    sqlite3fk cinema.sqlite < use_cases/schedule_a_showing.sql


### Attempt to schedule another movie for the same time and place

    sqlite3fk cinema.sqlite < use_cases/schedule_another_movie_for_the_same_time_and_place.sql

This results in an error, as it should:

    Error: near line 1: UNIQUE constraint failed: schedule.hall_id, schedule.start_at


### Display seat availability for a showing

List all seats denoting availability status:

    sqlite3fk -header cinema.sqlite < use_cases/list_all_seats_for_a_showing_with_status.sql

Output shows that all the seats in the hall are available:

    seat_number|available
    A1|1
    A2|1

List only the available seats:

    sqlite3fk -header cinema.sqlite < use_cases/list_available_seats_for_a_showing.sql

Output:

    seat_number
    A1
    A2


### Sell a ticket

    sqlite3fk cinema.sqlite < use_cases/sell_valid_ticket.sql

Verify the seat availability:

    sqlite3fk -header cinema.sqlite < use_cases/list_all_seats_for_a_showing_with_status.sql

    seat_number|available
    A1|0
    A2|1

    sqlite3fk -header cinema.sqlite < use_cases/list_available_seats_for_a_showing.sql

    seat_number
    A2


### Attempt to sell another ticket for the same seat

    sqlite3fk cinema.sqlite < use_cases/sell_valid_ticket.sql

This results in an error:

    Error: near line 1: UNIQUE constraint failed: tickets_sold.hall_id, tickets_sold.start_at, tickets_sold.seat_number


### Attempt to sell a ticket for the wrong hall for a showing

Note that the hall is valid in the sense that it exists in this cinema (it has
an entry in the `halls` table), but it's the wrong hall for the selected
showing.

    sqlite3fk cinema.sqlite < use_cases/sell_ticket_for_invalid_hall.sql

This results in an error:

    Error: near line 1: FOREIGN KEY constraint failed


### Attempt to sell a ticket for the wrong seat for a showing

Again - the seat exists, but not in the hall where the showing takes place.

    sqlite3fk cinema.sqlite < use_cases/sell_ticket_for_invalid_seat.sql

This results in an error:

    Error: near line 1: FOREIGN KEY constraint failed


### Attempt to sell a ticket for the wrong time for a showing

    sqlite3fk cinema.sqlite < use_cases/sell_ticket_for_invalid_time.sql

This results in an error:

    Error: near line 1: FOREIGN KEY constraint failed


## Entity relationship diagram

![entity relationship diagram](cinema.svg?raw=true)


## Note on multiple-column foreign keys

The `tickets_sold` table contains two multiple-column foreign keys:

    FOREIGN KEY (hall_id, start_at) REFERENCES schedule(hall_id, start_at)
    FOREIGN KEY (hall_id, seat_number) REFERENCES seats(hall_id, seat_number)

At first glance, this may seem a little strange. Why don't we simply add
surrogate primary keys to the `schedule` and `seats` tables, so that we can
refer to them like this:

    FOREIGN KEY (schedule_id) REFERENCES schedule(id)
    FOREIGN KEY (seat_id) REFERENCES seats(id)

?

The reason is that we wouldn't be able to guarantee data consistency between
seats and showings. Nothing would stop us from adding an entry to the
`tickets_sold` table that looked like this:

- `tickets_sold.schedule_id` refers to a showing that takes place in one hall,
- `tickets_sold.seat_id` refers to a seat in another hall.


## SQL vendor compatibility

The queries were developed using SQLite, but they are also MySQL compatible. You
could do something like:

    alias mysql="mysql -u user -ppassword"

and then replace `sqlite3fk cinema.sqlite` with `mysql cinema`. All the use
cases should work as expected.
