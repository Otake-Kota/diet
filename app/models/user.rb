class User < ApplicationRecord
    has_many :exercise_histories
    has_many :weights
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/
    validates :name, presence: true
    validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
    validates :height, presence: true
    validates :password, confirmation: true, presence: true, length:{minimum: 8}, format: {with: VALID_PASSWORD_REGEX}
    
    before_create :convert_password
    
    
    def convert_password
        self.password = User.generate_password(self.password)
    end
    
    def self.generate_password(password)
        salt = "h!hgamcRAdh38bajhvgai17ysvb"
        Digest::MD5.hexdigest(salt + password)
    end
end
