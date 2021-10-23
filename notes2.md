# modules

```
module Greetable
  def greet
    "Hello, my name is #{self.name}"
  end
end

class Human
  include Greetable
  
  def initialize(name)
    @name = name
  end
  
  def name
    @name
  end
end

class Robot
  include Greetable
  
  def name
    "Robot Model #2000"
  end
end
```

takes the methods defined in the module and make them available to instances of Robot and human

extends the abilities of a class

## include vs extends

```
module Findable
  def objects
    @objects ||= {}
  end

  def find(id)
    objects[id]
  end

  def track(id, object)
    objects[id] = object
  end
end

class Cat
  extend Findable
  
  def initialize(name)
    @name = name
    Cat.track(@name, self)
  end
end

Cat.new("Gizmo")
Cat.find("Gizmo") # finds Gizmo Cat object
```

## ||=

653

a ||= b is a conditional assignment operator. It means:

if a is undefined or falsey, then evaluate b and set a to the result.
Otherwise (if a is defined and evaluates to truthy), then b is not evaluated, and no assignment takes place.
For example:
```

a ||= nil # => nil
a ||= 0 # => 0
a ||= 2 # => 0

foo = false # => false
foo ||= true # => true
foo ||= false # => true
```

# Ruby doesn't support multiple inheritance

a class can only have one parent class

```
module Enumerable
  def map(&prc)
    results = []

    # notice how we need `each` to write `map`
    self.each { |el| results << prc.call(el) }

    results
  end

  ...
end

class Array < Object
  include Enumerable
  ...
end

class Hash < Object
  include Enumerable
  ...
end
```

Now all of the methods in the Enumerable module (e.g., map) are mixed in to Array and Hash.

### &prc

This is very useful when you want to do things point-free style. An example is to check if there is any string in an array that is equal to the string "foo". There is the conventional way:
```
["bar", "baz", "foo"].any? { |str| str == "foo" }
And there is the point-free way:

["bar", "baz", "foo"].any?(&"foo".method(:==))
```

## namespaces

prevent name collisions

requires both files, one ```make_bacon``` ef will overwrite theother unless you use modules

A.rb, B.rb

```
module A
  def self.make_bacon
    ...
  end
end
```

```
module B
  def self.make_bacon
    ...
  end
end
```

```
require "A"
require "B"

a_grade_bacon = A.make_bacon
b_grade_bacon = B.make_bacon
```

two different kinds of bacon

# load, require, require_relative

```
# lib/board.rb
class Board
  def initialize
    @grid = Array.new(10)
  end
end

# lib/game.rb
class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

```
$ ruby lib/game.rb
lib/game.rb:3:in `initialize': uninitialized constant Game::Board (NameError)
```
Board is defined in another file that is never loaded lib/game.rb to load lib/board.rb

```
# lib/game.rb
require 'board'

class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

```
$ ruby lib/game.rb
.../lib/ruby/site_ruby/2.1.2/rubygems/custom_require.rb:36:in `require':
cannot load such file -- board (LoadError)
```

LoadError is that it did not find the file that you told it to load load path problem

This is not enough. The problem is Ruby's load path.

$LOAD_PATH

Gem.path

the '.' current directory is not part of the $LOAD_PATH

1. use an path like ./board
2. use require_relative
3. or add a folder to the load path with the -I flag

so use ```require_relative```

require_relative 'board', lib/game.rb

```
# lib/game.rb
require_relative `board`

class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

```
$ ruby lib/game.rb
```

# -I

add a directory to $LOAD_PATH for two separate projects

```
$ ruby -I animal-kit/lib cat-tracker/lib/animal.rb
```

```
$ ruby -I./animal-kit/lib cat-tracker/lib/animal.rb
```

## load

will read in the file everytime no matter what

good to use with pry

* never use load in source files!

# public, private and protected

```
class Cat
  public
  def meow
    puts "meow"
  end

  # access control gets set until another access control statement is
  # seen.
  def other_public_method
  end

  private
  def thoughts
    ...
  end

  protected
  def clean
    ...
  end
end
```

every method is public by default except for initialize which is always private

private methods can only be called in the defining class

private methods cannot be called with an explicit receiver

protected can only be invoked by the objects of its defining class and its subclasses

```
class Dog
  def initialize
    # dominance score is not explicitly observable
    @secret_dominance_score = rand
  end

  def dominates?(other_dog)
    self.secret_dominance_score > other_dog.secret_dominance_score
  end

  protected
  attr_reader :secret_dominance_score
end
```

members of Dog class can access other dominance scores but thehy are secret to everyone outside Dog class

1. what methods are the interface that we'll want to use which details we want to ignore
2. what methods are supported and public and which are liable to change