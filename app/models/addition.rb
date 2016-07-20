class Addition

  include Mongoid::Document

  field :name, type: String
  field :object, type: String
  field :description, type: String
  field :adjustment_percentage, type: Float
  field :start_date, type: Date
  field :adjustment_total_value, type: Money, default: 0

  belongs_to :contract

  before_create :calc_total_value_addition

  rails_admin do

      navigation_label 'Eventos'

      list do
        field :name
        field :object
        field :start_date
        field :contract
      end

      edit do
        field :contract do
          inline_add false
          inline_edit false
        end

        field :name, :string
        field :object
        field :description
        field :adjustment_percentage
        field :start_date
      end

      show do
        field :name
        field :start_date
        field :object
        field :description
        field :adjustment_percentage do
           formatted_value{ "#{value}%" }
        end
        field :adjustment_total_value do
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

  def object_enum
    [ 'Reajuste',
      'Alteração de Dotação Orçamentária',
      'Substituição do Fiscal',
      'Outros']
  end

  def calc_total_value_addition
      if (adjustment_percentage)
        contrato = self.contract
        self.adjustment_total_value = (self.adjustment_percentage/100) * contrato.total_value
        contrato.total_value = contrato.total_value + self.adjustment_total_value
        contrato.save!
      end
  end


end
