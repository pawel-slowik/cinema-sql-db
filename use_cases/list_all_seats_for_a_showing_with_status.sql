SELECT
	seats.seat_number,
	NOT EXISTS (
		SELECT
			seat_number
		FROM
			tickets_sold
		WHERE
			tickets_sold.hall_id = schedule.hall_id
			AND tickets_sold.start_at = schedule.start_at
			AND tickets_sold.seat_number = seats.seat_number
	) AS available
FROM
	schedule
JOIN
	seats ON seats.hall_id = schedule.hall_id
WHERE
	schedule.hall_id = (SELECT id FROM halls WHERE name = "small hall")
	AND schedule.start_at = "2021-10-21 21:30"
;
