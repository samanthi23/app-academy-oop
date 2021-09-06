```
class User
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name, @last_name = first_name, last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def upvote_article(article)
    article.upvotes += 1
  end
end

class SuperUser < User
  attr_reader :super_powers

  def initialize(first_name, last_name, super_powers)
    super(first_name, last_name)
    @super_powers = super_powers
  end

  def upvote_article(article)
    # extra votes
    article.upvotes += 3
  end

  def delete_user(user)
    return unless super_powers.include?(:user_deletion)

    # super user is authorized to delete user
    puts "Goodbye, #{user.full_name}!"
  end
end
```

# <

SuperUser inherits (<) from User class

class SuperUser < User

SuperUser gets all the methods of User file

# overrides

SuperUser overrides User's initialize and upvote_article

super 

initialize will call User's methods 

```
super(first_name, last_name)
```

# we see code that is being duplicated

```
class Magazine
  attr_accessor :editor
end

class Book
  attr_accessor :editor
end
```

instead use

```
class Publication
  attr_accessor :editor
end

class Magazine < Publication
end

class Book < Publication
end
```

# super
```
class Animal
  def make_n_noises(n = 2)
    n.times { print "Growl " }
  end
end

class Liger < Animal
  def make_n_noises(num = 4)
    num.times { print "Roar " }
    # here we'll call super without any arguments. This will pass on `num`
    # implicitly to super. You can think of this call to super as:
    # `super(num)`
    super
  end
end

Liger.new.make_n_noises(3) # => Roar Roar Roar Growl Growl Growl
```

if superis called without any arguments the arguments passed to the method will be implicitly passed to 

super(num)

super

most commonly done in initialize

```
class Animal
  attr_reader :species

  def initialize(species)
    @species = species
  end
end

class Human < Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
```

# set Human.new set species

```
class Animal
  attr_reader :species

  def initialize(species)
    @species = species
  end
end

class Human < Animal
  attr_reader :name

  def initialize(name)
    # super calls the original definition of the method
    # If we hadn't passed "Homo Sapiens" to super, then `name` would have
    # been passed by default.
    super("Homo Sapiens")
    @name = name
  end
end
```

# exceptions and error handling

```
def sqrt(num)
  unless num >= 0
    raise ArgumentError.new "Cannot take sqrt of negative number"
  end

  # code to calculate square root...
end
```

## rescue
```
def main
  # run the main program in a loop
  while true
    # get an integer from the user
    puts "Please input a number"
    num = gets.to_i

    begin
      sqrt(num)
    rescue ArgumentError => e
      puts "Couldn't take the square root of #{num}"
      puts "Error was: #{e.message}"
    end
  end
end
```

saves exception in the variable e, then runs the error handling code

## ensure

```
begin
  a_dangerous_operation
rescue StandardError => e
  puts "Something went wrong: #{e.message}"
ensure
  puts "No matter what, make sure to execute this!"
end
```

### closing files

```
f = File.open
begin
  f << a_dangerous_operation
ensure
  # must. close. file.
  f.close
end
```

### try again, retry

```
def prompt_name
  puts "Please input a name:"
  # split name on spaces
  name_parts = gets.chomp.split

  if name_parts.count != 2
    raise "Uh-oh, finnicky parsing!"
  end

  name_parts
end

def echo_name
# repeats the begin block
  begin
    fname, lname = prompt_name

    puts "Hello #{fname} of #{lname}"
  rescue
    puts "Please only use two names."
    retry
  end
end
```

# exception hierarchy

link: http://blog.nicksieger.com/articles/2006/09/06/rubys-exception-hierarchy/

## ArgumentError

argument passed to a method is invalid

## RuntimeError

generic errors

```
raise RuntimeError.new("Didn't try hard enough")
```

## StandardError

```
class EngineStalledError < StandardError
end

class CollisionOccurredError < StandardError
end

def drive_car
  # engine may stall, collision may occur
end

begin
  drive_car
rescue EngineStalledError => e
  puts "Rescued from engine stalled!"
rescue CollisionOccurredError => e
  puts "Rescued from collision!"
ensure
  puts "Car stopped."
end
```
```
Exception
 NoMemoryError
 ScriptError
   LoadError
   NotImplementedError
   SyntaxError
 SignalException
   Interrupt
 StandardError
   ArgumentError
   IOError
     EOFError
   IndexError
   LocalJumpError
   NameError
     NoMethodError
   RangeError
     FloatDomainError
   RegexpError
   RuntimeError
   SecurityError
   SystemCallError
   SystemStackError
   ThreadError
   TypeError
   ZeroDivisionError
 SystemExit
 fatal
 ```
 
 # decomposition into objects
 
 look for nouns
 
 a simulation of minnows and sharks: each "turn" the minnow swim away from the shark and the shark swims after the closest minnow
 
 ```
 class Minnow
end

class Shark
end
```

## swim

```
class Minnow
  def swim
    # swim away from any sharks
  end
end

class Shark
  def swim
    # swim toward closest fish
  end
end
```

## position

```
class Minnow
  attr_reader :position
  
  def initialize(initial_position)
    # save the minnow's initial position
    @position = initial_position
  end
  
  def swim
    # swim away from any sharks; update @position
  end
end
```

Minnow's position is called the state of an objects

Minnow and Shark swim differently, this is called behavior

link: https://blog.codinghorror.com/curlys-law-do-one-thing/

a large class is > 125 lines of code

# inheritance and DRY

```
class Minnow
  def eat
    puts "eat eat eat"
  end
end

class Shark
  def eat
    puts "eat eat eat"
  end
end
```

```
class Fish
  def eat
    puts "eat eat eat"
  end
end

class Minnow < Fish
end

class Shark < Fish
end
```

```
class Employee
  def wage
    20_000
  end
end

class Manager < Employee
  def wage
    50_000
  end
end

class CEO < Manager
  def wage
    1_000_000
  end
end

# calculate the total salary of many employees
def total_salary(employees)
  total = 0
  employees.each do |employee|
    # Don't know/care what kind of `Employee` (regular, Manager,
    # or CEO) this is. We can treat them all the same.
    total += employee.wage
  end
end
```

# information hiding 
## encapsulation


methods private

can only access those methods from within the class

```
class Airplane
  def fly
    start_engine
    ...
  end

  private
  def start_engine
    ...
  end
end
```

instance variables are always 'private'

public getter/setter methods 

attr_accessor

# UML

In UML, classes can be related to each other in several different ways, including parent-child and association (a "has a" relationship). Piece is the parent of Pawn, for example, while Game is associated with Board because Game has a (i.e. requires) Board.

A class is usually drawn in UML with three components: a name, a set of attributes (instance variables), and a set of methods. The attributes and methods are marked as being public (+), private(-), or protected (#), and class methods are underlined.

link: https://assets.aaonline.io/fullstack/ruby/assets/Chess_Diagram.png
