class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise  :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable, 
            :omniauthable, omniauth_providers: %i[google_oauth2]

    attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_email
    before_create :create_activation_digest


    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_CODICE_FISCALE_REGEX = /\A^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$\z/
    VALID_PHONE_REGEX =/\A\d{10}\z/


    has_many :visits, dependent: :destroy

    
    # validates :nome,  presence: true , length: { maximum:20 , minimum: 2 }
    # validates :cognome,  presence: true, length: { maximum:20 , minimum: 2 }
    # validates :codice_fiscale, presence: true, length: {is: 16}, 
    #                 format: { with: VALID_CODICE_FISCALE_REGEX }
    # validates :sesso,  presence: true
    # validates :data_nascita,  presence: true
    # validates :nazione_nascita,  presence: true
    # #validates :regione, presence: true
    # validates :luogo_nascita,  presence: true, length: { maximum:60 }
    # validates :nazione_residenza,  presence: true
    # #validates :regione_residenza, presence: true
    # validates :citta_residenza,  presence: true, length: { maximum:60 }
    # validates :indirizzo,  presence: true, length: { maximum:60 }
    # validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
    #                 uniqueness: { case_sensitive: false }
    # validates :numero_telefono, presence: true, 
    #                 format: { with: VALID_PHONE_REGEX }

    # #validates :terms_of_service, acceptance: { message: 'devi accettare termini e condizioni' }

    # #has_secure_password
    # validates :password, length: { minimum: 6 }

    # Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    
    # Returns a random token.
    def User.new_token
      SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    # Forgets a user.
    def forget
      update_attribute(:remember_digest, nil)
    end
    

    # Activates an account.
    def activate
      update_attribute(:activated,    true)
      update_attribute(:activated_at, Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    # Sets the password reset attributes.
    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest,  User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Sends password reset email.
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    # Returns true if a password reset has expired.
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end




    private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def self.from_omniauth(auth)
      # Either create a User record or update it based on the provider (Google) and the UID
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.token = auth.credentials.token
        user.expires = auth.credentials.expires
        user.expires_at = auth.credentials.expires_at
        user.refresh_token = auth.credentials.refresh_token
        user.token = auth.credentials.token
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.save!
      end
    end

    def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.google_data"] && session["devise.google_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    # def self.find_for_google_oauth2(auth)
    #   user = User.where(provider: auth.provider, uid: auth.uid).first_or_create(
    #     provider: auth.provider,
    #     uid: auth.uid,
    #     email: auth.info.email,
    #     password: Devise.friendly_token[0,20]
    #   )
    #   user.token = auth.credentials.token
    #   user.refresh_token = auth.credentials.refresh_token
    #   user.save
    #   user
    # end
end
