class Accountability
  include Mongoid::Document
  include Mongoid::History::Trackable
  include Mongoid::Userstamp

  field :ug,                   type: String
  #field :sector,               type: String
  field :document_type,        type: String
  field :lore_date,            type: Date
  field :accountability_type,  type: String
  field :supervisor_change,    type: String
  field :active,               type: Boolean, default: true

  belongs_to :user

  belongs_to :contract, dependent: :destroy, :inverse_of => :accountability

  before_save :update_contract, :check_last


  # Auditoria
  track_history({
    :scope => :contract,
    track_create: true,
    track_destroy: true,
    track_update: true,
    modifier_field: :updater,
    except: ["created_at", "updated_at", "c_at", "u_at", "clicks", "impressions", "some_other_your_field"],
  })
  rails_admin do

      navigation_label 'NECC'

      list do
        field :contract
        field :lore_date
        field :user
        field :ug
        field :active
      end

      edit do

        field :contract do
          inline_edit false
          inline_add false
        end
        field :user do
          inline_edit false
          inline_add false
        end
        field :document_type
        field :lore_date
        field :accountability_type
        field :active
        field :supervisor_change

      end

      show do
        exclude_fields :id, :created_at, :updated_at
      end
      object_label_method do
        :custom_label_method
      end

  end

  def custom_label_method
    if (self.contract)
    "#{self.user.name} - #{self.contract.name} (#{human_boolean(self.active)})"
    else
      ""
    end
  end
  def human_boolean(boolean)
      boolean ? 'Vigente' : 'Histórico'
  end

  def update_contract

    contrato = Contract.where(id: self.contract_id).first
    contrato.user_id = self.user_id
    contrato.save!

  end

  def check_last
    Accountability.where(contract: self.contract).update_all(active: false)
  end


  def accountability_type_enum
    ['Fiscal' ,'Gestor' ,'Vizualizar']
  end

  def document_type_enum
    ['Contrato' ,'Apostilamento' ,'Designação']
  end

  def subsec_enum
    ['Gabinete Secretario',
     'Subsecretaria de Regulação e de Organização da Atenção a Saúde',
     'Subsecretaria de Gestão Hospitalar',
     'Subsecretaria de Adminstração e de Financiamento da Atenção a Saúde',
     'Subsecretaria de Gestão Estratégica e Inovação']
  end

  def ug_enum # Completar a listas de ug
       valor = Site.pluck(:name)
  end

  def document_type_enum
    ['Ato de Designação' ,'Apostilamento' ,'Contrato']
  end

  scope :vigente, -> { where(active: true) }

end
