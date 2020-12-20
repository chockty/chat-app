require 'rails_helper'

RSpec.describe Room, type: :model do
  before do
    @room = FactoryBot.build(:room)
  end
  it "nameがあると作成できる" do
    expect(@room).to be_valid
  end
  it "nameが無いと作成できない" do
    @room.name = nil
    @room.valid?
    expect(@room.errors.full_messages).to include("Name can't be blank")
  end
end
