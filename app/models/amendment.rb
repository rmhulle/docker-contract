class Amendment
  include Mongoid::Document
  include Mongoid::History::Trackable
  include Mongoid::Userstamp




  field :name, type: String
  field :amendment_type, type: String # Tipo de Aditivo
  field :publication_date, type: Date # Data de Publicação

  # Dotação Orçamentárias

  field :activity, type: String # Atividade
  field :expense_item, type: String # Item de Despesa
  field :federal_account_source, type: String # Fonte de Despesa Federal
  field :state_account_source, type: String # Fonte de Despesa Estadual
  field :other_account_source, type: String # Fonte de Despesa

  field :object, type: String # Objeto do Aditivo
  field :process_number, type: String # Número do processo de aditivo

  field :amendment_value, type: Money, default: 0

  field :start_date, type: Date  #vigencia inicio
  field :finish_date, type: Date #vigencia fim

  field :observation, type: String # Observações

  belongs_to :contract


  track_history({
    :scope => :contract,
    track_create: true,
    track_destroy: true,
    track_update: true,
    modifier_field: :updater,
    except: ["created_at", "updated_at", "c_at", "u_at", "clicks", "impressions", "some_other_your_field"],
  })
  # validates :name, presence: true
  # validates :amendment_type, presence: true
  # validates :publication_date, presence: true
  #
  # validates :activity, presence: true
  # validates :expense_item, presence: true
  # validates :account_source, presence: true
  #
  # validates :object, presence: true
  # validates :process_number, presence: true
  #
  # validates :amendment_value, presence: true
  #
  # validates :start_date, presence: true
  # validates :finish_date, presence: true

  # validates :observation, presence: true


  before_create :calc_total_value_amendment, :update_finish_date



  rails_admin do

      navigation_label 'Eventos'

      list do
        field :name
        field :contract
        field :amendment_type
        field :publication_date
        field :process_number
      end

      edit do
        field :contract do
          inline_add false
          inline_edit false
        end

        field :name, :string
        field :amendment_type
        field :publication_date

        # Dotação Orçamentárias

        group :dotacao do
          label "Dotação Orçamentária"
          help "Preencha as Informações de Acordo com a Dotação Orçamentária"
          active false
          field :expense_item, :string
          field :federal_account_source, :string
          field :state_account_source, :string
          field :other_account_source, :string
        end

        field :object
        field :process_number, :string

        field :amendment_value, :string do
          formatted_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end

        field :start_date
        field :finish_date

        field :observation

      end

      show do
        field :name
        field :amendment_type
        field :publication_date

        # Dotação Orçamentárias
        field :activity
        field :expense_item
        field :expense_item, :string
        field :federal_account_source, :string
        field :state_account_source, :string
        field :other_account_source, :string

        field :object
        field :process_number

        field :amendment_value do
          pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end
        field :start_date
        field :finish_date

        field :observation


      end

      object_label_method do
         :custom_label_method
      end


  end

  def custom_label_method
    "#{self.name}"
  end

  def amendment_type_enum
    [ 'Redução de valor',
      'Acréscimo de valor',
      'Prorrogação de Prazo',
      'Prorrogação de Prazo e Acréscimo',
      'Prorrogação de Prazo e Redução',
      'Alteração de Cláusula']
  end

  def calc_total_value_amendment
      if (self.amendment_value)
        contrato = self.contract
        contrato.total_value  = self.amendment_value + contrato.try(:total_value)
        contrato.save!
      end
  end

  def update_finish_date
      if (self.finish_date && (self.amendment_type == "Prorrogação de Prazo" || self.amendment_type == "Prorrogação de Prazo e Acréscimo" || self.amendment_type == "Prorrogação de Prazo e Redução"))
        contrato = self.contract
        contrato.last_finish_date  = self.finish_date
        contrato.save!
      end
  end



end
