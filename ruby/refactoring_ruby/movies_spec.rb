require_relative './movies'

RSpec.describe Movie do
  describe 'getter methods' do
    subject { described_class.new('title', 1234) }

    it 'exposes getter for title' do
      expect(subject.title).to eq 'title'
    end

    it 'exposes getter for price_code' do
      expect(subject.price_code).to eq 1234
    end

    it 'has the right price code for regular' do
      expect(Movie::REGULAR).to eq 0
    end

    it 'has the right price code for regular' do
      expect(Movie::NEW_RELEASE).to eq 1
    end

    it 'has the right price code for regular' do
      expect(Movie::CHILDRENS).to eq 2
    end
  end
end

RSpec.describe Rental do
  subject { described_class.new('Kira', 5) }

  describe 'getter methods' do
    it 'exposes getter for movie' do
      expect(subject.movie).to eq 'Kira'
    end

    it 'exposes getter for days_rented' do
      expect(subject.days_rented).to eq 5
    end
  end
end

RSpec.describe Customer do
  describe 'getters' do
    subject { described_class.new('Kira') }

    it 'exposes getter for name' do
      expect(subject.name).to eq 'Kira'
    end
  end

  describe '#add_rental' do
    subject { described_class.new('Kira') }

    it 'returns the list of rentals' do
      expect(
        subject.add_rental('Das Leben der Anderen')
      ).to eq ['Das Leben der Anderen']
    end

    it 'stores the list of rentals in @rentals' do
      subject.add_rental('Das Leben der Anderen')
      expect(
        subject.add_rental('Captain America')
      ).to eq ['Das Leben der Anderen', 'Captain America']
    end
  end

  describe "#statement" do
    context "no rentals" do
      it "returns a valid statement" do
        customer = described_class.new('Kira')
        expected_statement = "Rental Record for Kira\nAmount owed is 0\nYou earned 0 frequent renter points"
        expect(customer.statement).to eq expected_statement
      end
    end

    context "with rentals" do
      it "returns a valid statement" do
        freedom_writers = Movie.new('Freedom Writers', 0)
        lives_of_others = Movie.new('Das Leben der Anderen', 1)

        customer = described_class.new('Kira')
        customer.add_rental(Rental.new(freedom_writers, 3))
        customer.add_rental(Rental.new(lives_of_others, 5))

        expected_statement =
          "Rental Record for Kira\n"\
          "\tFreedom Writers\t3.5\n"\
          "\tDas Leben der Anderen\t15\n"\
          "Amount owed is 18.5\n"\
          "You earned 3 frequent renter points"\

        expect(customer.statement).to eq expected_statement
      end
    end
  end
end
