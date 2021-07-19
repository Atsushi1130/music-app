require 'itunes-search-api'

class SearchController < ApplicationController
  def search
    @searchs = ITunesSearchAPI.search(
      :term => params[:term],
      :country => 'jp',
      :media => 'music',
      :lang => 'ja_jp',
      :limit => '10',
    )
  end

  def init
  end
end
