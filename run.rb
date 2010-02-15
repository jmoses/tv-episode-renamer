#!/usr/bin/env ruby

series_word, nice_series = ARGV[0..1]

if ! series_word or ! nice_series or series_word == '' or nice_series == ''
  STDERR.puts "Series word and nice series are required"
  exit 1
end

series_patt = %r|S([\d]{1,2})E([\d]{1,2})|

Dir['*'].each do |fname|
  if fname =~ /#{series_word}/i
    if fname =~ series_patt
      puts "Found Season #{$1}, episode #{$2} of #{nice_series}"
    end
  end
end