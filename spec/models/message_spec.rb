require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @message = FactoryBot.build(:message)
  end
  context "メッセージが投稿できる場合" do
    it "contentとiamgeが入力されていると投稿できる" do
      expect(@message).to be_valid
    end
    it "contentのみでも投稿できる" do
      @message.image = nil
      expect(@message).to be_valid
    end
    it "imageのみでも投稿できる" do
      @message.content = nil
      expect(@message).to be_valid
    end
  end
  context "メッセージが投稿できない場合" do
    it "contentもimageもない場合は投稿できない" do
      @message.content = nil
      @message.image = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("Content can't be blank")
    end
    it "roomと紐づいていないと投稿できない" do
      @message.user = nil
      #ここでuser.idをnilにしてもvalidはtrueとして通ってしまう。
      @message.valid?
      expect(@message.errors.full_messages).to include("User must exist")
    end
    it "userと紐づいていないと投稿できない" do
      @message.room = nil
      @message.valid?
      expect(@message.errors.full_messages).to include("Room must exist")
    end
  end
end
