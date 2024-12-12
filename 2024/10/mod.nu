export def first-puzzle [] {
  let input = prepare-input

  $input.trailheads
  | each { compute-position-peaks $input.map | uniq | length }
  | math sum
}

export def second-puzzle [] {
  let input = prepare-input

  $input.trailheads
  | each { compute-position-peaks $input.map | length }
  | math sum
}

def prepare-input [] {
  let map = open input | lines | split chars | each { into int }

  {
    map: $map
    trailheads: (
      $map
      | enumerate
      | each {|row|
        $in.item
        | enumerate
        | filter { $in.item == 0 }
        | each { {x: $in.index y: $row.index} }
      }
      | flatten
    )
  }
}

def compute-position-peaks [map] {
  let position = $in
  let height = $map | get $position.y | get $position.x

  if $height == 9 { return [$position] }

  [
    {x: $position.x y: ($position.y - 1)}
    {x: ($position.x + 1) y: $position.y}
    {x: $position.x y: ($position.y + 1)}
    {x: ($position.x - 1) y: $position.y}
  ]
  | filter {|x| $x.x >= 0 and $x.y >= 0 and ($map | get -i $x.y | get -i $x.x) == $height + 1 }
  | each { compute-position-peaks $map }
  | flatten
}
