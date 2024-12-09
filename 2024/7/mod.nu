export def first-puzzle [] { calculate-total-calibration-result {|x| [($in + $x) ($in * $x)] } }

export def second-puzzle [] { calculate-total-calibration-result {|x| [($in + $x) ($in * $x) ($'($in)($x)' | into int)] } }

def calculate-total-calibration-result [apply_operators: closure] {
  open input
  | parse '{result}: {numbers}'
  | into int result
  | update numbers { split row ' ' | into int }
  | filter {|row|
    get numbers
    | reduce {|x| par-each { do $apply_operators $x } | flatten }
    | any { $in == $row.result }
  }
  | get result
  | math sum
}
