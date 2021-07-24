require 'itunes-search-api'

class SearchController < ApplicationController
  before_action :authenticate_user,{only:[:new,:delete,]}
  before_action :forbid_login_user,{only:[:init]}

  def test
    @favoSong = Song.all
    @countArtist = Song.select(:artistName).distinct
    @artistsAndSongs = {}
    @countArtist.each do |artist|
        @songs = Song.where(artistName: artist.artistName)
        @artistsAndSongs.store(artist.artistName,@songs)
    end
  end

  def search
    @term = params[:term]
    if @term == ""
      flash[:notice] = "検索ワードを入力してください"
      if @current_user
        redirect_to("/user/#{@current_user.id}/show")
        return
      else
        redirect_to("/")
        return
      end
    end
    @searchs = ITunesSearchAPI.search(
      :term => params[:term],
      :country => 'jp',
      :media => 'music',
      :lang => 'ja_jp',
    )
    @pages = Kaminari.paginate_array(@searchs).page(params[:page]).per(10)
  end

  def init
    if @current_user
      @countArtist = Song.where(user_id: @current_user.id).select(:artistName).distinct
    end
  end

  def new
    trackId = params[:trackId]
    collectionId = params[:collectionId]
    if params[:artistName].include? "11112222"
      artistName = params[:artistName].gsub!("11112222",".")
    else
      artistName = params[:artistName]
    end
    if params[:collectionName].include? "11112222"
      collectionName = params[:collectionName].gsub!("11112222",".")
    else
      collectionName = params[:collectionName]
    end
    if params[:trackName].include? "11112222"
      trackName = params[:trackName].gsub!("11112222",".")
    else
      trackName = params[:trackName]
    end
    userId = @current_user.id
    if Song.where(user_id: @current_user.id).find_by(trackId: trackId)
      flash[:notice] = "「"+trackName+"」"+"は既にお気に入り登録されています。"
      redirect_to("/user/#{@current_user.id}/show")
      return
    end
    favoSong = Song.new(
      trackId: trackId,
      collectionId: collectionId,
      artistName: artistName,
      collectionName: collectionName,
      trackName: trackName,
      user_id: userId,
    )
    if favoSong.save
      flash[:notice] = "「"+favoSong.trackName+"」" + "をお気に入りに追加しました。"
      redirect_to("/user/#{@current_user.id}/show")
    end
  end

  def delete
    @song = Song.find_by(trackId: params[:trackId])
    @song.destroy
    flash[:notice] = "削除が完了しました。"
    redirect_to("/user/#{@current_user.id}/show")
  end
end
