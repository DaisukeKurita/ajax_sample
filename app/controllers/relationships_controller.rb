class RelationshipsController < ApplicationController

  respond_to? :js
  def create
    if logged_in?
      # _follow_form.htmlからきた、idを@userに代入
      @user = User.find(params[:relationship][:followed_id])
      # 指定のユーザーをフォローする
      current_user.follow!(@user)
      # respond_to? :jsでcreate.jsに飛ばし、Ajaxで切り替える
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
  end
end
