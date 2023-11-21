package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"sync"

	ffmpeg "github.com/u2takey/ffmpeg-go"
)

// Timestamp in seconds
type Timestamp float64

func NewTimestamp(timestamp string) Timestamp {
	if timestamp == "" {
		return Timestamp(math.Inf(1))
	}
	strtonum := func(s string) float64 {
		i, err := strconv.ParseFloat(strings.TrimSpace(s), 64)
		if err != nil {
			panic(err)
		}
		return i
	}
	fields := strings.Split(timestamp, ":")
	var hour, minute, seconds float64 = 0, 0, 0
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

func TimerangesFromFile(filename string) []Timerange {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	var line_regex = regexp.MustCompile(`([0-9:.]+)\s+([0-9:.]+(?:\s+))?(.*)`)
	parseLine := func(line string) (start, end, name string) {
		match := line_regex.FindStringSubmatch(line)

		start = match[1]
		end = match[2]
		name = match[3]

		return
	}

	scanner := bufio.NewScanner(file)
	var ranges []Timerange

	scanner.Scan()
	var prev_start, prev_end, prev_name string
	var next_start, next_end, next_name string
	prev_start, prev_end, prev_name = parseLine(scanner.Text())
	for scanner.Scan() {
		next_start, next_end, next_name = parseLine(scanner.Text())

		if prev_end == "" {
			prev_end = next_start
		}

		ranges = append(ranges, NewTimerange(prev_name, NewTimestamp(prev_start), NewTimestamp(prev_end)))
		prev_start, prev_end, prev_name = next_start, next_end, next_name
	}
	ranges = append(ranges, NewTimerange(next_name, NewTimestamp(next_start), NewTimestamp(next_end)))

	return ranges
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
			output_args := make(ffmpeg.KwArgs)
			// do not include `-t` if timestamp is infinitiy (go until end of file)
			if !math.IsInf(float64(r.end), 1) {
				output_args["t"] = r.end - r.start
			}
			f := ffmpeg.Input(vr.file, ffmpeg.KwArgs{"ss": r.start}).
				Output(output_name, output_args)
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
	progName := os.Args[0]
	args := os.Args[1:]

	var input_file, timestamps_file, output_extension string
	switch len(args) {
	case 2:
		input_file = args[0]
		timestamps_file = args[1]
		VideoRanges{
			input_file,
			"aac",
			TimerangesFromFile(timestamps_file),
		}.Cut()
	case 3:
		input_file = args[0]
		timestamps_file = args[1]
		output_extension = args[2]
		VideoRanges{
			input_file,
			output_extension,
			TimerangesFromFile(timestamps_file),
		}.Cut()
	default:
		fmt.Println("Invalid number of arguments. Use as follows:")
		fmt.Println("  ", progName, "<input_file> <timestamps_file> [<output_extension>]")
		os.Exit(1)
	}
}
