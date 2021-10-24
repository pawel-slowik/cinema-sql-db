INSERT INTO schedule (
	movie_id,
	hall_id,
	start_at
) VALUES (
	(SELECT id FROM movies WHERE title = "The Vindicators 5"),
	(SELECT id FROM halls WHERE name = "small hall"),
	"2021-10-21 21:30"
);
