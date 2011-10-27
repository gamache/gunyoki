require 'digest'

class Player < ActiveRecord::Base
  has_many :games
  has_many :clans, :through => :clans_players

  before_save :encrypt_password
  attr_accessor :password
  def encrypt_password
    if self.password.to_s != ''
      self.salt ||= sprintf "%.8x%.8x", rand(0xffffffff), rand(0xffffffff)
      self.sha512_password = Digest::SHA512.hexdigest(self.sha512_plaintext)
    end
  end

  ## returns nil upon no authentication, Player object otherwise
  def self.find_by_name_and_password(player_name, password)
    return nil unless player = Player.find_by_name(player_name)
    player.authenticate(password)
  end

  ## returns nil if the password is incorrect, self otherwise
  def authenticate(password)
    return self if self.sha512_password ==
                     Digest::SHA512.hexdigest(self.sha512_plaintext(password))
    return nil
  end

  ## returns the plaintext based on password and salt,
  ## to pass to Digest::SHA512.hexdigest
  def sha512_plaintext(password=nil, salt=nil)
    password ||= self.password
    salt ||= self.salt
    salt.to_s + password.to_s
  end


  def as_json(opts={})
    super(opts.merge(:except => %w(salt sha512_password)))
  end


  #### CACHING STUFF

  def self.cache_key(id); "player-#{id}" end
  def cache_key; self.class.cache_key(self.id) end

  def self.name_key(name); "id-of-player-named-#{name}" end
  def name_key; self.class.name_key(self.name) end

  if Gunyoki::Application.config.action_controller.perform_caching
    def might_not_exist?
      Rails.cache.read(self.cache_key) ? false : true
    end

    def save
      rv = super
      if rv
        Rails.cache.write(self.cache_key, self)
        Rails.cache.write(self.name_key, self.id)
      end
      rv
    end

    def save!
      rv = super
      if rv
        Rails.cache.write(self.cache_key, self)
        Rails.cache.write(self.name_key, self.id)
      end
      rv
    end

    def self.find_by_id(id)
      Rails.cache.fetch(self.cache_key(id)) {super}
    end

    def self.find_by_name(name)
      id = Rails.cache.read("id-of-player-named-#{name}")
      return find_by_id(id) if id

      p = super
      if p
        Rails.cache.write(p.cache_key, p)
        Rails.cache.write(p.name_key, p.id)
      end
      p
    end

    def games
      self.game_ids.map{|gid| Game.find_by_id(gid)}
    end

  else # no caching
    def might_not_exist?; true end
  end

end
