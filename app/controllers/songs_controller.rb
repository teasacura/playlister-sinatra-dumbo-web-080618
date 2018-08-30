require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all

    erb :'songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all

    erb :'/songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :'songs/show'
  end

  post '/songs' do
    @artist = Artist.find_or_create_by(name: params[:song][:artist_name])
    @song = Song.create(name: params[:song][:name], artist: @artist)
    @genres = params[:genres].map do |id|
      @song.genres << Genre.find(id)
    end
    # @song.genres = params[:genres]
    # @song.save
    # binding.pry
    flash[:message] = "Successfully created song."

    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug/edit' do
    @genres = Genre.all
    @song = Song.find_by_slug(params[:slug])

    erb :'songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.update(name: params[:song][:name])
    @genres = params[:genres].map do |id|
       Genre.find(id)
    end
    @song.genres = @genres
    @artist = Artist.find_or_create_by(name: params[:song][:artist_name])
    @song.artist = @artist
    @song.save
    # binding.pry
    # @song.update(name: params[:song][:name], artist: @artist)

    flash[:message] = "Successfully updated song."
    redirect to "/songs/#{@song.slug}"
  end

end
