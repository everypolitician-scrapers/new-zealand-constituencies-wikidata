#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'wikidata/area'

query = <<-EOQ
  SELECT DISTINCT ?item WHERE {
    VALUES ?NZconstituency { wd:Q3382900 wd:Q26714837 }
    ?item wdt:P31 ?NZconstituency .
  }
EOQ

ids = EveryPolitician::Wikidata.sparql(query)
raise 'No ids' if ids.empty?

data = Wikidata::Areas.new(ids: ids).data
ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite(%i(id), data)
