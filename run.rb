#!/usr/bin/env ruby

require 'csv'

TRADE_DATE_COL = 'TradeDate'

file = ARGV[0].to_s.strip
min_date = ARGV[1].to_s.strip

if file == '' || !File.exist?(File.expand_path(file))
  puts "File not found: #{file}"
  exit 1
end

if min_date == ''
  puts "Minimum date not specified. Expected format: yyyy-mm-dd"
else
  min_date = Date.new(*min_date.split('-').map { |d| d.to_i })
end


if file =~ /\.csv$/
  csv = CSV.read(file)
  date_index = nil
  csv.first.each_with_index do |h, i|
    if h == TRADE_DATE_COL
      date_index = i
      break
    end
  end

  if date_index.nil?
    puts "Could not find column for '#{TRADE_DATE_COL}'. Exiting."
    exit 1
  end

  output = [csv.first]

  csv[1..-1].each do |row|
    d = row[date_index]
    d = Date.new(d[0..3].to_i, d[4..5].to_i, d[6..7].to_i)

    unless d < min_date
      output << row
    end
  end; csv = nil

  CSV.open(file, "wb") do |csv|
    output.each do |row|
      csv << row
    end
  end

elsif file =~ /\.xml$/
  puts "XML file detected. Not yet supported."
  exit 1
end


