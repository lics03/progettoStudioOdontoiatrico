class User < ActiveRecord::Base

    before_save { self.email = email.downcase }

    validates :nome,  presence: true, length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_CODICE_FISCALE_REGEX = /\A^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$\z/
    


    #has_many :visite ,dependent: :destroy
    validates :nome,  presence: true , length: { maximum:20 , minimum: 2 }
    validates :cognome,  presence: true, length: { maximum:20 , minimum: 2 }
    validates :codice_fiscale, presence: true, length: {is: 16}, 
                    format: { with: VALID_CODICE_FISCALE_REGEX }
    validates :sesso,  presence: true
    validates :data_nascita,  presence: true
    validates :nazione_nascita,  presence: true
    validates :luogo_nascita,  presence: true, length: { maximum:60}
    validates :nazione_residenza,  presence: true
    validates :citta_residenza,  presence: true, length: { maximum:60 }
    validates :indirizzo,  presence: true, length: { maximum:60 , minimum: 7 }
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    validates :numero_telefono, presence: true

    #validates :terms_of_service, acceptance: { message: 'devi accettare termini e condizioni' }

    has_secure_password
    validates :password, length: { minimum: 6 }
end
