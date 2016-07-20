class Fine
  include Mongoid::Document


  field :name, type: String
  field :fine_type, type: String
  field :execution_date, type: Date
  field :justification, type: String
  field :process_number, type: String

  belongs_to :contract

  rails_admin do

      navigation_label 'Eventos'

      list do
        field :name
        field :fine_type
        field :execution_date
        field :process_number
        field :contract
      end

      edit do
        field :contract do
          inline_add false
          inline_edit false
        end

        field :name, :string
        field :execution_date
        field :fine_type
        field :justification
        field :process_number, :string
      end

      show do
      end

      object_label_method do
         :custom_label_method
      end


  end

  def custom_label_method
    "#{self.name}"
  end

  def fine_type_enum
    [ 'Advertência',
      'Multa',
      'Suspensão temporária de licitar',
      'Contratar com a Adminstração Pública',
      'Idoneidade']
  end
end
