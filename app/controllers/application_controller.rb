class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  #ログインしているかしていないか全てのアクションの実行前で判断できる。ログインされていない場合は、ログイン画面に自動的に遷移するようになっている（deviseの仕様）
  before_action :configure_permitted_parameters, if: :devise_controller?
  #devise関連のコントローラが呼ばれた時、before_actionを使用する。
  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    #ストロングパラメータの一種。不要なデータを取り扱いできないように設定する。
  end
end
