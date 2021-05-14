module Ruspea
  RSpec.describe Core::Nill do
    subject(:nill) { described_class.instance }

    it { should be_empty }

    describe ".count" do
      subject { nill.count }

      it { should be 0 }
    end

    describe ".tail" do
      subject { nill.tail }

      it { should be nill }
    end

    describe ".cdr" do
      subject { nill.cdr }

      it { should be nill }
    end

    context "equality" do
      it { should be_eq nill }
      it { should be_equal nill }
      it { should be_eql nill }
      it { should_not be_eq Core::List.create(1)  }
    end
  end
end
