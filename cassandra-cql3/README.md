# Cassandra CQL3 from cqlsh and Ruby

## Prerequisites

- Cassandra (v1.2.5) should be installed.


## Preparation

```console
$ gem install cql-rb
```


## Demo

```console
$ cqlsh
```


### Inspect Movie Lens Data Set in CQL3

```sql
> USE movielens_cql3;
> SELECT COUNT(*) FROM ratings;
...
Default LIMIT of 10000 was used. Specify your own LIMIT clause to get more results.

> SELECT COUNT(*) FROM ratings LIMIT 1000000;
```

```sql
> SELECT * FROM movies LIMIT 20;
> TRACING ON
> SELECT movie_id, title FROM movies LIMIT 20;
> TRACING OFF
> SELECT * FROM users LIMIT 10;
> SELECT * FROM ratings LIMIT 10;
```

```sql
> select movie_id, title from movies order by movie_id limit 20;
Bad Request: ORDER BY is only supported when the partition key is restricted by an EQ or an IN.
```

### Find a Movie

```sql
> SELECT movie_id, title FROM movies WHERE title LIKE 'Batman%';
Bad Request: line 1:47 no viable alternative at input 'LIKE'

> SELECT movie_id, title FROM movies WHERE title = 'Batman Forever (1995)';
Bad Request: No indexed columns present in by-columns clause with Equal operator

> CREATE INDEX movie_id_title_1 ON movies (title);
```

### Find the Ratings for the Movie

```sql
> SELECT count(*) FROM ratings WHERE movie_id = 29;

> SELECT COUNT(*) FROM ratings WHERE movie_id = 29 AND rating = 5;
No indexed columns present in by-columns clause with Equal operator

> CREATE INDEX ratings_rating ON ratings (rating);
> SELECT COUNT(*) FROM ratings WHERE movie_id = 29 AND rating = 5;

> SELECT avg(rating) FROM ratings WHERE movie_id = 29;
Bad Request: Unknown function 'avg'
```

### Add Some Fields to an Existing Movie Document

```sql
> ALTER TABLE users ADD editors_choice VARCHAR;
```

### Group and Aggrigate the Ratings

CQL3 doesn't support join operation. However, it supports a convenient
map, set and list data types.


### Inspect Movie Lens Data Set in Cassandra Storage Layer

```console
$ cassandra-cli
```

```console
> use
> assume ratings keys as int;


```
