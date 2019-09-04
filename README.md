# Ruspea

A Lisp dialect written in Ruby (and on itself)
meant to be used as a standard Ruby gem.

So if anyone asks:

> What is this Ruspea thing on the Gemfile?

You can go:

> Nah. Just a gem.

Then you can sneak in code like this in your project

```lisp
(def %fib
  (fn [n]
    (cond
      ((= n 0) n)
      ((= n 1) n)
      (true
        (+
          (%fib (- n 1))
          (%fib (- n 2)))))))
```

And execute it from Ruby like:

```ruby
Ruspea::Code.new.load("my/awesome/ruspea/script.rsp")
```

You can also bypass the file loading:

```ruby
require "ruspea"

code = <<~c
(def plus1
  (fn [num] (+ num 1)))
(plus1 10)
c

eleven = Ruspea::Code.new.run(code).last
puts eleven # => 11
```

## Is this a functional language? Is it interpreted?

Yes.

## Humm... but what about the Ruby stuff? The gems?! HUH!?

Ruspea has Ruby interoperabillity built-in
so you can "just use" Ruby:

```lisp
(def puts
  (fn [str]
    (.
      (:: Kernel) puts str)))
```

In fact, the very minimal standard library is
built on top of this interop capability.
It is also the best source to look for usage/syntax/etc right now:
[`lib/language/standard.rsp`](https://github.com/mistersourcerer/ruspea/blob/master/lib/language/standard.rsp)

### OH! I see! This was inspired by Clojure?

100%!

### OH! I see! Is this as good as Clojure!?

![LOL](https://i.imgflip.com/1joc8h.jpg)

## Why would I use that, though? All those parenthesis...

This is the actual question, isn't it?
Sadly this is way out of the scope of this README.

You will need to convince yourself here. 😬

## Is this ready for production usage?

Nope.
And it will probably never be.

This was just an exercise:

  - Ruby is really fun.
  - Lisp too.
  - I am really (I mean REALLY) enjoying Clojure.
  - And I really wanted to learn how to implemente a programming language.
  - Lists are a great way to organize thoughts.

If you put all this together you have this project.

## Shortcomings

Actually, I would prefer to avoid the term ~~shortcomings~~.

The current social norm forces impossible standards
on everyone and everything!

I want to list the things I know are not perfect
about this pretty little thing called Ruspea
and I don't want to hurt it's feelings.

Let's call those rough edges... *features*.
Those are enhancements that are not here... just yet 😬.

![Ironic](https://media.giphy.com/media/9MJ6xrgVR9aEwF8zCJ/source.gif)

### Features

  - No performance! Seriously. There is no optmization whatsoever to see here.
  - No TCO. Goes hand to hand with the previous one.
  - No standard library.
  - No multi-arity functions.
    They are in the Runtime though. Just to lazy to build the syntax reader for each right now.
  - No examples. Besides the "standard library" ones ([`lib/language`](https://github.com/mistersourcerer/ruspea/blob/master/lib/language/standard.rsp))

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruspea'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruspea


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mistersourcerer/ruspea.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
