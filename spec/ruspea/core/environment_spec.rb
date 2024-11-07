module Ruspea
  RSpec.describe Core::Environment do
    include Core::Casting

    subject(:env) { described_class.new }

    before do
      env["fourtwenty"] = true
    end

    describe "#empty?" do
      it "returns false if there is any bounded values on the scope" do
        expect(env.empty?).to eq false
      end

      it "returns true if there is no bindings" do
        new_env = described_class.new

        expect(new_env.empty?).to eq true
      end

      it "returns true if there are many 'empty scopes' stacked" do
        stacked_env = described_class.new.push.push

        expect(stacked_env.empty?).to eq true
      end
    end

    describe "#push" do
      it "stacks the new bindings on top of the environment" do
        new_env = env.push(schemer: "Friedman")

        expect(new_env["schemer"]).to eq "Friedman"
      end

      it "ensures last added scope override declarations on previous ones" do
        new_env = env.push(fourtwenty: "yup")

        expect(new_env["fourtwenty"]).to eq "yup"
        expect(env["fourtwenty"]).to eq true
      end

      it "works without a parameter" do
        new_env = env.push
        new_env["Yasiin"] = "Bey"

        expect(new_env["Yasiin"]).to eq "Bey"
        expect(new_env["fourtwenty"]).to eq true
      end

      it "works with an actual environment" do
        new_env = env.push(described_class.new(new_scope: {mos: "def"}))

        expect(new_env["mos"]).to eq "def"
      end
    end

    describe "#pop" do
      it "returns a new scope with the last added one removed from the top" do
        new_env = env.push(fourtwenty: "yup")

        expect(new_env.pop["fourtwenty"]).to eq true
      end

      it "returns 'empty' environment when popping last scope" do
        empty = env.pop

        expect(empty.empty?).to eq true
      end
    end

    describe "#[]=" do
      it "creates a new binding in the current env" do
        env["lol"] = "bbq"

        expect(env["lol"]).to eq "bbq"
      end

      it "doesn't mutate 'upper' environments" do
        new_env = env.push(fourtwenty: "yup")

        expect(new_env["fourtwenty"]).to eq "yup"
        expect(env["fourtwenty"]).to eq true
      end
    end

    describe "#[]" do
      it "finds bindings in the current scope" do
        new_env = env.push
        new_env["answer"] = 42

        expect(new_env["answer"]).to eq 42
      end

      it "searches for bindings in the lookup chain" do
        new_env = env
          .push(second_scope: "here")
          .push(third_scope: "also here")
          .push

        expect(new_env["third_scope"]).to eq "also here"
        expect(new_env["second_scope"]).to eq "here"
        expect(new_env["fourtwenty"]).to eq true
      end

      describe "#bound?" do
        it "returns true for bounded and false for unbounded symbols" do
          env[Symbol("lol")] = 420

          expect(env.bound? Symbol("nada")).to eq false
          expect(env.bound? Symbol("lol")).to eq true
        end
      end
    end
  end
end
