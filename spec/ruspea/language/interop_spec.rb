module Ruspea::Language
  RSpec.describe Interop do
    module Lol
      class WOW
        def say(something)
          puts something
        end
      end
    end

    let(:builder) { ::Ruspea::Runtime::List }

    subject(:interop) { described_class.new }

    describe "#call" do
      it "calls calls method with single argument" do
        # (. Kernel puts "omg")
        expect {
          interop.call builder.create("Kernel", "print", "omg")
        }.to output("omg").to_stdout
      end

      it "calls method on integers" do
        # (. 1 + 2)
        path = builder.create(1, "+", 2)
        expect(interop.call(path)).to eq 3
      end

      it "calls method with multiple args" do
        # (. Kernel print [1 2 3 4])
        path = builder.create("Kernel", "print", [1, 2, 3, 4])

        expect { interop.call(path) }.to output("1234").to_stdout
      end

      it "calls method without arguments" do
        path = builder.create("Ruspea::Language::Lol::WOW", "new")
        expect(interop.call(path)).to be_a(Lol::WOW)
      end

      it "returns objects created by the interop invokation" do
        path = builder.create "Kernel", "Array", "bbq"
        expect(interop.call(path)).to eq ["bbq"]
      end
    end
  end
end
