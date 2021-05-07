module Ruspea
  RSpec.describe Core::List do
    subject(:builder) { described_class }

    describe ".create" do
      it "creates a list with (obj, list) when receiving obj + list" do
        list = builder.create 1, builder.create(2, 3, 4)

        expect(list).to eq builder.create 1, builder.create(2, 3, 4)
      end
    end

    context "building Lists" do
      subject(:list) { builder.create 2, 0 }

      describe "#cons" do
        it "returns a new list with the parameter consed to the list" do
          expect(list.cons(4)).to eq builder.create 4, 2, 0
        end
      end
    end

    context "inspecting" do
      subject(:list) { builder.create 1, 2, 3, 4 }

      describe "#empty?" do
        it "recognizes empty lists" do
          expect(builder.create.empty?).to eq true
        end

        it "knows when list is filled" do
          expect(list.empty?).to eq false
        end
      end

      context "Equality" do
        it "knows when two lists are alike" do
          expect(list.eql?(builder.create(1, 2, 3, 4))).to eq true
          expect(list == builder.create(1, 2, 3, 4)).to eq true
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

        it "doesn't go bananas when tail is a list" do
          list = builder.create 1, builder.create(1, 2)

          expect(list.tail).to eq builder.create(builder.create(1, 2))
        end
      end

      describe "#count" do
        it "knows the total size of a list" do
          expect(list.count).to eq 4
          expect(list.cons(0).count).to eq 5
          expect(builder.create(0, list).count).to eq 2
        end
      end

      describe "#take" do
        it "returns N elements from the 'top' of the list" do
          expect(list.take(3)).to eq described_class.create(1, 2, 3)
        end
      end
    end # inspecting Lists

    describe "#to_a" do
      subject(:list) { builder.create 1, 2, 3, 4 }

      it "turns the list into a (Ruby) array" do
        expect(list.to_a).to eq [1, 2, 3, 4]
      end

      it "returns empty array if list is empty" do
        expect(builder.create.to_a).to eq []
      end
    end
  end
end
