export def first-puzzle [] {
  let chunks = prepare-input

  mut checksum = 0

  mut left_chunk = $chunks | first
  mut left_block_position = 0

  mut right_file_id = $chunks | last | get index
  mut right_blocks_left = $chunks | last | get item.0

  while $left_chunk.index < $right_file_id {
    $checksum += ($left_block_position..<($left_block_position + $left_chunk.item.0) | math sum) * $left_chunk.index
    $left_block_position += $left_chunk.item.0

    mut remaining_free_space = $left_chunk.item.1
    while $remaining_free_space > 0 and $left_chunk.index < $right_file_id {
      let inserting_blocks_amount = [$remaining_free_space $right_blocks_left] | math min

      $checksum += ($left_block_position..<($left_block_position + $inserting_blocks_amount) | math sum) * $right_file_id
      $left_block_position += $inserting_blocks_amount
      $remaining_free_space -= $inserting_blocks_amount
      $right_blocks_left -= $inserting_blocks_amount

      if $right_blocks_left == 0 {
        $right_file_id -= 1
        $right_blocks_left = $chunks | get $right_file_id | get item.0
      }
    }

    $left_chunk = $chunks | get ($left_chunk.index + 1)
  }

  if $left_chunk.index == $right_file_id {
    $checksum += ($left_block_position..<($left_block_position + $right_blocks_left) | math sum) * $right_file_id
  }

  $checksum
}

export def second-puzzle [] {
  mut chunks = prepare-input | insert moved false
  mut movable_chunks = $chunks

  mut checksum = 0

  mut block_position = 0
  for chunk_index in 0..<($chunks | length) {
    let chunk = $chunks | get $chunk_index

    if not $chunk.moved { $checksum += ($block_position..<($block_position + $chunk.item.0) | math sum) * $chunk.index }
    $block_position += $chunk.item.0

    mut remaining_free_space = $chunk.item.1
    mut movable_chunk_index = ($movable_chunks | length) - 1
    mut movable_chunk = $movable_chunks | last
    while $remaining_free_space > 0 and $movable_chunk.index > $chunk.index {
      if $movable_chunk.item.0 <= $remaining_free_space {
        $checksum += ($block_position..<($block_position + $movable_chunk.item.0) | math sum) * $movable_chunk.index
        $block_position += $movable_chunk.item.0
        $remaining_free_space -= $movable_chunk.item.0
        $movable_chunks = $movable_chunks | drop nth $movable_chunk_index
        $chunks = $chunks | update $movable_chunk.index { update moved true }
      }

      $movable_chunk_index -= 1
      $movable_chunk = $movable_chunks | get $movable_chunk_index
    }
    $block_position += $remaining_free_space
  }

  $checksum
}

def prepare-input [] {
  open input
  | split chars
  | drop
  | into int
  | append 0
  | chunks 2
  | enumerate
}
