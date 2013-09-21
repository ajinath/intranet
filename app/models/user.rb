class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]
  ROLES = ['Admin', 'Manager', 'HR', 'Employee']
  ## Database authenticatable
  field :email,               :type => String, :default => ""
  field :encrypted_password,  :type => String, :default => ""
  field :role,                :type => String, :default => ""
  field :uid,                 :type => String
  field :provider,            :type => String        

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  embeds_one :public_profile
  embeds_one :private_profile

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  
  #validates :first_name, presence: true, on: :update
  #validates :last_name, presence: true, on: :update
  #validates :gender, presence: true, on: :update
  #validates :current_password, length: { is: 5 }, allow_blank: true

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    unless user
      user = User.create(provider: auth.provider, uid: auth.uid, email: auth.info.email, first_name: auth.info.first_name,
                         last_name: auth.info.last_name, password: Devise.friendly_token[0,20])
    else
      user.update_attributes(provider: auth.provider, uid: auth.uid, first_name: auth.info.first_name, last_name: auth.info.last_name)
    end
    user
  end

  def role?(role)
    self.role == role
  end
end
