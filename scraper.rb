#!/usr/bin/env ruby
Bundler.require

exceptions = {}
MasterviewScraper::AUTHORITIES.keys.each do |authority_label, params|
  puts "\nCollecting feed data for #{authority_label}..."

  begin
    MasterviewScraper.scrape(authority_label) do |record|
      record["authority_label"] = authority_label.to_s
      MasterviewScraper.log(record)
      ScraperWiki.save_sqlite(["authority_label", "council_reference"], record)
    end
  rescue StandardError => e
    STDERR.puts "#{authority_label}: ERROR: #{e}"
    STDERR.puts e.backtrace
    exceptions[authority_label] = e
  end
end

unless exceptions.empty?
  raise "There were errors with the following authorities: #{exceptions.keys}. See earlier output for details"
end
