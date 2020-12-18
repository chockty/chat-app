class UsersController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to(root_path)
    else 
      render(:edit)
      #renderでアクションを定義するのは上記のやり方
    end
    #current_user = 「user = User.find(params[:id])」
    #モデルオブジェクト（テーブルから取得した情報を基に、Userクラスのnewメソッドで、生成されたインスタンス）
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
