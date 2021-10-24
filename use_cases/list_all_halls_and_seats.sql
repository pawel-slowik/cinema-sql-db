SELECT
	halls.name AS hall_name,
	seats.seat_number
FROM
	halls
	JOIN seats on halls.id = seats.hall_id
ORDER BY
	halls.id,
	seats.seat_number
;
