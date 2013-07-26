#! /usr/bin/env ruby
# -*- mode:ruby, coding:utf-8 -*-

require 'cassandra'

# --------------------------------------
# Parameter Check
# --------------------------------------

unless RUBY_VERSION >= '1.9.0'
  puts 'Please use Ruby 1.9.0 or newer'
  exit(1)
end

unless ARGV.length == 1
  puts 'Usage: load data_filename'
  exit(0)
end

file_path = ARGV[0]

unless File.exists?(file_path)
  puts "Error: File #{file_path} does not exist"
  exit(1)
end


# --------------------------------------
# Classes
# --------------------------------------

module Record
  # @TODO: Auto-generate simple accessor methods.

  def cf_name()
    @cf_name
  end

  def key()
    @key
  end

  def columns()
    Hash[@fields.zip(@values)]
  end

  def to_s()
    "<#{@key.unpack('N')[0]}: #{columns}>"
  end
end

class User
  include Record
  def initialize(values)
    @cf_name = 'User'
    @key     = values[0]
    @fields  = %w{age gender occupation zip_code}
    @values  = values[1..4]
  end
end

class Movie
  include Record
  def initialize(values)
    movie_id = values[0]
    title    = values[1]
    @cf_name = 'Movie'
    @key     = movie_id
    @fields  = %w{title}
    @values  = [title]
  end
end

class MovieGenres
  include Record

  UINT32_ONE = [1].pack('N')

  # emacs ruby mode doesn't like \' in %w
  GENRE_NAMES = ['unknown', 'Action', 'Adventure', 'Animation',
                 'Children\'s', 'Comedy', 'Crim', 'Documentary',
                 'Drama', 'Fantasy', 'Film-Noir', 'Horror',
                 'Musical', 'Mystery', 'Romance', 'Sci-Fi',
                 'Thriller', 'War', 'Western']

  def initialize(values)
    movie_id = values[0]
    @cf_name = 'MovieGenres'
    @key     = movie_id
    @fields_and_values = genres(values)
  end

  def columns()
    @fields_and_values
  end

  def genres(values)
    genres = (0..18).zip(values[5..23]).inject([]) do |acc, iv|
      index, value = iv
      if value == UINT32_ONE
        genre = GENRE_NAMES[index]
        acc << [genre, genre]
      else
        acc
      end
    end
    # puts "genres array: #{genres}"
    Hash[genres]
  end
end

class User_MovieRatings
  include Record
  def initialize(values)
    user_id, movie_id, rating, timestamp = values
    @cf_name = 'User_MovieRatings'
    @key     = user_id
    @fields  = [timestamp]
    @values  = [movie_id]
  end
end

class MovieRatings
  include Record
  def initialize(values)
    user_id, movie_id, rating, timestamp = values
    @cf_name    = 'MovieRatings'
    @key        = movie_id
    @fields     = [Cassandra::Composite.new(timestamp, user_id, 'user_id'),
                   Cassandra::Composite.new(timestamp, user_id, 'rating'),
                   Cassandra::Composite.new(timestamp, user_id, 'timestamp')
                  ]
    @values  =   [user_id, rating, timestamp]
  end
end

# cassandra-0.18.0 gen depends on thrift (< 0.9, >= 0.7.0) which doesn'
# support non ASCII characters.
def remove_non_ascii_chars(str)
  str.tr('Áéèö', 'Aeeo')
end


# --------------------------------------
# Main
# --------------------------------------

RECORD_CLASSES   = {
  "user" => [User],
  "item" => [Movie, MovieGenres],
  "data" => [User_MovieRatings, MovieRatings]
}

dataset = File.basename(file_path).sub(/^u\./, '')
record_classes = RECORD_CLASSES[dataset]
if record_classes.nil?
  puts "Error: Unknown dataset #{dataset}."
  exit(1)
end

File.open(file_path, 'r:iso-8859-1:utf-8') do |file|
  client = Cassandra.new('MovieLens')
  count = 0

  # @TODO: Batch insert
  file.each do |line|
    field_values = line.chomp.split(/[|\t]/).map do |item|
      item =~ /^\d+$/ ? [item.to_i].pack('N') : remove_non_ascii_chars(item)
    end
    # puts "field_values: #{field_values}"
    records = record_classes.map { |cls| cls.new(field_values) }
    records.each do |record|
      # puts record.to_s
      client.insert(record.cf_name, record.key, record.columns)
    end

    count += 1
  end

  puts "Inserted #{count} records into the column families for #{dataset}."
end
