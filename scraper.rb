#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'wikidata/area'

current_q = 'SELECT DISTINCT ?item WHERE { ?item wdt:P31 wd:Q3382900 }'
former_q  = 'SELECT DISTINCT ?item WHERE { ?item wdt:P31 wd:Q26714837 }'

current = EveryPolitician::Wikidata.sparql(current_q)
raise 'No current ids' if current.empty?
former  = EveryPolitician::Wikidata.sparql(former_q)
raise 'No former ids' if former.empty?

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
data = Wikidata::Areas.new(ids: current | former).data
ScraperWiki.save_sqlite(%i(id), data)
