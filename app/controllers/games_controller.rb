class GamesController < ApplicationController
  respond_to :html, :json

  def index
    if params[:player_id]
      @player = Player.find_by_name(params[:player_id])
      @games = @player.games
    elsif params[:tournament_id]
      @tournament = Tournament.find_by_name(params[:tournament_id])
      @games = @tournament.games
    else
      @games = [] # don't load ALL games
    end
    respond_with(@games)
  end

  def show
    respond_with(@game = Game.find_by_id(params[:id]))
  end

  def create
    @game = Game.create(params[:game] || params)
    respond_with(@game, :location => :games_url)
  end

end
