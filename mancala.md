14 slots 6 slots
1 slot each

# attr_accessor

```
class Person
  def name
    @name
  end

  def name=(str)
    @name = str
  end
end

person = Person.new
person.name = 'Dennis'
person.name # => "Dennis"
```

read and write name

# next if

This is where you’re wrong. The relevant statement is

next if i % 2 == 0     # i is even
but next doesn’t mean “do the next line” or anything like that. It tells Ruby to skip that particular number (abort that particular loop repetition at this point) and move on to the next one (which will be odd, so that’s why it prints the odd numbers).