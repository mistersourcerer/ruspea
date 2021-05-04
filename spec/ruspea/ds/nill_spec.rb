module Ruspea::DS
  RSpec.describe Nill do
    subject(:nill) { Nill.instance }

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

      it "should not be equal as a non empty list" do
        expect(nill == List.create(1)).to eq false
      end
    end
  end
end
