module Ruspea::Runtime
  RSpec.describe Str do
    subject(:builder) { described_class }

    describe ".create" do
      it "knows that char + string equals new str with el on the head" do
        string = builder.create "l", builder.create("ol")

        expect(string).to eq builder.create "lol"
      end

      it "transforms multiple parameters into a string (str)" do
        string = builder.create "4", builder.create(":", 2, 0)

        expect(string).to eq builder.create "4:20"
      end

      it "knows how to create a new Str from a char + a Str" do
        string = builder.create "l", builder.create("ol")

        expect(string).to eq builder.create("lol")
      end
    end

    context "building Strs" do
      subject(:list) { builder.create ":20" }

      describe "#cons" do
        it "returns a new Str with the parameter consed to the Str" do
          expect(list.cons(4)).to eq builder.create 4, ":", 2, 0
        end
      end
    end

    context "inspecting Strs" do
      subject(:string) { builder.create "'(great list 13)" }

      describe "#empty?" do
        it "recognizes empty strings" do
          expect(builder.create.empty?).to eq true
        end

        it "knows when string has chars" do
          expect(string.empty?).to eq false
        end
      end

      describe "#eq?" do
        it "knows when two lists are alike (eq)" do
          expect(
            string.eq?(builder.create("'(great list 13)"))).to eq true
        end
      end

      describe "#head" do
        it "returns the first element" do
          expect(string.head).to eq "'"
        end

        it "also works with car" do
          expect(string.car).to eq  "'"
        end
      end

      describe "#tail" do
        it "returns a new string with all but the first" do
          expect(string.tail).to eq builder.create("(great list 13)")
        end

        it "also works with cdr" do
          expect(string.cdr).to eq builder.create("(great list 13)")
        end
      end
    end
  end
end
