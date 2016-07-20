class Site
  include Mongoid::Document
  field :name, type: String
  field :subsecretary, type: String


  rails_admin do

      navigation_label 'Administrador'

      list do
        field :name
        field :subsecretary
      end

      edit do
        field :name, :string
        field :subsecretary
      end

      show do
        field :name
        field :subsecretary
      end

      object_label_method do
         :custom_label_method
      end


  end

  def custom_label_method
    "#{self.name}"
  end
  def subsecretary_enum
    ['Gabinete Secretario',
     'Subsecretaria de Regulação e de Organização da Atenção a Saúde',
     'Subsecretaria de Gestão Hospitalar',
     'Subsecretaria de Adminstração e de Financiamento da Atenção a Saúde',
     'Subsecretaria de Gestão Estratégica e Inovação']
  end

end
