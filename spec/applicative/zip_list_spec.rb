RSpec.describe Applicative::ZipList do
  let(:pow2) { lambda { |x| x ** 2 } }

  describe Applicative::Functor do
    describe "fmap" do
      subject { array.fmap(&pow2) }

      let(:array) { Applicative::ZipList.new([2, 4, 8]) }

      it { is_expected.to eq([4, 16, 64]) }
    end
  end

  describe Applicative::ApplicativeFunctor do
    describe "pure" do
      subject { Applicative::ZipList::pure(value).list.eager.take(3) }

      context "when value is Integer" do
        let(:value) { 1 }

        it { is_expected.to eq([1, 1, 1]) }
      end
    end

    describe "^" do
      subject do
        (Applicative::ZipList::pure(pow2) ^ Applicative::ZipList.new(array)).list.eager.to_a
      end

      let(:array) { [2, 4, 8] }

      it { is_expected.to eq([4, 16, 64]) }

      context "when function in container has two arguments" do
        subject do
          (Applicative::ZipList.new(functions) ^ Applicative::ZipList.new(array1) ^ Applicative::ZipList.new(array2)).list.to_a
        end

        let(:plus) { lambda { |x, y| x + y } }
        let(:mult) { lambda { |x, y| x * y } }

        let(:functions) { [plus, mult] }
        let(:array1) { [1, 2] }
        let(:array2) { [10, 20] }

        it { is_expected.to eq([11, 40]) }

        context "when applying two pure lists" do
          subject do
            (Applicative::ZipList::pure(plus) ^ Applicative::ZipList::pure(2) ^ Applicative::ZipList.new(array2)).list.eager.to_a
          end

          it { is_expected.to eq([12, 22]) }
        end
      end
    end
  end
end
