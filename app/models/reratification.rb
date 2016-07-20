class Reratification
  include Mongoid::Document

  field :name, type: String
  field :object, type: String
  field :publication_date, type: Date
  field :sign_date, type: Date

  belongs_to :contract

  rails_admin do

      navigation_label 'Eventos'

      list do
        field :name
        field :object
        field :publication_date
        field :contract
      end

      edit do
        field :contract do
          inline_add false
          inline_edit false
        end
        field :name
        field :object
        field :publication_date
        field :sign_date

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


end
