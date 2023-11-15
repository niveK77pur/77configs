#!/usr/bin/awk -f
# vim: foldmethod=marker

# {{{ HELP PAGE
# This script allows to extract sections from a video or audio file and can
# also change the output file's extension format. Note that the output file's
# name will be slightly adjusted: replacing white spaces with underscores (by
# default) and converting everything into lowercase.

#                ███████
#            ████       ████
#          ██   █       █   ██
#          ██   ██      █   ██
#        ██     █ █     █     ██
#        ██     █  █    █     ██    NAHO
#        ██     █   █   █     ██    GitHub: https://github.com/trueNAHO
#        ██     █    █  █     ██
#          ██   █     █ █   ██
#          ██   █      ██   ██
#            ████       ████
#                ███████

# This script takes three variables in: the 'input_file', the 'timestamps_file'
# and the 'output_extension'.

# The 'input_file' can be one of the following two things: the path referring
# to the file stored on your system OR the output from the 'youtube-dl -g $URL'
# command (see 'youtube-dl --help' command for more information). By using the
# second method, you don't need to first download the entire video in order to
# run this script and can simply get what you need.

# The 'timestamps_file' must be the path referring the file containing the
# necessary information for extracting the desired sections. Note that this
# file MUST follow a certain logic, in order for this script to work. Each line
# consists of two items: the starting time (see 'man ffmpeg-utils' command for
# more information) and the name given to that section. The ending time for a
# section is deduced based on the next section's start time. The last line of
# the file must contain the final end point. If this is not done, then the last
# section will not be considered (If this is done on purpose, then the line
# CANNOT have as last character the time indication). If a section name occurs
# multiple times (after name conversion), only the first occurrence will be
# considered.

# The 'output_extension' must be supported by 'ffmpeg'. For further information
# see the 'ffmpeg -codecs' command.

# Here are two valid 'timestamps_file' examples:

#  -----------------------
# | 00:00 Prologue        |  prologue.EXTENSION       --> from 00:00 to 03:26
# | 03:26 Prohibited Art  |  prohibited_art.EXTENSION --> from 03:26 to 05:19
# | 05:19 Commandment     |  commandment.EXTENSION    --> from 05:19 to 07:14
# | 07:14 Black Blood     |  black_blood.EXTENSION    --> from 07:14 to 09:17
# | 09:17 Resurrection    |  resurrection.EXTENSION   --> from 09:17 to 11:11
# | 11:11                 |  NO FILE PRODUCED
#  -----------------------

#  -----------------------
# | 3:26 Prohibited Art   |  prohibited_art.EXTENSION --> from 03:26 to 05:19
# | 05:19                 |
# | 9:17.333 Resurrection |  resurrection.EXTENSION   --> from 09:17+0.333s
# | 11:11                 |                               to 11:11
# | 5:19 Commandment      |  commandment.EXTENSION    --> from 05:19 to 434s
# | 434 Black Blood       |  NO FILE PRODUCED
#  -----------------------
# }}}

BEGIN {
    # parts of the command, to be put together in 'FFMPEG_CMD' variable
    FFMPEG_PREFIX="ffmpeg "
    FFMPEG_INPUT="-ss %d -i %s -t %d "
    FFMPEG_OUTPUT="\"%03d_%s.%s\"\n"

    # reading variables from command line
    input_file=ARGV[1]; delete ARGV[1]
    timestamps_file=ARGV[2]
    whitespace_replacer="-"

    # display help message upon invalid number of arguments
    if (ARGC-1 < 2 || ARGC-1 > 3) {
        print "Invalid number of arguments. Use as follows:"
        print "  " ARGV[0] " <input_file> <timestamps_file> [<output_extension>]"
        exit 1
    }

    # convert or copy using ffmpeg based on number of arguments
    if (ARGC-1 == 2) {
        # COPY CODEC: only 2 arguments were given ('output_extension' was left out)
        FFMPEG_CMD=FFMPEG_PREFIX FFMPEG_INPUT "-codec copy " FFMPEG_OUTPUT
        array_lenght=split(input_file,array,".")
        output_extension=array[array_lenght]
    } else {
        # CONVERT/RE-ENCODE: all 3 arguments were given ('output_extension' was specified)
        FFMPEG_CMD=FFMPEG_PREFIX FFMPEG_INPUT FFMPEG_OUTPUT
        output_extension=ARGV[3]; delete ARGV[3]
    }
}
{
    if (NR!=1 && file_name !~ /^[0-9]+_'"$whitespace_replacer"'*$/) {
        split($1,times,":");
        clip_duration=times[1]*3600 + times[2]*60 + times[3] - start_time
        CMD=sprintf(FFMPEG_CMD, start_time, input_file, clip_duration, NR-1, file_name, output_extension)
        system(CMD)
    }

    split($1,times,":");
    sub($1,"",$0);
    sub(/^\s+/,"",$0);
    gsub(/\s/,whitespace_replacer,$0);
    gsub(/"/,"\\\"",$0);
    file_name=tolower($0);
    start_time=times[1]*3600 + times[2]*60 + times[3]
}
