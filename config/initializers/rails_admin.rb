RailsAdmin.config do |config|

  ### Popular gems integration
config.main_app_name = ["SIC - ", "Secretaria de Saúde"]
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.configure_with(:import) do |config|
    config.logging = true
  end
  ## == Cancan ==
   config.authorize_with :cancan

  ## Auditoria ==
  #  config.audit_with :histeroid, User
  config.audit_with :mongoid_audit
  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard
    report            # mandatory
    index                   # mandatory
    new
    export
    import
  # bulk_delete
    show
    edit
    delete
    show_in_app
    toggle
    ## With an audit adapter, you can add:
    #history_index
    history_show



  end
end
