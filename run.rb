#!/usr/bin/env ruby

require 'fileutils'

series_word, nice_series = ARGV[0..1]

if ! series_word or ! nice_series or series_word == '' or nice_series == ''
  STDERR.puts "Series word and nice series are required"
  exit 1
end

series_patt = %r|S([\d]{1,2})E([\d]{1,2})|i

Dir['*'].each do |fname|
  next if File.directory?(fname)
  
  if fname =~ /#{series_word}/i
    if fname =~ series_patt
      puts "Found Season #{$1}, episode #{$2} of #{nice_series}"
      
      new_name = "#{nice_series} - S#{sprintf('%02d', $1.to_i)}E#{sprintf('%02d', $2.to_i)}#{File.extname(fname)}"
      
      if new_name == fname
        puts " -> properly named already"
      else
        puts " -> #{new_name}"
        FileUtils.move( fname, new_name )
      end
    end
  end
end