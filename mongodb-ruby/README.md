# MongoDB (and VoltDB)

## Prerequsits

- MongoDB (v2.4.5) should be installed.
- VoltDB (v3.4) sholud be installed.


## Preparation

### Install "mongo" Ruby Gem

```console
$ gem install mongo
Fetching: bson-1.9.1.gem (100%)
Successfully installed bson-1.9.1
Fetching: mongo-1.9.1.gem (100%)
Successfully installed mongo-1.9.1
2 gems installed
```

@TODO: mongo_ext won't be necessary.

```console
$ gem install mongo_ext
Fetching: mongo_ext-0.19.3.gem (100%)
Building native extensions.  This could take a while...
Successfully installed mongo_ext-0.19.3
1 gem installed
```

```console
$ gem install bson_ext
Fetching: bson_ext-1.9.1.gem (100%)
Building native extensions.  This could take a while...
Successfully installed bson_ext-1.9.1
1 gem installed
```

```console
$ sudo mkdir -p /data/db
$ sudo chown tatsuya:tatsuya /data/db
$ rm -rf /data/db/*
$ mongod
```

### Download Movie Lens Dataset

See [the gerelal README](../README.md).


### Load Movie Lens Dataset to MongoDB

```console
$ cd $DEMO/mongo-ruby
$ ./loader.rb $DEMO/data/ml-100K/u.item
$ ./loader.rb $DEMO/data/ml-100K/u.user
$ ./loader.rb $DOMO/data/ml-100K/u.data
```


### Load Movie Lens Dataset to VoltDB

See [VoltDB README](../voltdb/README.md).



## Demo

### Inspect Movie Lens Dataset

#### VoltDB

```console
$ sqlcmd
```

```sql
> SELECT COUNT(*) FROM ratings;
```

```sql
> SELECT * FROM movies LIMIT 20;
> SELECT movie_id, title FROM movies LIMIT 20;
> SELECT * FROM users LIMIT 10;
> SELECT * FROM ratings LIMIT 10;
```

#### MongoDB

```console
$ cd $DEMO/mongodb-ruby
$ irb
```

```ruby
> require 'mongo'
> include Mongo
> client = MongoClient.new
> db = client.db('movie_lens')
> db.collections.map { |c| c.name }
> movies = db.collection(:movies)
> users = db.collection(:users)
> ratings = db.collection(:ratings)
```

```ruby
> ratings.count
```

```ruby
> movies.find_one
> users.find_one
> ratings.find_one
```

### Find a Movie

#### VoltDB

```sql
> SELECT movie_id, title FROM movies WHERE title LIKE 'Batman%';
> SELECT mokie_id, title FROM movies WHERE title LIKE 'Batman%(1995)%';
```

### MongoDB

```ruby
> movies.find({:title => /batman/i})
> movies.find({:title => /batman/i}).count
> movies.find({:movie_title => /batman/i}).map { |m| m['movie_title'] }
> movies.find_one({:title => /batman.*\(1989\).*/i})
> id = movies.find_one({:title => /batman.*\(1989\).*/i})['_id']
```

### Find the Ratings for the Movie

#### VoltDB

```sql
> SELECT count(*) FROM ratings WHERE movie_id = 29;
```

#### MongoDB

```ruby
> movies.find({:movie_id => id}).count
> movies.find({:movie_id => id, :rating => 5}).count
```

### MongoDB: Add Some Fields to an Existing Movie Document

```ruby
> movies.update({:_id => id}, {'$set' => {:editors_choice => true}}
```

### MongoDB: Create Indices

```ruby
> ratings.index_information
> ratings.create_index(:movie_id)
```

### Group and Aggrigate the Ratings

#### VoltDB

```sql
> SELECT m.movie_id, m.title, r.rating, COUNT(r.rating)
    FROM movies m, ratings r
    WHERE m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title, r.rating
    ORDER BY m.movie_id, r.rating DESC
    LIMIT 20;

> SELECT m.movie_id, m.title, AVG(r.rating)
    FROM movies m, ratings r
    WHERE m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.title
    ORDER BY m.movie_id
    LIMIT 20;
```


#### MongoDB

```ruby
> map = <<-EOC
function() {
  emit({ movie_id:this.movie_id, rating:this.rating }, { count:1 });
};
  EOC

> reduce = <<-EOC
function(key, values) {
  var count = 0;
  values.forEach(function(v) {
    count += v['count'];
  });

  return { count: count };
};
  EOC

> cr = ratings.map_reduce(map, reduce, { :out => 'count_by_rating' })
```

```ruby
> cr.conut
> cr.find_one
> cr.find_one({:_id => {:movie_id => id, :rating => 5}})['value']['count']
```
