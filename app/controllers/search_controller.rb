require 'itunes-search-api'

class SearchController < ApplicationController
  before_action :authenticate_user,{only:[:new,:delete]}

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
      redirect_to("/")
      return
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
    @favoSong = Song.all
    @countArtist = Song.select(:artistName).distinct
    @artistsAndSongs = {}
    @countArtist.each do |artist|
        @songs = Song.where(artistName: artist.artistName)
        @artistsAndSongs.store(artist.artistName,@songs)
    end
  end

  def new
    trackId = params[:trackId]
    collectionId = params[:collectionId]
    artistName = params[:artistName]
    collectionName = params[:collectionName]
    trackName = params[:trackName]
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
    redirect_to("/")
  end
end
