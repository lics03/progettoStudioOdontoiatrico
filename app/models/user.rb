class User < ActiveRecord::Base

    attr_accessor :activation_token
    before_save   :downcase_email
    before_create :create_activation_digest

    validates :nome,  presence: true, length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_CODICE_FISCALE_REGEX = /\A^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$\z/
    VALID_PHONE_REGEX =/\A\d{10}\z/


    #has_many :visite ,dependent: :destroy
    validates :nome,  presence: true , length: { maximum:20 , minimum: 2 }
    validates :cognome,  presence: true, length: { maximum:20 , minimum: 2 }
    validates :codice_fiscale, presence: true, length: {is: 16}, 
                    format: { with: VALID_CODICE_FISCALE_REGEX }
    validates :sesso,  presence: true
    validates :data_nascita,  presence: true
    validates :nazione_nascita,  presence: true
    #validates :regione, presence: true
    validates :luogo_nascita,  presence: true, length: { maximum:60 }
    validates :nazione_residenza,  presence: true
    #validates :regione_residenza, presence: true
    validates :citta_residenza,  presence: true, length: { maximum:60 }
    validates :indirizzo,  presence: true, length: { maximum:60 }
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    validates :numero_telefono, presence: true, 
                    format: { with: VALID_PHONE_REGEX }

    #validates :terms_of_service, acceptance: { message: 'devi accettare termini e condizioni' }

    has_secure_password
    validates :password, length: { minimum: 6 }

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

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
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
end
