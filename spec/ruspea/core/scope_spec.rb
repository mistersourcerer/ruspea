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

  RSpec.describe "Scoping: symbol vs. value association" do
    subject(:scope) { Core::Scope.new }
    let(:reg_test) { PublicRegTest.new }

    describe "#register_public" do
      before do
        scope.register_public reg_test
      end

      it "extract all method names and register them as functions" do
        expect(scope.defined?("omg")).to eq true
        expect(scope.defined?("bbq")).to eq true
      end

      it "ensures private methods are not registered" do
        expect(scope.defined?("nope!")).to eq false
      end
    end
  end
end
