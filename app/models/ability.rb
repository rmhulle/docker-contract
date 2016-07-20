class Ability
  include CanCan::Ability
  def initialize(user)               # allow everyone to read everything
    if user
      can :access, :rails_admin
      can :dashboard
      can :report
      if user.role == "NECL"
        can :manage, :all
        cannot :history, :all
        cannot :manage, Site
        cannot :destroy, User
      elsif user.role == "Gerente"
        can :read, Contract,        :requesting => user.ug
        can :read, Amendment,       :contract => { :requesting => user.ug }
      elsif user.role == "Fiscal"
        # can :edit, User,              :user_id => user.id   # only allow admin users to access Rails Admin
        can :manage, Invoice,       :user_id => user.id
        can :manage, ServiceOrder,  :user_id => user.id
        can :manage, Budget,        :user_id => user.id
        can :read, Contract, Contract.fiscal do |contrato|
            contrato.accountabilities.where(active: true).first.user._id == user.id
        end

        can :update, User,          _id: user.id
        cannot :history, :all
      elsif user.role == "Admin"
        # can :edit, User,              :user_id => user.id   # only allow admin users to access Rails Admin
        can :manage, :all
        can :import, :all    # allow superadmins to do anything
      end
    end
  end
end



# # Always performed
# can :access, :rails_admin # needed to access RailsAdmin
#
# # Performed checks for `root` level actions:
# can :dashboard            # dashboard access
#
# # Performed checks for `collection` scoped actions:
# can :index, Model         # included in :read
# can :new, Model           # included in :create
# can :export, Model
# can :history, Model       # for HistoryIndex
# can :destroy, Model       # for BulkDelete
#
# # Performed checks for `member` scoped actions:
# can :show, Model, object            # included in :read
# can :edit, Model, object            # included in :update
# can :destroy, Model, object         # for Delete
# can :history, Model, object         # for HistoryShow
# can :show_in_app, Model, object
# Status API Training Shop Blog About
