export def first-puzzle [] {
  prepare-input
  | each { sort }
  | [($in.0 | wrap left) ($in.1 | wrap right)]
  | do {|left right| $left | merge $right } ...$in
  | each { $in.left - $in.right | math abs }
  | math sum
}

export def second-puzzle [] {
  prepare-input
  | update 1 { $in | group-by | transpose value list | update list { length } | transpose -rd }
  | do {|left right| $left | reduce -f 0 {|x| $in + $x * ($right | get -i $'($x)' | default 0) } } ...$in
}

def prepare-input [] {
  open input
  | parse '{left}   {right}'
  | into int left right
  | values
}
