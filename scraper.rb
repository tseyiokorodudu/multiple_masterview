#!/usr/bin/env ruby
Bundler.require

exceptions = []
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
    exceptions << e
  end
end

unless exceptions.empty?
  message = if exceptions.count == 1
              "There was earlier 1 error."
            else
              "There were earlier #{exceptions.count} errors."
            end
  message += " See output for details"
  raise message
end
