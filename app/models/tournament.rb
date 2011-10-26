class Tournament < ActiveRecord::Base
  def import_xlog!(xlog, game_args={})
    Game.import_xlog!(xlog, game_args.merge(:tournament_id => self.id))
  end
end
