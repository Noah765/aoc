export def first-puzzle [] {
  let table = open input | lines | split column -c ''
  let rows = $table | each { values }
  let columns = $table | values
  let diagonals1 = (
    (($rows | length) * -1 + 2)..($columns | length)
    | each {|x|
      0..(($rows | length) - 1)
      | each {|y| $table | get $y | get -i $'column($x + $y)'}
    }
  )
  let diagonals2 = (
    1..(($columns | length) + ($rows | length) - 1)
    | each {|x|
      0..(($rows | length) - 1)
      | each {|y| $table | get $y | get -i $'column($x - $y)'}
    }
  )

  $rows ++ $columns ++ $diagonals1 ++ $diagonals2
  | each { window 4 | filter { $in == [X M A S] or $in == [S A M X] } | length }
  | math sum
}

export def second-puzzle [] {
  open input
  | lines
  | split chars
  | do {|table|
    enumerate
    | skip
    | drop
    | each {|row|
      $in.item
      | enumerate
      | skip
      | drop
      | filter {|field|
        ([
          ($table | get ($row.index - 1) | get ($field.index - 1))
          ($field.item)
          ($table | get ($row.index + 1) | get ($field.index + 1))
        ] in [[M A S] [S A M]]
        and
        [
          ($table | get ($row.index + 1) | get ($field.index - 1))
          ($field.item)
          ($table | get ($row.index - 1) | get ($field.index + 1))
        ] in [[M A S] [S A M]])
      }
      | length
    }
    | math sum
  } $in
}
