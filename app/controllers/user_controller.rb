class UserController < ApplicationController
  before_action :forbid_login_user,{only:[:new,:create,:login_form,:login]}
  before_action :ensure_correct_user,{only:[:show,:edit,:update]}

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザ登録が完了しました。"
      redirect_to("/user/#{@user.id}/show")
    else
      render("user/new.html.erb")
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email],password: params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインに成功しました。"
      redirect_to("/user/#{@user.id}/show")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("user/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。"
    redirect_to("/")
  end

  def show
    @countArtist = Song.where(user_id: params[:id]).select(:artistName).distinct
    @artistsAndSongs = {}
    @countArtist.each do |artist|
        @songs = Song.where(artistName: artist.artistName)
        @artistsAndSongs.store(artist.artistName,@songs)
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/user/#{@current_user.id}/show")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]
    if @user.save
      redirect_to("/user/#{@user.id}/show")
    else
      render("user/edit.html.erb")
    end
  end

end
