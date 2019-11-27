module Ruspea
  RSpec.describe Core do
    let(:evaler) { Evaler.new }
    let(:reader) { Reader.new }

    describe "atoms" do
      it "evaluates numbers" do
        expect(evaler.call(form("1"))).to eq 1
      end

      it "evalutes strings" do
        expect(evaler.call(form("\"ruspea\""))).to eq "ruspea"
      end

      it "evaluates keywords" do
        expect(evaler.call(form(":a"))).to eq :a
        expect(evaler.call(form("a:"))).to eq :a
      end
    end

    describe Core::Quote do
      it "returns the forms unevaled" do
        expect(evaler.call(form("(quote (1 2))")))
          .to eq Forms::List.new(
            Runtime::List.create(
              Forms::Integer.new(1),
              Forms::Integer.new(2),
            )
          )

        expect(evaler.call(form("(quote a)")))
          .to eq Forms::Symbol.new("a")

        expect(evaler.call(form("(quote :a)")))
          .to eq Forms::Keyword.new("a")
      end
    end

    describe Core::Atom do
      it "returns true for numbers, strings, keywords and symbols" do
        expect(evaler.call(form("(atom? 1)"))).to eq true
        expect(evaler.call(form("(atom? \"ruspea\")"))).to eq true
        expect(evaler.call(form("(atom? :a)"))).to eq true
        expect(evaler.call(form("(atom? 'b)"))).to eq true
      end
    end

    describe Core::Eq do
      it "returns true for two params with same value" do
        result = evaler.call(form("(eq? 1 1)"))
        expect(result).to eq true

        result = evaler.call(form("(eq? :a :a)"))
        expect(result).to eq true

        result = evaler.call(form("(eq? '(1 2) '(1 2))"))
        expect(result).to eq true

        result = evaler.call(form("(eq? '() '())"))
        expect(result).to eq true
      end

      it "returns false for two params different values" do
        result = evaler.call(form("(eq? 1 2)"))
        expect(result).to eq false
      end

      it "raises if wrong number of params is passed" do
        expect {
          evaler.call(form("(eq? 1 2 3)"))
        }.to raise_error Error::Arity

        expect {
          evaler.call(form("(eq? 1)"))
        }.to raise_error Error::Arity
      end
    end

    describe Core::First do
      it "returns the first element on a list" do
        expect(evaler.call(form("(first '(1 2 3))")))
          .to eq Forms::Integer.new(1)
      end

      it "returns nil if empty list" do
        expect(evaler.call(form("(first '())"))).to eq nil
      end

      it "raises if argument is not a list" do
        expect {
          evaler.call(form("(first 1)"))
        }.to raise_error Error::Argument
      end
    end

    describe Core::Rest do
      it "returns the first element on a list" do
        expect(evaler.call(form("(rest '(1 2 3))"))).to eq(
          Runtime::List.create(
            Forms::Integer.new(2), Forms::Integer.new(3)
          )
        )
      end

      it "returns nil if empty list" do
        expect(evaler.call(form("(rest '())"))).to eq Runtime::Nil.instance
      end

      it "raises if argument is not a list" do
        expect {
          evaler.call(form("(rest 1)"))
        }.to raise_error Error::Argument
      end
    end

    describe Core::Cons do
      it "returns new list with first param as head and second as tail" do
        expect(evaler.call(form("(cons '1 '(2 3))"))).to eq(
          Runtime::List.create(
            Forms::Integer.new(1),
            Forms::Integer.new(2),
            Forms::Integer.new(3),
          )
        )
      end

      it "works on empty lists" do
        expect(evaler.call(form("(cons '1 '())"))).to eq(
          Runtime::List.create(
            Forms::Integer.new(1)
          )
        )
      end

      it "raises when receives wrong arguments" do
        expect {
          evaler.call(form("(cons 1)"))
        }.to raise_error Error::Arity

        expect {
          evaler.call(form("(cons 1 1)"))
        }.to raise_error Error::Argument
      end
    end
  end
end
