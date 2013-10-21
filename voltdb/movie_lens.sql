-- -*- mode:sql -*-

-- VoltDB doesn't support foreign key constraint (and auto-increment columns)

CREATE TABLE users (
  user_id INTEGER UNIQUE NOT NULL,
  age TINYINT,
  gender VARCHAR(1),
  occupation VARCHAR(64),
  zip_code VARCHAR(16),
  PRIMARY KEY (user_id)
);

PARTITION TABLE users ON COLUMN user_id;

CREATE TABLE movies (
  movie_id           INTEGER UNIQUE NOT NULL,
  title              VARCHAR(100),
  release_date       VARCHAR(11),
  video_release_date VARCHAR(11),
  imdb_url           VARCHAR(200),
  unknown            TINYINT,
  action             TINYINT,
  aventure           TINYINT,
  animation          TINYINT,
  children           TINYINT,
  comedy             TINYINT,
  crime              TINYINT,
  documentary        TINYINT,
  drama              TINYINT,
  fantasy            TINYINT,
  film_noir          TINYINT,
  horror             TINYINT,
  musical            TINYINT,
  mystery            TINYINT,
  romance            TINYINT,
  sci_fi             TINYINT,
  thriller           TINYINT,
  war                TINYINT,
  western            TINYINT,
  PRIMARY KEY (movie_id)
);

PARTITION TABLE movies ON COLUMN movie_id;

CREATE TABLE ratings (
  movie_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  rating INTEGER,
  timestamp BIGINT NOT NULL,
  PRIMARY KEY (movie_id, user_id)
);

PARTITION TABLE ratings ON COLUMN movie_id;
