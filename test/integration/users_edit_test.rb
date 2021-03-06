require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  #編集の失敗に対するテスト
  test "unsuccessful edit" do
    log_in_as(@user) #テストユーザーでログインする
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "",
                             email: "foo@invalid",
                             password:           "foo",
                             password_confirmation: "bar"}}
    assert_template 'users/edit'
  end

  #編集の成功(フレンドリーフォワーディング)テスト
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user) #テストユーザーでログインする
    assert_nil session[:forwarding_url]   # forwarding_urlの値がnilならtrue(deleteが効いてる)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user:{ name: name,
                             email: email,
                             password: "",
                             password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
