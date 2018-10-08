require 'oystercard'
require 'pry'
require 'station'

describe Oystercard do
  let(:station) { double :station }
  before :each do
    @oyster = Oystercard.new
  end

  it "starts with a balance of 0" do
    expect(@oyster.balance).to eq(0)
  end

  it 'can be topped up' do
    @oyster.topup(15)
    expect(@oyster.balance).to eq 15
  end

  it 'cannot store a balance above £90' do
    expect { @oyster.topup(91) }.to raise_error "Cannot topup £91: maximum balance of £#{Oystercard::MAXIMUM_BALANCE}"
  end

  # it 'will deduct a fare' do
  #   @oyster.topup(10)
  #   @oyster.deduct(5)
  #   expect(@oyster.balance).to eq (5)
  # end

  it 'can touch in at the beginning of a journey' do
    @oyster.topup(10)
    expect(@oyster.touch_in(station)).to eq(station)
  end

  it 'can touch out at the end of a journey' do
    expect(@oyster.touch_out).to eq(nil)
  end

  it 'knows when the user is in transit' do
    @oyster.topup(10)
    @oyster.touch_in(station)
    expect(@oyster).to be_in_journey
  end

  it 'does not allow user to touch in if balance is below minimum' do
    expect{ @oyster.touch_in(station) }.to raise_error 'Insufficient funds'
  end

  it 'charges the user £1 on touching out' do
    @oyster.topup(10)
    @oyster.touch_in(station)
    expect { @oyster.touch_out }.to change { @oyster.balance }.by(-Oystercard::MINIMUM_FARE)
  end

  it 'keeps a record of the starting station' do
    @oyster.topup(10)
    @oyster.touch_in(station)
    expect(@oyster.start_station).to eq(station)
  end

  it 'forgets entry station on touch out' do
    @oyster.topup(10)
    @oyster.touch_in(station)
    @oyster.touch_out
    expect(@oyster.start_station).to be_nil
  end

end
