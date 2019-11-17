module Ruspea::Interpreter
  RSpec.describe Form do
    subject(:form) {
      Class.new {
        self.include(Form)
      }.new("lol")
    }

    describe ".new" do
      it "stores the first param as the value" do
        expect(form.value).to eq "lol"
      end

      it "creates a form in the initial (1, 1) position" do
        expect(form.position).to eq Position.new(1, 1)
      end
    end
  end
end
