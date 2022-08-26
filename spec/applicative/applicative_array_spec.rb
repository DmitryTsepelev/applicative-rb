RSpec.describe Applicative::ApplicativeArray do
  let(:pow2) { lambda { |x| x ** 2 } }

  describe Applicative::Functor do
    describe "fmap" do
      subject { array.fmap(&pow2) }

      let(:array) { Applicative::ApplicativeArray.new([2, 4, 8]) }

      it { is_expected.to eq([4, 16, 64]) }
    end
  end

  describe Applicative::ApplicativeFunctor do
    describe "pure" do
      subject { Applicative::ApplicativeArray::pure(value) }

      context "when value is Integer" do
        let(:value) { 1 }

        it { is_expected.to eq(Applicative::ApplicativeArray.new([1])) }
      end
    end

    describe "^" do
      subject do
        Applicative::ApplicativeArray::pure(pow2) ^ Applicative::ApplicativeArray.new(array)
      end

      let(:array) { [2, 4, 8] }

      it { is_expected.to eq([4, 16, 64]) }

      context "when function in container has two arguments" do
        subject do
          Applicative::ApplicativeArray.new(functions) ^ Applicative::ApplicativeArray.new(array1) ^ Applicative::ApplicativeArray.new(array2)
        end

        let(:plus) { lambda { |x, y| x + y } }
        let(:mult) { lambda { |x, y| x * y } }

        let(:functions) { [plus, mult] }
        let(:array1) { [1, 2] }
        let(:array2) { [10, 20] }

        it { is_expected.to eq([11, 21, 12, 22, 10, 20, 20, 40]) }
      end
    end
  end
end
