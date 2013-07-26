
@TODO: This is pretty unfinished...

```sql
INSERT INTO Movie (movie_id, title) VALUES (1, 'Titanic');

SELECT * FROM Movie;

CREATE INDEX movie_title ON movie(title);

SELECT * FROM movie WHERE title = 'Titanic';

INSERT INTO MovieRatings (movie_id, timestamp, user_id, rating) VALUES (1, 100, 5, 4);
```

