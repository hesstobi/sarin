require 'test_helper'

class SLFActivityTest < Minitest::Test

	def xml
		str =  '<?xml version="1.0" encoding="utf-8"?>'\
			   '<Activity fileDate="Mon Feb 22 22:00:30 GMT+0100 2016" revision="400">'\
			   '    <Computer unit="rox100" serial="12345" activityType="Cycling" dateCode="Mon Feb 22 20:00:00 GMT+0100 2016"/>'\
			   '    <GeneralInformation></GeneralInformation>'\
			   '    <Entries>'\
			   '        <Entry distance="0" latitude="51.0" longitude="13.0"/>'\
			   '        <Entry distance="76.53668648" latitude="51.0" longitude="13.0"/>'\
			   '        <Entry distance="76.53668648" latitude="51.1," longitude="13.0"/>'\
			   '        <Entry distance="76.53668648" latitude="51.1" longitude="13.0"/>'\
			   '        <Entry distance="76.53668648" latitude="51.1" longitude="13.2"/>'\
			   '        <Entry distance="76.53668648" latitude="51.1" longitude="13.2"/>'\
			   '        <Entry distance="76.53668648" latitude="51.2" longitude="13.2"/>'\
			   '        <Entry distance="76.53668648" latitude="51.2" longitude="13.2"/>'\
			   '    </Entries>'\
			   '    <Markers></Markers>'\
			   '</Activity>'
	end

	def setup
		@slf = Sarin::SLFActivity.new(self.xml)
	end


	def test_that_it_has_a_version_number
		refute_nil ::Sarin::VERSION
	end

	def test_number_of_entires
		assert_equal 8, @slf.entries().length
	end

	def test_mean_lat
		assert_in_delta 51.1, @slf.mean_lat
	end

	def test_mean_lon
		assert_in_delta 13.1, @slf.mean_lon
	end

	def test_delta_angle_for_distance
		assert_in_delta (Math::PI)/4, @slf.delta_angle_for_distance(76.53668648)
	end

	def test_delta_x_for_angle
		assert_in_delta 100*0.5 , @slf.delta_x_for_angle(Math::PI/3)
		assert_in_delta 0 , @slf.delta_x_for_angle(Math::PI/2)
		assert_in_delta 100 , @slf.delta_x_for_angle(0)
	end

	def test_delta_y_for_angle
		assert_in_delta 100*0.5 , @slf.delta_y_for_angle(Math::PI/6)
		assert_in_delta 0 , @slf.delta_y_for_angle(0)
		assert_in_delta 100 , @slf.delta_y_for_angle(Math::PI/2)
	end

	def test_correct_positions
		@slf.correct_positions
		assert_in_delta 51.1, @slf.mean_lat
		assert_in_delta 13.1, @slf.mean_lon
	end

	def test_custom_radius
		slf = Sarin::SLFActivity.new(self.xml, 1000)
		assert_equal 1000, slf.radius
		assert_in_delta  1000 , slf.delta_x_for_angle(0)
	end

	def test_custom_center
		slf = Sarin::SLFActivity.new(self.xml, 100, 53, 14)
		assert_equal 53, slf.ref_lat
		assert_equal 14, slf.ref_lon
		slf.correct_positions
		assert_in_delta 53.0, slf.mean_lat
		assert_in_delta 14.0, slf.mean_lon
	end

end
