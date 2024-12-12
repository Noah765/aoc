export def first-puzzle [] { compute-number-of-stones 25 }

export def second-puzzle [] { compute-number-of-stones 75 }

def compute-number-of-stones [blinks] {
  mut stones = open input | split row ' ' | into int | each { {number: $in count: 1} }

  for i in 1..$blinks {
    $stones = (
      $stones
      | each {
        if $in.number == 0 {
          {number: 1 count: $in.count}
        } else if ($'($in.number)' | str length) mod 2 == 0 {
          let length = $'($in.number)' | str length

          [
            {number: ($'($in.number)' | str substring ..<($length // 2) | into int) count: $in.count}
            {number: ($'($in.number)' | str substring ($length // 2).. | into int) count: $in.count}
          ]
        } else {
          {number: ($in.number * 2024) count: $in.count}
        }
      }
      | flatten
      | uniq -c
      | each { {number: $in.value.number count: ($in.value.count * $in.count)} }
    )
  }

  $stones.count | math sum
}
