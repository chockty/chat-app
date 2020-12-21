require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end
  context "投稿に失敗する場合" do
    it "送信する値が空欄のため、送信に失敗する" do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームを選択し遷移する。
      click_on(@room_user.room.name)
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #DBに保存されていないことを確認する
      expect{find('input[name="commit"]').click}.not_to change{Message.count}
      #★「not_to」は「〜でない」という形で以降の条件を否定する。
      #元のページに戻ってくることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room.id)
    end
  end
  context "投稿に成功する場合" do
    it "テキストを投稿した場合、投稿したテキストが一覧に表示されている" do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームを選択し遷移する。
      click_on(@room_user.room.name)
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #値をフォームに入力する
      fill_in "message_content", with: "test_post"
      #送信した値がDBに保存されていることを確認する
      expect{find('input[name="commit"]').click}.to change{Message.count}.by(1)
      #★「change{@room_user.room.messages.count}」という形でもOK。作成されたルームに属するメッセージという形になる。
      #投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #投稿したテキストが投稿一覧画面に表示されていることを確認する
      expect(page).to have_content("test_post")
    end
    it "画像を投稿した場合、投稿した画像が一覧に表示されている" do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームを選択し遷移する。
      click_on(@room_user.room.name)
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      #画像を添付する
      attach_file("message[image]", image_path, make_visible: true)
      #送信した値がDBに保存されていることを確認する
      expect{find('input[name="commit"]').click}.to change{Message.count}.by(1) 
      #投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #投稿した画像が投稿一覧画面に表示されていることを確認する
      expect(page).to have_selector("img")
    end
    it "テキストと画像を投稿した場合、投稿した物が一覧に表示されている" do
      #サインインする
      sign_in(@room_user.user)
      #作成されたチャットルームを選択し遷移する。
      click_on(@room_user.room.name)
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      #画像を添付する
      attach_file("message[image]", image_path, make_visible: true)
      #値をフォームに入力する
      fill_in "message_content", with: "test_post"
      #送信した値がDBに保存されていることを確認する
      expect{find('input[name="commit"]').click}.to change{@room_user.room.messages.count}.by(1)
      #投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room.id)
      #投稿したテキストが投稿一覧画面に表示されていることを確認する
      expect(page).to have_content("test_post")
      #投稿した画像が投稿一覧画面に表示されていることを確認する
      expect(page).to have_selector("img")
    end
  end
end

RSpec.describe "メッセージ削除機能", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end
  it "チャットルームを削除すると関連するメッセージが全て消去される" do
    #サインインする
    sign_in(@room_user.user)
    #作成されたチャットルームを選択し遷移する。
    click_on(@room_user.room.name)
    expect(current_path).to eq room_messages_path(@room_user.room.id)
    #メッセージ情報を5つDBへ保存する
    FactoryBot.create_list(:message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id)
    #チャットルームを削除し作成したメッセージが消去されていることを確認する
    expect{find_link("チャットを終了する", href: room_path(@room_user.room.id)).click}.to change{@room_user.room.messages.count}.by(-5) 
    #トップページへ遷移していることを確認する
    expect(current_path).to eq root_path
  end
end