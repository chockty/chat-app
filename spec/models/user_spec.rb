require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#create" do
    before do
      @user = FactoryBot.build(:user)
    end
    it "name,email,passwordとpassword_confirmationが一致している、ならユーザ登録ができる。" do
      expect(@user).to be_valid
    end
    it "nameが空では登録できないこと" do
      @user.name = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Name can't be blank")
    end
    it "emailが空では登録できないこと" do
      @user.email = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end
    it "passwordが空では登録できないこと" do
      @user.password = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    it "passwordが6文字以上なら登録できること" do
      @user.password = "123456"
      @user.password_confirmation = "123456"
      expect(@user).to be_valid
    end
    it "passwordが5文字以下なら登録できないこと" do
      @user.password = "12345"
      @user.password_confirmation = "12345"
      #password_confirmation も同じ値を入れてテストしないと厳密性が担保できない。
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end
    it "passwordとpasswaord_confirmationが不一致の場合登録できないこと" do
      @user.password = "1234567"
      @user.password_confirmation = "ansidmt"
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    it "既に存在するemailでは登録できない" do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors.full_messages).to include("Email has already been taken")
    end
  end
end
