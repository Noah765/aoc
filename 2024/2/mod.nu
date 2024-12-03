export def first-puzzle [] {
  prepare-input | filter { check-report } | length
}

export def second-puzzle [] {
  prepare-input
  | filter {|report|
    enumerate
    | reduce -f [$report] {|x, acc| append [($report | reject $x.index)]}
    | any { check-report }
  }
  | length
}

def prepare-input [] {
  open input
  | lines
  | each { split row ' ' | into int }
}

def check-report [] {
  let report = $in
  $report
  | enumerate
  | drop
  | each {|x| ($report | get ($x.index + 1)) - $x.item }
  | (($in | all { $in < 0 }) or ($in | all { $in > 0 })) and ($in | math abs | all { $in <= 3 })
}
