module Ruspea
  RSpec.describe Evaler do
    subject(:evaler) { described_class.new }
    let(:reader) { Reader.new }

    def form_for(code)
      form, _, _ = reader.next(code)
      form
    end

    describe "Atoms" do
      it "evaluates numbers" do
        expect(evaler.call(form_for("1"))).to eq 1
      end

      it "evalutes strings" do
        expect(evaler.call(form_for("\"ruspea\""))).to eq "ruspea"
      end

      it "evaluates keywords" do
        expect(evaler.call(form_for(":a"))).to eq :a
        expect(evaler.call(form_for("a:"))).to eq :a
      end
    end

    describe "quote" do
      it "returns the forms unevaled" do
        expect(evaler.call(form_for("(quote (1 2))")))
          .to eq Forms::List.new(
            Runtime::List.create(
              Forms::Integer.new(1),
              Forms::Integer.new(2),
            )
          )

        expect(evaler.call(form_for("(quote a)")))
          .to eq Forms::Symbol.new("a")

        expect(evaler.call(form_for("(quote :a)")))
          .to eq Forms::Keyword.new("a")
      end
    end

    describe "(core) Functions" do
      describe "atom?" do
        it "returns true for numbers, strings and keywords" do
          pending
          expect(evaler.call("(atom? 1)")).to eq [true]
          expect(evaler.call("(atom? \"ruspea\")")).to eq [true]
          expect(evaler.call("(atom? :a)")).to eq [true]
        end
      end

      describe "car/head/first" do
        it "returns the head of the list" do
          pending
          expect(evaler.call("(car '(1 2))")).to eq [
            Integer.new(1),
          ]

          expect(evaler.call("(car '(a 2))")).to eq [
            Symbol.new("a")
          ]
        end
      end
    end
  end
end
