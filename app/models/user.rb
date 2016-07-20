class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


   #campos classificatorios
  field :functional_id,   type: String
  field :name,            type: String
  field :job_role,        type: String
  field :telphone,        type: String
  field :role,            type: String
  field :ug,              type: String
  field :subsecretary,    type: String


  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String


  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  has_many :accountabilities, inverse_of: :user
  #has_many :contracts, inverse_of: :user

  rails_admin do

      navigation_label 'Administrador'

      list do
        field :name
        field :functional_id
        field :telphone
        field :email
      end

      edit do
        field :name, :string
        field :functional_id, :string
        field :job_role, :string
        field :telphone, :string
        field :email, :string
        field :password, :string
        field :ug
        field :subsecretary
        field :role do
          visible do
            (bindings[:view]._current_user.role == 'NECL' || bindings[:view]._current_user.role == 'Admin')
            end
          end


      end

      show do
        field :name, :string
        field :functional_id, :string
        field :job_role, :string
        field :telphone, :string
        field :email, :string
        field :role
        field :last_sign_in_at
        field :accountabilities
      end

      # object_label_method do
      #   :custom_label_method
      # end

  end

  def role_enum
    [ 'Gerente', 'Subsecretario', 'Fiscal', 'NECL', 'Admin']
  end

  def ug_enum
    Site.pluck(:name)
  end

  def subsecretary_enum
    ['Gabinete Secretario',
     'Subsecretaria de Regulação e de Organização da Atenção a Saúde',
     'Subsecretaria de Gestão Hospitalar',
     'Subsecretaria de Adminstração e de Financiamento da Atenção a Saúde',
     'Subsecretaria de Gestão Estratégica e Inovação']
  end


end
