INSERT INTO tickets_sold (
	hall_id,
	start_at,
	seat_number
) VALUES (
	(SELECT id FROM halls WHERE name = "small hall"),
	"2021-10-21 20:00",
	"A1"
);
