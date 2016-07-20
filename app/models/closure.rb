class Closure
  include Mongoid::Document

  field :name, type: String
  field :closure_type, type: String
  field :closure_date, type: Date
  field :contractual_balance, type: Money

  belongs_to :contract

  before_create :close_contract

  rails_admin do

      navigation_label 'Eventos'

      list do
        field :name
        field :contract
        field :closure_date
        field :contractual_balance, :string do
          pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end
      end

      edit do
        field :contract do
          inline_add false
          inline_edit false
        end
        field :name
        field :closure_type
        field :closure_date
        field :contractual_balance, :string do
          formatted_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end

      end

      show do
        field :name
        field :contract
        field :closure_type
        field :closure_date
        field :contractual_balance, :string do
          pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
            humanized_money_with_symbol(value)
          end
        end


      end

      object_label_method do
         :custom_label_method
      end


  end

  def custom_label_method
    "#{self.name}"
  end


  def closure_type_enum
    ['Cumprimento do Objeto',
     'Exaurimento dos Recursos Financeiros',
     'Exaurimento do Limite Legal de Duração']
  end


      def close_contract
        contrato = self.contract
        contrato.active  = false
        contrato.save!
      end

end
