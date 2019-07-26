module Ruspea::Runtime
  RSpec.describe Lisp do
    let(:builder) { Ruspea::Runtime::List }
    include described_class

    describe "#cons" do
      it "cons an element into a existent list" do
        list = builder.create 2, 3

        expect(cons(1, list)).to eq builder.create 1, 2, 3
      end

      it "cons an element into an empty list" do
        expect(cons(1, builder.create)).to eq builder.create(1)
      end
    end

    describe "#empty?" do
      it "check if a list is empty" do
        expect(empty?(builder.create)).to eq true
      end
    end
  end
end
