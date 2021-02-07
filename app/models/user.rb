class User < ApplicationRecord
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :confirmable, :lockable, :timeoutable, :trackable #, :omniauthable
  # Associations 
  has_one_attached :avatar, dependent: :destroy
  has_many :comments, foreign_key: :commenter_id, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :attended_events, through: :participations, source: :event, dependent: :destroy
  has_many :administrated_events, foreign_key: "administrator_id", class_name: "Event", dependent: :destroy
  # Validations
  validates :username,
    presence: true,
    uniqueness: true
  # validates :first_name, :last_name,
  #   presence: true,
  #   on: :update
  # validates :description,
  #   presence: true,
  #   length: { minimum: 5 },
  #   on: :update

  # Callbacks
  after_create :welcome_send
  after_commit :add_default_avatar, on: [:update]
  
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  def avatar_thumbnail
    avatar.variant(resize: "150x150!").processed
  end

  # Extends devise authentication keys: email OR username are possible as authentication keys.
  # Extends Devise to query via warden. This uses some SQL to query for either 
  # the username or email fields given one or the other is supplied during form submission. 
  def self.find_for_database_authentication warden_condition
    conditions = warden_condition.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ["lower(username) = :value OR lower(email) = :value",
      { value: login.strip.downcase }]).first
  end

  private 

  def add_default_avatar
    unless avatar.attached? 
      avatar.attach(
        io: File.open(
          Rails.root.join(
            "app", "assets", "images", "default-avatar.png"
          )
        ), filename: "default-avatar.png",
        content_type: "image/png"
      )
    end
  end

end
