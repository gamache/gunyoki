class PlayersController < ApplicationController
  respond_to :html, :json

  before_filter :load_player, :only => [:show, :games]

  def index
    respond_with(@players = Player.all)
  end

  def show
    respond_with(@player)
  end

  def create
    @player = Player.create(params[:player] || params)
    respond_with(@player, :location => players_url)
  end

  def games
    respond_with(@games = @player.games)
  end

  def as_json(opts={})
    super(opts.merge(:except => %w(salt sha512_password)))
  end

private

  def load_player
    @player = Player.find_by_name(params[:player_id] || params[:id])
  end

end
