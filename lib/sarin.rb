require "sarin/version"
require 'nokogiri'

module Sarin

	class SLFActivity
		attr_reader :xml_doc, :ref_lat, :ref_lon, :radius
		def initialize(xml_string, radius = 100.0, ref_lat = false, ref_lon = false)
			@xml_doc = Nokogiri::XML(xml_string)
			@radius = radius
			if not ref_lat
				ref_lat = self.mean_lat
			end
			if not ref_lon
				ref_lon = self.mean_lon
			end
			@ref_lat = ref_lat
			@ref_lon = ref_lon
		end

		def entries
			self.xml_doc.xpath("//Activity//Entries/Entry")
		end

		def mean_lat
			lat_arr = self.entries.map { |entry|
				entry["latitude"].to_f
			}.select { |entry|
				entry != 0
			}
			lat_arr.inject{ |sum, el| sum + el }.to_f / lat_arr.size
		end

		def mean_lon
			lon_arr = self.entries.map { |entry|
				entry["longitude"].to_f
			}.select { |entry|
				entry != 0
			}
			lon_arr.inject{ |sum, el| sum + el }.to_f / lon_arr.size
		end

		def delta_angle_for_distance(distance)
			2*Math.asin(distance/(2*self.radius))
		end

		def delta_x_for_angle(angle)
			self.radius*Math.cos(angle)
		end

		def delta_y_for_angle(angle)
			self.radius*Math.sin(angle)
		end

		def lat_for_angle(angle)
			self.ref_lat - self.delta_y_for_angle(angle)/111300.0
		end

		def lon_for_angle(angle)
			self.ref_lon - self.delta_x_for_angle(angle)/(Math.cos(self.ref_lat * Math::PI / 180)*111300.0)
		end

		def correct_positions
			angle = 0
			self.entries.each { |entry|
				distance = entry["distance"].to_f
				angle = angle + self.delta_angle_for_distance(distance)
				entry["longitude"] = self.lon_for_angle(angle).to_s
				entry["latitude"] = self.lat_for_angle(angle).to_s
			}
		end

		def to_s
			self.xml_doc.to_s
		end

	end

	class SLFHometrainerConverter
		attr_reader :source_file, :destination_file, :ref_lat, :ref_lon, :radius

		def initialize(source_file, dest_file, radius = 100.0, ref_lat = false, ref_lon = false)
			@source_file = source_file
			@destination_file = dest_file
			@radius = radius
			@ref_lat = ref_lat
			@ref_lon = ref_lon
		end

		def correct_positions
			slf = SLFActivity.new(File.open(self.source_file), self.radius, self.ref_lat, self.ref_lon)
			slf.correct_positions
			File.write(self.destination_file,slf.to_s)
		end

	end
end
