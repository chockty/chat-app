require 'rails_helper'

RSpec.describe "ユーザログイン機能", type: :system do
  it "ログインしていない状態でトップページへアクセスするとサインインのページへ遷移する" do
    #トップページへアクセスする
    visit root_path
    #サインインの画面になっている
    expect(current_path).to eq new_user_session_path
  end
  it "ログインに成功してトップページへ遷移する" do
    #ユーザをDBへ保存する（FactoryBot）
    @user = FactoryBot.create(:user)
    #サインインページへアクセスする
    visit root_path
    #ログインしていない場合、サインインページへ遷移していることを確認する（どこか任意のページに飛ぶように設定する？）
    expect(current_path).to eq new_user_session_path
    #email/passwordを入力する。
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    #サインインのボタンをクリックする
    find('input[name="commit"]').click
    #★click_on("Log in") でもOK
    #トップページへ遷移していることを確認する。
    expect(current_path).to eq root_path
  end
  it "ログインに失敗してサインインページへ再度遷移する" do
    #ユーザをDBへ保存する（FactoryBot）
    @user = FactoryBot.create(:user)
    #サインインページへアクセスする
    visit root_path
    #ログインしていない場合、サインインページへ遷移する（どこか任意のページに飛ぶように設定する？）
    expect(current_path).to eq new_user_session_path
    #email/passwordを入力する。（誤った情報で）
    fill_in "user_email", with: "aaaalllll@jjjjjj"
    fill_in "user_password", with: "loremipsmjjj"
    #サインインのボタンをクリックする
    find('input[name="commit"]').click
    #★click_on("Log in") でもOK
    #サインインページへ戻っていることを確認する（入力した情報はそのままになっていることを確認）
    expect(current_path).to eq new_user_session_path
  end
end
