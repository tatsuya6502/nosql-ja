
@TODO: This is pretty unfinished...

```irb
require('cassandra')

client = Cassandra.new('MovieLens')

client.column_families.values.map {|cf| cf.name }

def bin(number)
  [number].pack('N')
end

(1..10).each {|row| puts "#{row}: #{client.get('Movie', bin(row))['title']}" }

def int(bin)
  bin.unpack('N')[0]
end

def tr_user(user)
  age = int user['age']
  gender = user['gender']
  occupation = user['occupation']
  zip_code = int user['zip_code']
  {:age => age, :gender => gender, :occupation => occupation, :zip_code => zip_code}
end

(1..10).each do |row|
  puts "#{row}: #{tr_user client.get('User', bin(row))}"
end

client.get('User_MovieRatings', bin(3)).length

client.get('User_MovieRatings', bin(3)).each {|k, v| puts "#{int k}: #{int v}" }

# upto 100?
client.get('MovieRatings', bin(50)).length

(1..100).each { |row| puts "#{row}: #{client.get('MovieRatings', bin(row)).length}" }

ratings =
client.get('MovieRatings', bin(74)).inject([]) do |acc, ckv|
  ck, v = ckv
  if ck.parts[2] == 'rating'
    acc << int(v)
  else
    acc
  end
end

ratings.reduce(:+)
```


## CQL3

