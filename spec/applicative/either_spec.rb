RSpec.describe Applicative::Either do
  let(:pow2) { lambda { |x| x ** 2 } }

  describe Applicative::Functor do
    describe "fmap" do
      subject { either.fmap(&pow2) }

      context "when value is Left" do
        let(:either) { Left("error") }

        it { is_expected.to eq(either) }
      end

      context "when value is Right" do
        let(:either) { Right(3) }

        it { is_expected.to eq(Right(9)) }
      end
    end
  end

  describe Applicative::ApplicativeFunctor do
    describe "pure" do
      subject { Applicative::Either::pure(value) }

      let(:value) { 1 }

      it { is_expected.to eq(Right(value)) }
    end

    describe "^" do
      subject { first ^ second }
      context "when first object is Left" do
        let(:first) { Left("error") }
        let(:second) { nil }

        it { is_expected.to eq(first) }
      end

      context "when first object is Right" do
        let(:first) { Right(pow2) }

        context "when first object is Left" do
          let(:second) { Left("error") }

          it { is_expected.to eq(second) }
        end

        context "when first object is Right" do
          let(:second) { Right(12) }

          it { is_expected.to eq(Right(144)) }
        end
      end
    end
  end
end
