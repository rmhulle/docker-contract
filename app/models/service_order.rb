class ServiceOrder
  include Mongoid::Document
  field :invoice_type, type: String, default: 'Ordem de Fornecimento'  #Tipo: é medição ou OS?
  field :name, type: String # Número da Ordem de Fornecimento/Medição
  field :emission_date, type: Date # Data de Emissão
  field :deadline_date, type: Date # Data de Entrega
  field :process_number, type: String # Número do Processo

  field :value, type: Money # Valor Global da Medição ou Ordem de Serviço
  field :comments, type: String
  field :user_id

  field :execution_date, type: Date # Data real de Entrega ou execução da Medição
  field :rating, type: String
  field :rating_justification, type: String

  before_create :update_total_executed
  #before_create :set_owner

  # só quem pode emitir uma nota é um Fornecedor, e está será sempre vinculada
  # a um contrato. Normalmente um contrato é executado por meio de várias notas
  # Caso um contrato seja deletado, assim como fornecedor suas notas também serão,
  # pois não haverá a quem vuncular e não será permitido notas soltas.

  belongs_to :vendor, dependent: :destroy, inverse_of: :service_order
  belongs_to :contract, dependent: :destroy, inverse_of: :service_order

  # TODO binding contrato e já vincular automaticamente ao fornecedor.
  # Sem que o usuário faça. Por enquanto esta manual.
  # Tem que entender como funciona as referencias em mongo

  rails_admin do

      navigation_label 'Fiscal'

      list do
        field :name
        field :deadline_date
        field :value do
          pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end
        field :contract
        field :vendor
      end

      edit do
        field :contract do
          associated_collection_scope do
            user_now = bindings[:controller].current_user.id
            #Só pode adicionar ordens de serviço em contratos do TIPO
            #Termo de adesão ou Ata e cujo o usuário ja foi setado como fiscal
            Proc.new { |scope|
              scope = Contract.where({ user_id: user_now, active: true }).or({ contract_type: 'Termo de Adesão' },
                                                               { contract_type: 'Ata de Registro' })

            }
          end
        end

        field :name
        field :emission_date
        field :deadline_date

        field :process_number, :string
        field :comments

        field :value, :string do
          formatted_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end
        group :execution do
          label "Execução do Objeto"
          help "Por favor, preencha as informações abaixo após a entrega/realização da Ordem de Serviço"
          active false
          field :execution_date
          field :rating
          field :rating_justification
        end
        field :user_id, :hidden do
          visible false
          default_value do
            bindings[:view]._current_user.id
          end
        end
      end

      show do
        exclude_fields :id, :created_at, :updated_at, :user_id
        field :value do
          pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end
      end
      # object_label_method do
      #   :custom_label_method
      # end

  end

  def set_owner
    self.user_id = bindings[:view]._current_user.id
  end


  #Issue: Can't sum classes, .sum(:value) -> .sum(&:value). issue solved by Karlinha S2!

  def update_total_executed
    idContrato = self.contract._id
    contrato = Contract.where(id: idContrato).first
    self.vendor_id = contrato.vendor._id
    contrato.total_executed = contrato.service_orders.sum(&:value) + self.value
    contrato.save
  end

  def rating_enum
    ['Satisfatória',
      'Inatisfatória']
  end
end
