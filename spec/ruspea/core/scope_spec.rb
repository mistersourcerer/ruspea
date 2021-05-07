module Ruspea
  class PublicRegTest
    def omg(evaler, env = nil)
      "lol"
    end

    def bbq(_, _ = nil)
      "420"
    end

    private

    def nope!
      "no-op"
    end
  end

  RSpec.describe Core::Scope, "symbol vs. value association" do
    subject(:scope) { described_class.new }
    let(:reg_test) { PublicRegTest.new }

    describe "#register" do
      it "binds an object to a specific symbol" do
        scope.register "omg", "lol"

        expect(scope.resolve("omg")).to eq "lol"
      end

      it "overrides existent bindings" do
        scope.register "omg", "lol"
        scope.register "omg", "420"

        expect(scope.resolve("omg")).to eq "420"
      end

      it "accepts symbols as 'labels'" do
        scope.register Core::Symbol.new("omg"), "lol"

        expect(scope.resolve("omg")).to eq "lol"
        expect(scope.resolve(Core::Symbol.new("omg"))).to eq "lol"
      end
    end

    describe "#defined?" do
      it "returns true if the given Symbol is already bound" do
        scope.register "omg", "lol"

        expect(scope.defined?("omg")).to eq true
        expect(scope.defined?(Core::Symbol.new("omg"))).to eq true
      end

      it "returns false if the given Symbol is not bound" do
        expect(scope.defined?("x")).to eq false
      end
    end

    describe "#resolve" do
      it "retrieves the object associated with a specific symbol" do
        scope.register "omg", "lol"

        expect(scope.resolve("omg")).to eq "lol"
      end

      it "raises when symbol is not bound" do
        expect { scope.resolve("omg") }.to raise_error Error::Execution
      end
    end

    context "hash syntax (sugar)" do
      describe "#[]=" do
        it "binds a symbol to an object" do
          scope["omg"] = "lol"

          expect(scope.resolve("omg")).to eq "lol"
        end
      end

      describe "#[]" do
        it "resolves a bound symbol" do
          scope["omg"] = "lol"

          expect(scope["omg"]).to eq "lol"
        end

        it "raises for unbound symbols" do
          expect { scope["omg"] }.to raise_error Error::Execution
        end
      end
    end

    describe "#register_public" do
      before do
        scope.register_public reg_test
      end

      it "extracts all method names and register them as functions" do
        expect(scope.defined?("omg")).to eq true
        expect(scope.defined?("bbq")).to eq true
      end

      it "ensures private methods are not registered" do
        expect(scope.defined?("nope!")).to eq false
      end

      it "binds all 'method names' to the same object" do
        expect(scope.resolve("omg")).to be reg_test
        expect(scope.resolve("bbq")).to be reg_test
      end
    end

  end
end
