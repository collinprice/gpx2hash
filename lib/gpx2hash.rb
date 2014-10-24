require "gpx2hash/version"
require "gpx2hash/gpx2hash_parser.rb"

module Gpx2hash
  
  def self.readFile file
  	Gpx2hashParser.new.readFile file
  end

  def self.readString file
  	Gpx2hashParser.new.readString file
  end
end
