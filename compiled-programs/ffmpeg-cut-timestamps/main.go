package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"

	ffmpeg "github.com/u2takey/ffmpeg-go"
)

// Timestamp in seconds
type Timestamp int

func NewTimestamp(timestamp string) Timestamp {
	strtonum := func(s string) int {
		i, err := strconv.Atoi(strings.TrimSpace(s))
		if err != nil {
			panic(err)
		}
		return i
	}
	fields := strings.Split(timestamp, ":")
	var hour, minute, seconds int = 0, 0, 0
	switch len(fields) {
	case 1:
		seconds = strtonum(fields[0])
	case 2:
		minute = strtonum(fields[0])
		seconds = strtonum(fields[1])
	case 3:
		hour = strtonum(fields[0])
		minute = strtonum(fields[1])
		seconds = strtonum(fields[2])
	default:
		panic(fmt.Sprintf("Unknown timestamp format: %v", timestamp))
	}
	return Timestamp(hour*3600 + minute*60 + seconds)
}

// Timerange is a struct which encodes a start and end timestamp.
type Timerange struct {
	name  string
	start Timestamp
	end   Timestamp
}

func NewTimerange(name string, start Timestamp, end Timestamp) Timerange {
	var n string
	n = strings.ReplaceAll(name, " ", "_")
	n = strings.ReplaceAll(n, ":", "_")
	return Timerange{n, start, end}
}

// VideoRanges encodes the file name of the video to be cut, as well as all the ranges which should be extracted.
type VideoRanges struct {
	file      string
	extension string
	ranges    []Timerange
}

// Cut performs the actual cutting of the video clip according to the given time ranges.
func (vr VideoRanges) Cut() {
	var dirname string = strings.TrimSuffix(filepath.Base(vr.file), filepath.Ext(vr.file))
	var wg sync.WaitGroup
	if err := os.Mkdir(dirname, 0755); err != nil {
		if os.IsExist(err) {
			fmt.Println("Directory exists:", dirname)
		} else {
			panic(fmt.Sprintf("Error creating directory: %v", err))
		}
	}
	cut := func(r Timerange, counter int) {
		defer wg.Done()
		output_path := filepath.Join("%v", "%03v_%v.%v")
		output_name := fmt.Sprintf(output_path, dirname, counter, r.name, vr.extension)

		if _, err := os.Stat(output_name); err != nil {
			f := ffmpeg.Input(vr.file, ffmpeg.KwArgs{"ss": r.start}).
				Output(output_name, ffmpeg.KwArgs{"t": r.end})
			if err := f.Run(); err != nil {
				panic(err)
			}
		} else if err == nil {
			fmt.Println("File already exists; skipping:", output_name)
		} else {
			panic(fmt.Sprintln("Unknown file error:", err))
		}
	}
	for i, r := range vr.ranges {
		wg.Add(1)
		go cut(r, i+1)
	}
	wg.Wait()
}

func main() {
	vr := VideoRanges{
		"/tmp/tlg.mkv",
		// "/tmp/tlg2.mkv",
		"mp3",
		[]Timerange{
			NewTimerange("Overture: Lore", NewTimestamp("00:00"), NewTimestamp("03:05")),
			NewTimerange("Panorama", NewTimestamp("03:05"), NewTimestamp("03:43")),
			NewTimerange("Forest", NewTimestamp("03:43"), NewTimestamp("05:49")),
			NewTimerange("Sentinel I", NewTimestamp("05:49"), NewTimestamp("08:40")),
			NewTimerange("The Tower", NewTimestamp("08:40"), NewTimestamp("09:32")),
			NewTimerange("Falling Bridge", NewTimestamp("09:32"), NewTimestamp("13:13")),
			NewTimerange("Hanging Gardens", NewTimestamp("13:13"), NewTimestamp("15:33")),
			NewTimerange("Sentinel II", NewTimestamp("15:33"), NewTimestamp("18:04")),
			NewTimerange("Victorious", NewTimestamp("18:04"), NewTimestamp("20:30")),
			NewTimerange("Alone", NewTimestamp("20:30"), NewTimestamp("22:27")),
			NewTimerange("The Nest", NewTimestamp("22:27"), NewTimestamp("25:49 ")),
			NewTimerange("Flashback", NewTimestamp("25:49 "), NewTimestamp("29:19")),
			NewTimerange("Sanctuary", NewTimestamp("29:19"), NewTimestamp("31:53")),
			NewTimerange("Condor Clash", NewTimestamp("31:53"), NewTimestamp("36:20")),
			NewTimerange("Wounded", NewTimestamp("36:20"), NewTimestamp("39:26")),
			NewTimerange("Finale I: Apex", NewTimestamp("39:26"), NewTimestamp("45:54")),
			NewTimerange("Finale II: Escape", NewTimestamp("45:54"), NewTimestamp("52:32")),
			NewTimerange(
				"End Titles: The Last Guardian Suite",
				NewTimestamp("52:32"),
				NewTimestamp("01:00:20"),
			),
			NewTimerange("Epilogue", NewTimestamp("01:00:20"), NewTimestamp("01:02:11")),
		},
	}
	vr.Cut()
}
