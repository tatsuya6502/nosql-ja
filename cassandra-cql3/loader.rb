#! /usr/bin/env ruby
# -*- mode:ruby, coding:utf-8 -*-

require 'cql'

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
# Main
# --------------------------------------

TABLES = {
  'user' => 'users',
  'item' => 'movies',
  'data' => 'ratings'
}

INSERT_STATEMENTS = {
  'users'   => 'INSERT INTO users (user_id, age, gender, occupation, zip_code) VALUES (?,?,?,?,?)',
  'movies'  => 'INSERT INTO movies ' +
               '  (movie_id, title, release_date, video_release_date, imdb_url,' +
               '   unknown, action, adventure, animation, children, comedy, crime,' +
               '   documentary, drama, fantasy, film_noir, horror, musical, mystery,' +
               '   romance, sci_fi, thriller, war, western) ' +
               '  VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
  'ratings' => 'INSERT INTO ratings (movie_id, user_id, rating, timestamp) VALUES (?,?,?,?)'
}

dataset = File.basename(file_path).sub(/^u\./, '')
table = TABLES[dataset]
if table.nil?
  puts "Error: Unknown dataset #{dataset}."
  exit(1)
end

File.open(file_path, 'r:iso-8859-1:utf-8') do |file|
  client = Cql::Client.connect(host: 'localhost')
  client.use('movielens_cql3')
  statement = client.prepare(INSERT_STATEMENTS[table])
  count = 0

  # @TODO: Batch insert
  file.each do |line|
    field_values = line.chomp.split(/[|\t]/).map do |item|
      item =~ /^\d+$/ ? item.to_i : item
    end

    if table == 'users'
      zip_code = field_values.pop
      field_values.push(zip_code.to_s)
    end
    # puts "field_values: #{field_values}"
    statement.execute(*field_values)
    count += 1
  end

  puts "Inserted #{count} records into the column families for #{dataset}."
end
