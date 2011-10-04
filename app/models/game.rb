class Game < ActiveRecord::Base

  def self.from_xlogfile_line(line)
    match = line.match(/^(\d\S+)\s+(.+)$/)
    return nil unless match
    id, fields = match[1..2]
    field_hash = fields.scan(/([^=:]+)=([^=:]*)/).
                        inject({}){|hsh,pair| hsh.merge(pair[0] => pair[1])}
    return Game.from_xlogfile_hash(field_hash.merge(:id => id))
  end

  def self.from_xlogfile_hash(hsh)
    g = Game.new
    { :id => :id,
      :score => :points,
      :player_name => :name,
      :role => :role,
      :race => :race,
      :gender => :gender0,
      :alignment => :align0,
      :end_gender => :gender,
      :end_alignment => :align,
      :end_level => :deathlev,
      :max_level => :maxlev,
      :end_hp => :hp,
      :max_hp => :maxhp,
      :deaths => :deaths,
      :end_msg => :death,
      :turns => :turns,
      :seconds_played => :realtime }.each do |game_field, hash_key|
      g.send("#{game_field}=", hsh[hash_key.to_s])
    end

    g.start_time = Time.at(hsh['starttime'].to_i)
    g.end_time   = Time.at(hsh['endtime'].to_i)

    return g.apply_achievements(hsh['achieve'].hex).
             apply_conducts(hsh['conduct'].hex)
  end

  def apply_achievements(ach_bitfield)
    self.achievements = ach_bitfield
    ach_hash = unpack_bitfield(ach_bitfield,
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
    ach_hash.each {|k,v| self.send("#{k}=", v)}
    self
  end

  def apply_conducts(cnd_bitfield)
    self.conducts = cnd_bitfield
    cnd_hash = unpack_bitfield(cnd_bitfield,
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
    cnd_hash.each {|k,v| self.send("#{k}=", v)}
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
