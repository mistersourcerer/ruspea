module Ruspea::Runtime
  RSpec.describe List do
    subject(:builder) { described_class }

    context "building Lists" do
      subject(:list) { builder.create 1, 2, 3, 4 }

      describe "#eq?" do
        it "knows when two lists are alike (eq)" do
          expect(list.eq?(builder.create(1, 2, 3, 4))).to eq true
        end
      end

      describe "#head" do
        it "returns the first element" do
          expect(list.head).to eq 1
        end

        it "also works with car" do
          expect(list.car).to eq 1
        end
      end

      describe "#tail" do
        it "returns a new list with all but the first" do
          expect(list.tail).to eq builder.create(2, 3, 4)
        end

        it "also works with cdr" do
          expect(list.cdr).to eq builder.create(2, 3, 4)
        end
      end
    end
  end
end
