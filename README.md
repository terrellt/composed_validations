# ComposedValidations
[![Circle
CI](https://circleci.com/gh/terrellt/composed_validations.svg?style=svg)](https://circleci.com/gh/terrellt/composed_validations)

This gem's purpose is to get around having to set validations on your base
ActiveModel::Model class. Have you ever wanted to conditionally set validations
based on business logic? Maybe this gem will help.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'composed_validations'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install composed_validations

## Usage

This gem works on the premise of a few simple interfaces:

### Decorated Object

There's an object which responds to the #valid? method, as used by
ActiveModel::Validations, that you'd like to decorate functionality on to which
has a set of accessible properties.

```ruby
class MyObject
  include ActiveModel::Validations
  attr_accessor :title, :description
end
```

### Validators

Validators are objects which takes the result of using a property accessor and
says whether or not it's valid. It responds to `valid?(value)` and `message`(the
message which gets added to errors if this is not valid.)

```ruby
class StringIsBob
  def valid?(value)
    value.to_s == "Bob"
  end

  def message
    "needs to be the string 'Bob'"
  end
end
```

### Decorating One Property

You can add these validations to an object with the following:

```ruby
m = MyObject.new
m = ComposedValidators::WithValidatedProperty.new(m, :title, StringIsBob.new)
m.valid? # => false
m.title = "Bob"
m.valid? # => true
```

### Decorating Multiple Properties

If you need to decorate multiple validators onto one property or multiple
properties at once there is the DecorateProperties object. It works as follows:

```ruby
m = MyObject.new
m = ComposedValidators::DecorateProperties.new(m, {:title => StringIsBob.new,
:description => StringIsBob.new})
m.valid? # => false
m.title = "Bob"
m.valid? # => false
m.description = "Bob"
m.valid? # => true
```

### OR Validations

Sometimes you want a property to be valid if one or more validations are true,
rather than all. To accomplish this we've provided an OrValidator composite
object. It can be used as follows:

```ruby
m = Myobject.new
composed_validator = ComposedValidators::OrValidator.new([StringIsBob.new,
StringIsJoe.new])
m = ComposedValidators::WithValidatedProperty.new(m, :title, composed_validator)
m.valid? # => false
m.title = "Bob"
m.valid? # => true
m.title = "Joe"
m.valid? # => true
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/composed_validations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
