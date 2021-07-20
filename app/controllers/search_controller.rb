require 'itunes-search-api'

class SearchController < ApplicationController
  def search
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
  end

  def new
    trackId = params[:trackId]
    collectionId = params[:collectionId]
    artistName = params[:artistName]
    collectionName = params[:collectionName]
    trackName = params[:trackName]
    favoSong = Song.new(
      trackId: trackId,
      collectionId: collectionId,
      artistName: artistName,
      collectionName: collectionName,
      trackName: trackName,
    )
    if favoSong.save
      redirect_to("/")
    end
  end
end
