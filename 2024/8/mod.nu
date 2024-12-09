export def first-puzzle [] {
  count-antinodes {|x_range y_range a ab|
    [
      {x: ($a.x - $ab.x) y: ($a.y - $ab.y)}
      {x: ($a.x + 2 * $ab.x) y: ($a.y + 2 * $ab.y)}
    ]
    | where x in $x_range and y in $y_range
  }
}

export def second-puzzle [] {
  count-antinodes {|x_range y_range a ab|
    (
      0..
      | each { {x: ($a.x - $in * $ab.x) y: ($a.y - $in * $ab.y)} }
      | take while { $in.x in $x_range and $in.y in $y_range }
    ) ++ (
      1..
      | each { {x: ($a.x + $in * $ab.x) y: ($a.y + $in * $ab.y)} }
      | take while { $in.x in $x_range and $in.y in $y_range }
    )
  }
}

def count-antinodes [generate_antinodes] {
  let grid = open input | lines | split chars
  let x_range = 0..(($grid.0 | length) - 1)
  let y_range = 0..(($grid | length) - 1)

  $grid
  | enumerate
  | each {|row|
    $in.item
    | enumerate
    | filter { $in.item != '.' }
    | each { {x: $in.index y: $row.index frequency: $in.item} }
  }
  | flatten
  | group-by frequency
  | items {|_ positions|
    $positions
    | enumerate
    | each {|a|
      $positions
      | skip ($a.index + 1)
      | each {|b| do $generate_antinodes $x_range $y_range $a.item {x: ($b.x - $a.item.x) y: ($b.y - $a.item.y)} }
      | flatten
    }
    | flatten
  }
  | flatten
  | uniq
  | length
}
