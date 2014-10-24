require 'nokogiri'

module Gpx2hash

	class Gpx2hashParser

		def readFile file
			if File.exist? file
				gpxData = File.read file
				parseString gpxData
			else
				false
			end
		end

		def readString gpxData
			parseString gpxData
		end

		private

		def parseString data

			# Parse DOM
			dom = (Nokogiri::XML data.gsub("\n\t", ""))
			dom.encoding = 'utf-8' # HACK: (Maybe) Might cause a bug in the future. 'xpath' did not like XML documents encoded in UTF-8.
			
			# Check if valid xml file.
			if dom.children.length == 0 || dom.root.name != "gpx"
				return false
			end

			dom = dom.root

			# Remove whitespace
			dom.xpath('//text()').each do |node|
				if node.content=~/\S/
					node.content = node.content.strip
				else
					node.remove
				end
			end

			# Remove comments
			dom.xpath('//comment()').each do |node|
				node.remove
			end

			gpxHash = {}

			dom.children.each do |child|

				case child.name
				when "metadata"
					gpxHash[:metadata] = parseNode child
				when "wpt"
					if !gpxHash.has_key? :wpt
						gpxHash[:wpt] = Array.new
					end
					gpxHash[:wpt].push parseNode child
				when "rte"
					if !gpxHash.has_key? :rte
						gpxHash[:rte] = Array.new
					end
					gpxHash[:rte].push parseRoutes child
				when "trk"
					if !gpxHash.has_key? :trk
						gpxHash[:trk] = Array.new
					end
					gpxHash[:trk].push parseTracks child
				end
			end

			gpxHash
		end

		def parseTracks trackNode

			# Extract route points
			trackSegments = Array.new
			trackNode.children.each do |child|
				if child.name == 'trkseg'
					trackSegments.push child
				end
			end

			# Create route with metadata
			track = parseNode trackNode

			# Remove meaningless trkseg
			track.delete :trkseg
			
			# Add real trkseg
			track[:trkseg] = Array.new
			trackSegments.each do |trackSegment|
				segment = Array.new
				trackSegment.children.each do |point|
					next if point.name == "extensions" # Skip extensions
					segment.push parseNode point
				end
				track[:trkseg].push segment
			end

			track
		end

		def parseRoutes routeNode
			
			# Extract route points
			routePoints = Array.new
			routeNode.children.each do |child|
				if child.name == 'rtept'
					routePoints.push child
				end
			end

			# Create route with metadata
			route = parseNode routeNode

			# Remove meaningless rtept
			route.delete :rtept
			
			# Add real rtepts
			route[:rtept] = Array.new
			routePoints.each do |point|
				route[:rtept].push parseNode point
			end

			route
		end

		def parseNode node
			
			# Return if node only contains text.
			if node.children.length == 1 && (node.children.first.is_a? Nokogiri::XML::Text)
				return node.content
			end
			hash = {}

			node.attributes.each do |attr|
				hash[attr.last.name.to_sym] = attr.last.value
			end

			node.children.each do |child|
				hash[child.name.to_sym] = parseNode child
			end

			hash
		end
	end
end