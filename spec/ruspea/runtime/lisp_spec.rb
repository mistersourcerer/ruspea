module Ruspea::Runtime
  RSpec.describe Lisp do
    let(:builder) { Ruspea::Runtime::List }
    let(:env) { Ruspea::Runtime::Env.new }

    subject(:lisp) { described_class.new }

    describe "#cons" do
      it "cons an element into a existent list" do
        list = builder.create 2, 3

        expect(lisp.cons(1, list)).to eq builder.create 1, 2, 3
      end

      it "cons an element into an empty list" do
        expect(lisp.cons(1, builder.create)).to eq builder.create(1)
      end
    end

    describe "#take" do
      it "returns the first N elements from the list" do
        list = builder.create(1, 2, 3, 4)

        expect(lisp.take(0, list)).to eq Empty.instance
        expect(lisp.take(1, list)).to eq builder.create(1)
        expect(lisp.take(2, list)).to eq builder.create(1, 2)
      end
    end

    describe "#empty?" do
      it "check if a list is empty" do
        expect(lisp.empty?(builder.create)).to eq true
      end
    end

    describe "#quote" do
      it "returns the parameter as it is" do
        symbol = builder.create(Sym.new("lol"))
        expect(lisp.quote(symbol)).to eq Sym.new("lol")

        list = builder.create(builder.create(1))
        expect(lisp.quote(list)).to eq builder.create(1)
      end

      it "returns quoted lists" do
        list = builder.create(
          builder.create(Sym.new("lol"))
        )
        expect(lisp.quote(list)).to eq builder.create(Sym.new("lol"))

        list = builder.create(builder.create(1))
        expect(lisp.quote(list)).to eq builder.create(1)
      end
    end

    describe "#def" do
      it "returns the value associated with the symbol" do
        definition = builder.create Sym.new("lol"), 1

        expect(lisp.def(definition, env: env)).to eq 1
      end

      it "associates the value with a symbol in the given env" do
        definition = builder.create Sym.new("lol"), 1
        lisp.def definition, env: env

        expect(env.lookup(Sym.new("lol"))).to eq 1
      end

      it "evaluates expression before defining it" do
        definition = builder.create(
          Sym.new("lol"),
          builder.create("fn", [], 1)
        )
        lisp.def definition, env: env

        expect(env.lookup(Sym.new("lol"))).to eq Fn.new([1])
      end
    end

    describe "#fn" do
      it "creates a no-op function if no args are given" do
        invocation = builder.create([])

        expect(lisp.fn(invocation)).to eq Fn.new
      end

      it "creates a function that receives two args" do
        invocation = builder.create([Sym.new("a"), Sym.new("b")])

        expect(lisp.fn(invocation))
          .to eq Fn.new(params: [Sym.new("a"), Sym.new("b")])
      end

      it "creates a function with some body that returns 1" do
        invocation = builder.create([], Sym.new("lol"), 1)

        expect(lisp.fn(invocation)).to eq Fn.new [Sym.new("lol"), 1]
      end
    end
  end
end
