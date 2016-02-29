# Sarin - Sigma ROX Indoor Cycling Converter

Sarin is a small Ruby command line tool to redefine the GPS-Positions of Sigma Log File (SLF).
The GPS-Positions to match the recorded speed and distance in circle around the mean GPS-Position in the log.

This is useful if you have done an indoor training. In this case the speed and distance will be recorded correctly.
But the GPS-Positions will be all on one place (or near on place). If you share the log to to [Strava](https://www.strava.com) there will
be shown wrong speeds and distance. Because Strava will recalculate these values from the GPS-Positions.
Thus if you redefine the position with this tool you get a nice log on [Strava](https://www.strava.com)

**Original Log:** 0.3km

![Orginal Log](https://cloud.githubusercontent.com/assets/929957/13409421/4451de82-df33-11e5-8f8c-f83c1e6a8680.png)

**Converted Log:** 24km

![Converted Log](https://cloud.githubusercontent.com/assets/929957/13409428/48a839ae-df33-11e5-8e6f-4a35af6d7963.png)

## Installation

To install just run this command in your terminal

	$ gem install sarin

## Usage

To redefine the GPS-Positions in a Sigma Log File simple run this command:

	$ sarin my-log.slf

This will overwrite the GPS-Positions in your file. If you don't want to overwirte
the file you can specify an output file name:

	$ sarin -o new-pos.slf my-log.slf

You also can redefine the GPS-Positions in more than one file. Simple specify a list
of files. The following command will redefine the GPS-Position of all slf-Files in the
current directory.

	$ sarin -o new-pos.slf \*.slf

If you don't want to share your real trainings position. You can also specify a
custom location and a custom radius of the activity circle. The Position has to in
the format latitude,longitude e.g.: 52.514538,13.350111

	$ sarin -r 200 -p "52.514538, 13.350111" my-log.slf


The tool is also packed with some nice default locations. Try it out!

	$ sarin -c Berlin my-log.slf

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hesstobi/sarin.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
