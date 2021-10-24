DROP TABLE IF EXISTS tickets_sold;

DROP TABLE IF EXISTS schedule;

DROP TABLE IF EXISTS seats;

DROP TABLE IF EXISTS halls;

DROP TABLE IF EXISTS movies;


CREATE TABLE movies (
	title VARCHAR(200) NOT NULL,
	id INT NOT NULL,
	PRIMARY KEY (id)
);

CREATE INDEX movies_title ON movies(title);

CREATE TABLE halls (
	name VARCHAR(100) NOT NULL,
	id INT NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE seats (
	hall_id INT NOT NULL,
	seat_number VARCHAR(5) NOT NULL,
	FOREIGN KEY (hall_id)
		REFERENCES halls(id)
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRIMARY KEY (hall_id, seat_number)
);

CREATE TABLE schedule (
	movie_id INT NOT NULL,
	hall_id INT NOT NULL,
	start_at DATETIME NOT NULL,
	FOREIGN KEY (movie_id)
		REFERENCES movies(id)
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (hall_id)
		REFERENCES halls(id)
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRIMARY KEY (hall_id, start_at)
);

CREATE TABLE tickets_sold (
	hall_id INT NOT NULL,
	start_at DATETIME NOT NULL,
	seat_number VARCHAR(5) NOT NULL,
	FOREIGN KEY (hall_id, start_at)
		REFERENCES schedule(hall_id, start_at)
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (hall_id, seat_number)
		REFERENCES seats(hall_id, seat_number)
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRIMARY KEY (hall_id, start_at, seat_number)
);


INSERT INTO movies (title, id) VALUES ("The Vindicators 5", 555);
INSERT INTO movies (title, id) VALUES ("Another Movie Title", 777);

INSERT INTO halls (name, id) VALUES ("small hall", 10);
INSERT INTO halls (name, id) VALUES ("big hall", 20);

INSERT INTO seats (hall_id, seat_number) VALUES (10, "A1");
INSERT INTO seats (hall_id, seat_number) VALUES (10, "A2");

INSERT INTO seats (hall_id, seat_number) VALUES (20, "A1");
INSERT INTO seats (hall_id, seat_number) VALUES (20, "A2");
INSERT INTO seats (hall_id, seat_number) VALUES (20, "B1");
INSERT INTO seats (hall_id, seat_number) VALUES (20, "B2");
INSERT INTO seats (hall_id, seat_number) VALUES (20, "B3");
