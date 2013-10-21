#! /usr/bin/env ruby
# -*- mode:ruby, coding:utf-8 -*-

require 'mongo'

# --------------------------------------
# Parameter Check
# --------------------------------------

unless RUBY_VERSION >= '1.9.0'
  puts 'Please use Ruby 1.9.0 or newer'
  exit(1)
end

unless ARGV.length == 1
  puts 'Usage: loader.rb data_filename'
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
  def to_h()
    Hash[@fields.zip(@values)]
  end
end

class User
  include Record
  def initialize(values)
    @fields = [:_id, :age, :gender, :occupation, :zip_code]
    @values = values
  end
end

class Movie
  include Record

  GENRE_NAMES = %w{unknown Action Adventure Animation For-Children
                   Comedy Crim Documentary Drama Fantasy Film-Noir
                   Horror Musical Mystery Romance Sci-Fi Thriller
                   War Western}

  def initialize(values)
    @fields = [:_id, :title, :genres]
    @values = basic_info(values) + [genres(values)]
  end

  def basic_info(values)
    values[0..1]
  end

  def genres(values)
    (0..18).zip(values[5..23]).inject([]) do |acc, iv|
      index, value = iv
      value != 1 ? acc : acc << GENRE_NAMES[index]
    end
  end
end

class Rating
  include Record
  def initialize(values)
    @fields = [:user_id, :movie_id, :rating, :timestamp]
    @values = values
  end
end


# --------------------------------------
# Main
# --------------------------------------

COLLECTION_NAMES = {"user" => "users", "item" => "movies", "data" => "ratings"}
RECORD_CLASSES   = {"user" =>  User,   "item" =>  Movie,   "data" =>  Rating}

dataset = File.basename(file_path).sub(/^u\./, '')
record_class = RECORD_CLASSES[dataset]
if record_class.nil?
  puts "Error: Unknown dataset #{dataset}."
  exit(1)
end

File.open(file_path, 'r:iso-8859-1:utf-8') do |file|
  db = Mongo::Connection.new.db("movie_lens")
  collection = db.collection(COLLECTION_NAMES[dataset])
  count = 0

  file.each do |line|
    field_values = line.chomp.split(/[|\t]/).map do |item|
      item =~ /^\d+$/ ? item.to_i : item
    end
    record = record_class.new(field_values)
    # puts record.to_h
    collection.insert(record.to_h)
    count += 1
  end

  puts "Inserted #{count} records into the #{collection.name} collection."
end
