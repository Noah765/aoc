export def first-puzzle [] {
  prepare-input
  | get updates.correct
  | each { get (($in | length) // 2) }
  | math sum
}

export def second-puzzle [] {
  let input = prepare-input

  $input.updates.incorrect
  | each {
    sort-by -c {|a b| $b in ($input.ordering_rules | get $'($a)') }
    | get (($in | length) // 2)
  }
  | math sum
}

def prepare-input [] {
  let input_sections = open input | lines | split list ''

  $input_sections.0
  | split column '|' left right
  | into int left right
  | {
    ordering_rules: (
      $in
      | group-by left
      | transpose key value
      | update value { get right }
      | transpose -rd
    )
  }
  | insert updates {|record|
    $input_sections.1
    | each { split row ',' | into int }
    | group-by {
      window 2
      | all {|x| $x.1 in ($record.ordering_rules | get $'($x.0)') }
      | if $in { 'correct' } else { 'incorrect' }
    }
  }
}
