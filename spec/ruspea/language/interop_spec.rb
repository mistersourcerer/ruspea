module Ruspea::Language
  RSpec.describe Interop do
    module Lol
      class WOW
        def say(something)
          puts something
        end
      end
    end

    subject(:interop) { described_class.new }

    describe "#dot" do
      it "calls calls method with single argument" do
        # (. Kernel puts "omg")
        expect {
          interop.dot "Kernel", "print", "omg"
        }.to output("omg").to_stdout
      end

      it "calls method on integers" do
        # (. 1 + 2)
        expect(interop.dot(1, "+", 2)).to eq 3
      end

      it "calls method with multiple args" do
        # (. Kernel print [1 2 3 4])
        expect {
          interop.dot("Kernel", "print", [1, 2, 3, 4])
        }.to output("1234").to_stdout
      end

      it "calls method without arguments" do
        expect(
          interop.dot("Ruspea::Language::Lol::WOW", "new")
        ).to be_a(Lol::WOW)
      end

      it "returns objects created by the interop invokation" do
        expect(
          interop.dot "Kernel", "Array", "bbq"
        ).to eq ["bbq"]
      end
    end
  end
end
