require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Example User", email:"user@example.com",
            password:"foobar", password_confirmation:"foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  #Userオブジェクトが空だと有効でないことを確認するテスト
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  #メールアドレスが空だと有効でないことを確認するテスト
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  #名前の長さのテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #メールアドレスの長さのテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  #有効なメールフォーマットを確認するテスト
  test "email validation should accept valid adresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                 first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  #有効でないメールフォーマットを確認するテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                  foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #重複するメールアドレス拒否のテスト
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #メールアドレスの小文字化に対するテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #パスワードがあることのテスト
  test "password should be present(nonblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  #パスワードの最小文字数のテスト
  test "password should have a minimum lingth" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  #ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?("")
  end

  #dependent: :destroyのテスト
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content:"Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy 
    end
  end

  # "following"関連のメソッドをテストする
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end
