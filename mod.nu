const template = 'export def first [] {
  parse-input
}

export def second [] {
  parse-input
}

def parse-input [] {
  open input
}'

# Generates a template for a given day of Advent of Code
export def generate [
  --year (-y): int
  --day (-d): int
]: nothing -> nothing {
  let date = aoc-date $year $day --year-span (metadata $year).span --day-span (metadata $day).span

  let path = $'($date.year)/($date.day)'
  mkdir $path

  http get -H {cookie: $'session=(open SESSION | str trim)'} $'https://adventofcode.com/($date.year)/day/($date.day)/input'
  | save $'($path)/input'

  $template | save $'($path)/mod.nu'
}

# Run the nushell script corresponding to an Advent of Code puzzle
export def main [
  --year (-y): int
  --day (-d): int
  puzzle: int # Either 1 or 2
]: nothing -> nothing {
  let date = aoc-date $year $day --year-span (metadata $year).span --day-span (metadata $day).span

  if $puzzle not-in 1..2 {
    error make {
      msg: 'Invalid puzzle'
      label: {
        text: $'($puzzle) is invalid'
        span: (metadata $puzzle).span
      }
      help: 'The provided puzzle must be between 1 and 2'
    }
  }

  cd $'($date.year)/($date.day)'
  nu -c $'
    use . *
    (match $puzzle { 1 => 'first' 2 => 'second' })
  '
}

def aoc-date [
  year?: int
  day?: int
  --year-span: record<start: int end: int>
  --day-span: record<start: int end: int>
]: nothing -> record<year: int day: int> {
  let latest_advent_day: record<year: int day: int> = (
    date now
    | date to-record
    | if $in.month == 12 { $in } else { {year: ($in.year - 1) day: 25} }
  )

  if $year != null and $year not-in 2015..($latest_advent_day.year) {
    error make {
      msg: 'Invalid year'
      label: {
        text: $'($year) is invalid'
        span: $year_span
      }
      help: $'The provided year must be between 2015 and ($latest_advent_day.year)'
    }
  }
  if $day != null and $day not-in 1..(if $year == null { 25 } else { $latest_advent_day.day }) {
    error make {
      msg: 'Invalid day'
      label: {
        text: $'($day) is invalid'
        span: $day_span
      }
      help: (
        if $year == $latest_advent_day.year and $latest_advent_day.day == 1 { 'The provided day must be 1' }
        else if $year == $latest_advent_day.year { $'The provided day must be between 1 and ($latest_advent_day.day)' }
        else { 'The provided day must be between 1 and 25' }
      )
    }
  }

  match [$year $day] {
    [null null] => $latest_advent_day
    [null _] if $day > $latest_advent_day.day => {year: ($latest_advent_day.year - 1) day: $day}
    [null _] => {year: $latest_advent_day.year day: $day}
    [_ null] if $year == $latest_advent_day => {year: $year day: $latest_advent_day.day}
    [_ null] => {year: $year day: 25}
    _ => {year: $year day: $day}
  }
}
