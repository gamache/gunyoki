class Game < ActiveRecord::Base
  belongs_to :player
  has_many :clans, :through => :player



  ## NB: adding more validations here will require extra effort below,
  ## in self.import_xlog!
  validates_uniqueness_of :reported_game_id, :scope => :tournament_id

  #### CACHING STUFF

  def self.cache_key(id); "game-#{id}" end
  def cache_key; self.class.cache_key(self.id) end

  if Gunyoki::Application.config.action_controller.perform_caching
    ## Return true if this game might not yet be in the db.
    ## (In reality, we're just checking the cache)
    def might_not_exist?
      Rails.cache.read(self.cache_key) ? false : true
    end

    def save
      rv = super
      Rails.cache.write(self.cache_key, self) if rv
      rv
    end

    def save!
      rv = super
      Rails.cache.write(self.cache_key, self) # no 'if rv' needed
      rv
    end

    def self.find_by_id(id)
      Rails.cache.fetch(self.cache_key(id)) {super}
    end

    def player
      return nil unless self.player_id
      Player.find_by_id(self.player_id)
    end

  else # no caching
    def might_not_exist?; true end
  end


  #### XLOG STUFF

  def self.import_xlog!(xlog, game_args={})
    File.open(xlog, 'r') do |fh|
      ## don't need to wrap this in a transaction -- partial imports are fine
      fh.each_with_index do |l,i|
        begin
          g = Game.save_from_xlog_line!(l, game_args)
        rescue ActiveRecord::RecordInvalid => e
          ## do nothing -- this indicates a duplicate record, which is ok
        end
      end
    end
  end

  def self.save_from_xlog_line!(line, game_args={})
    g = Game.from_xlog_line(line, game_args)

    ## Assign, or create+assign a Player if none specified
    if !g.player_id && g.player_name
      p = Player.find_by_name(g.player_name)
      unless p
        p = Player.new(:name => g.player_name)
        p.save!
      end
      g.player_id = p.id
    end

    begin
      g.save! if g.might_not_exist?
    rescue ActiveRecord::RecordInvalid => e
      ## do nothing -- this indicates a duplicate record, which is ok
    end
  end

  def self.from_xlog_line(line, game_args={})
    match = line.match(/^(\d\S+)\s+(.+)$/)
    return nil unless match
    id, fields = match[1..2]
    field_hash = fields.scan(/([^=:]+)=([^=:]*)/).
                        inject({}){|hsh,pair| hsh.merge(pair[0] => pair[1])}
    return Game.from_xlog_hash(field_hash.merge('id' => id), game_args)
  end

  def self.save_from_xlog_hash!(hsh, game_args={})
    g = from_xlog_hash(hsh, game_args)

  end

  def self.from_xlog_hash(hsh, game_args={})
    g = Game.new(game_args)
    { :reported_game_id => :id,
      :score => :points,
      :player_name => :name,
      :role => :role,
      :race => :race,
      :start_gender => :gender0,
      :start_alignment => :align0,
      :end_gender => :gender,
      :end_alignment => :align,
      :end_level => :deathlev,
      :max_level => :maxlev,
      :end_dungeon => :deathdnum,
      :end_hp => :hp,
      :max_hp => :maxhp,
      :deaths => :deaths,
      :end_msg => :death,
      :turns => :turns,
      :seconds_played => :realtime }.each do |game_field, hash_key|
      g.send("#{game_field}=", hsh[hash_key.to_s])
    end

    g.started_at = Time.at(hsh['starttime'].to_i)
    g.ended_at   = Time.at(hsh['endtime'].to_i)

    return g.apply_achievements(hsh['achieve'].hex).
             apply_conducts(hsh['conduct'].hex)
  end

  def achievements_hash(ach_bitfield=nil)
    ach_bitfield ||= self.achievements
    unpack_bitfield(ach_bitfield,
                     %w{ got_bell
                         entered_gehennom
                         got_candelabrum
                         got_book
                         did_invocation
                         got_amulet
                         reached_elemental
                         reached_astral
                         ascended
                         did_mines
                         did_sokoban
                         killed_medusa })
  end

  def apply_achievements(ach_bitfield)
    self.achievements = ach_bitfield
    self.achievements_hash.each {|k,v| self.send("#{k}=", v)}
    self
  end

  def conducts_hash(cnd_bitfield=nil)
    cnd_bitfield ||= self.conducts
    unpack_bitfield(cnd_bitfield,
                     %w{ foodless
                         vegan
                         vegetarian
                         atheist
                         weaponless
                         pacifist
                         illiterate
                         polypileless
                         polyselfless
                         wishless
                         artifact_wishless
                         genocideless })
  end


  def apply_conducts(cnd_bitfield)
    self.conducts = cnd_bitfield
    self.conducts_hash.each {|k,v| self.send("#{k}=", v)}
    self
  end

private

  ## field_names go from LSB to MSB
  def self.unpack_bitfield(bitfield, field_names)
    hsh = {}
    field_names.each_with_index do |field, shift|
      hsh[field] = bitfield & (1 << shift) != 0
    end
    hsh
  end
  def unpack_bitfield(*args); self.class.unpack_bitfield(*args) end

end
