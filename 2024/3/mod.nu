export def first-puzzle [] {
  open input | sum-of-multiplications
}

export def second-puzzle [] {
  open input
  | 'do()' + $in + "don't()"
  | parse -r r#'(?s)do\(\)(?<in>.+?)don't\(\)'#
  | get in
  | str join
  | sum-of-multiplications
}

def sum-of-multiplications [] {
  parse -r 'mul\((?<left>\d{1,3}),(?<right>\d{1,3})\)'
  | into int left right
  | each { $in.left * $in.right }
  | math sum
}
