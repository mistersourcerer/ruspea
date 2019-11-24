module Ruspea
  RSpec.describe Form do
    let(:fake_form) {
      Class.new {
        self.include(Form)
      }
    }
    subject(:form) { fake_form.new("lol") }

    describe ".new" do
      it "stores the first param as the value" do
        expect(form.value).to eq "lol"
      end

      it "creates a form in the initial (1, 1) position" do
        expect(form.position).to eq Ruspea::Interpreter::Position.new(1, 1)
      end
    end

    describe "#cast" do
      before do
        fake_form.define_method(:cast) { |string| 1 }
      end

      it "converts the value when initializing the form" do
        expect(form.value).to eq 1
      end
    end
  end
end
