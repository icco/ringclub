require "rubygems"
require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || :development)

require "sinatra/activerecord/rake"
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

namespace :db do
  task :load_config do
    require "./site"
  end
end

task :default => ["db:load_config"] do
  puts "No tests written."
end

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end

desc "Do some cron things"
task :cron => ["db:load_config"] do
  require 'rss'
  require 'open-uri'

  open('./feeds.txt') do |f|
    f.readlines.each do |l|
      url = l.strip
      open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        type = feed.feed_type.to_sym
        if type.eql? :atom
          puts "Title: #{feed.title.content}"
        elsif type.eql? :rss
          puts "Title: #{feed.channel.title}"
        end

        feed.items.each do |item|
          if type.eql? :atom
            puts " - Item: #{item.title.content}"
          elsif type.eql? :rss
            puts " - Item: #{item.title}"
          end
        end
      end
    end
  end
end
