export def first-puzzle [] { prepare-input | get-path-positions | length }

export def second-puzzle [] {
  let input = prepare-input

  $input
  | get-path-positions
  | par-each {|position|
    $input
    | update ([obstruction_rows $position.y] | into cell-path) { append $position.x | sort }
    | update ([obstruction_columns $position.x] | into cell-path) { append $position.y | sort }
    | update guard {
      match $position.direction {
        UP => {x: $position.x y: ($position.y + 1)}
        RIGHT => {x: ($position.x - 1) y: $position.y}
        DOWN => {x: $position.x y: ($position.y - 1)}
        LEFT => {x: ($position.x + 1) y: $position.y}
      }
      | insert direction $position.direction
    }
    | emulate-path
  }
  | filter { $in == LOOP }
  | length
}

def prepare-input [] {
  let table = open input | lines | split column -c ''

  {
    last_x: (($table | columns | length) - 1)
    last_y: (($table | length) - 1)
    obstruction_rows: ($table | each { values | enumerate | where item == '#' | get index })
    obstruction_columns: ($table | values | each { enumerate | where item == '#' | get index })
    guard: (
      $table
      | each { values | enumerate | where item not-in [. '#'] }
      | enumerate
      | where item != []
      | first
      | {
        x: $in.item.0.index
        y: $in.index
        direction: (match $in.item.0.item {
          ^ => 'UP'
          > => 'RIGHT'
          v => 'DOWN'
          < => 'LEFT'
        })
      }
    )
  }
}

def get-path-positions [] {
  emulate-path
  | update x { each {} }
  | update y { each {} }
  | flatten x
  | flatten y
  | uniq-by x y
}

def emulate-path [] {
  let input = $in

  mut guard = $in.guard
  mut jumps = []

  loop {
    let x = $guard.x
    let y = $guard.y
    let direction = $guard.direction

    match $direction {
      UP => {
        let obstructions = $input.obstruction_columns | get $x | filter { $in < $y }
        if $obstructions == [] {
          $jumps ++= {x: $x..$x y: $y..0 direction: UP}
          break
        }
        $guard.y = ($obstructions | last) + 1
        $guard.direction = 'RIGHT'
      }
      RIGHT => {
        let obstructions = $input.obstruction_rows | get $y | filter { $in > $x }
        if $obstructions == [] {
          $jumps ++= {x: $x..$input.last_x y: $y..$y direction: RIGHT}
          break
        }
        $guard.x = ($obstructions | first) - 1
        $guard.direction = 'DOWN'
      }
      DOWN => {
        let obstructions = $input.obstruction_columns | get $x | filter { $in > $y }
        if $obstructions == [] {
          $jumps ++= {x: $x..$x y: $y..$input.last_y direction: DOWN}
          break
        }
        $guard.y = ($obstructions | first) - 1
        $guard.direction = 'LEFT'
      }
      LEFT => {
        let obstructions = $input.obstruction_rows | get $y | filter { $in < $x }
        if $obstructions == [] {
          $jumps ++= {x: $x..0 y: $y..$y direction: LEFT}
          break
        }
        $guard.x = ($obstructions | last) + 1
        $guard.direction = 'UP'
      }
    }

    let jump = {x: $x..$guard.x y: $y..$guard.y direction: $direction}
    if ($jumps | any { $in == $jump }) { return LOOP }
    $jumps ++= $jump
  }

  $jumps
}
