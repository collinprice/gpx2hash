require 'spec_helper'

describe Gpx2hash do

	INVALID_FILE = File.join(File.dirname(__FILE__), "gpx_files/invalid_file.gpx")
	ONE_TRACK = File.join(File.dirname(__FILE__), "gpx_files/one_track.gpx")
	ONE_ROUTE = File.join(File.dirname(__FILE__), "gpx_files/one_route.gpx")
	ONE_WAYPOINT = File.join(File.dirname(__FILE__), "gpx_files/one_waypoint.gpx")
	META = File.join(File.dirname(__FILE__), "gpx_files/meta.gpx")
	
	it 'missing file' do
		expect(Gpx2hash.readFile("file.gpx")).to be false
	end

	it 'invalid file' do
		expect(Gpx2hash.readFile(INVALID_FILE)).to be false
	end

	it 'parse meta' do
		output = Gpx2hash.readFile(META)

		expect(output).to be_a_kind_of(Hash)
		expect(output.has_key? :metadata).to be true
	end

	it 'parse waypoint' do
		output = Gpx2hash.readFile(ONE_WAYPOINT)

		expect(output).to be_a_kind_of(Hash)
		expect(output.has_key? :wpt).to be true
		expect(output[:wpt].length).to equal(1)
	end
	
	it 'parse route' do
		output = Gpx2hash.readFile(ONE_ROUTE)

		expect(output).to be_a_kind_of(Hash)
		expect(output.has_key? :rte).to be true
		expect(output[:rte].length).to equal(1)
	end

	it 'parse track' do
		output = Gpx2hash.readFile(ONE_TRACK)

		expect(output).to be_a_kind_of(Hash)
		expect(output.has_key? :trk).to be true
		expect(output[:trk].length).to equal(1)
	end

end