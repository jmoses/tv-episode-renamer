#!/usr/bin/env ruby

require 'fileutils'
require 'rubygems'
require 'trollop'

opts = Trollop::options do 
	opt :prefix, "Prefix of shows to find.", :type => :string
	opt :title, "'Pretty' title of series (used on new file names)", :type => :string
	opt :series_regex, "Different regex to use.", :type => :string
	opt :pretend, "Don't really do anything", :default => false
end

if opts[:prefix] == '' or opts[:title] == ''
  Trollop.die("Prefix and Title are required.")
end

series_patt = opts[:series_regex] ? Regexp.new(opts[:series_regex]): %r|S([\d]{1,2})E([\d]{1,2})|i

Dir['*'].each do |fname|
  next if File.directory?(fname)

  if fname =~ /#{opts[:prefix]}/i
    if fname =~ series_patt
      puts "Found Season #{$1}, episode #{$2} of #{opts[:title]}"
      
      new_name = "#{opts[:title]} - S#{sprintf('%02d', $1.to_i)}E#{sprintf('%02d', $2.to_i)}#{File.extname(fname)}"
      
      if new_name == fname
        puts " -> properly named already"
      else
        puts " -> #{new_name}"
        if File.exists?(new_name)
          STDERR.puts(" -> exists!")
        else
          FileUtils.move( fname, new_name, :noop => opts[:pretend] )
        end
      end
    end
  end
end