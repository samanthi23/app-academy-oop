# private vs public

private methods can only be called in the defining class

example: thing.implicit_receiver #=> "hello world"

# pieces methods

```
@rows.flatten.reject(&:empty?)
```

flatten means 2d array becomes 1d array 

reject means get rid of these 

&:empty? if element is empty discard those [row][col]

leaving the cells with the chess pieces on them

# piece.class.new 

piece color

new_board

piece.pos

