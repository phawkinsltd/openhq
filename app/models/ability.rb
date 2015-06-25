class Ability
  include CanCan::Ability

  def initialize(user)
    # Order matters!
    # Greater roles inherit lower permissions

    if user.role? :user
      # User can update/view themselves
      can :read, User, id: user.id
      can :update, User, id: user.id

      # Can view projects they are a member of
      can :read, Project, id: user.projects.pluck(:id)

      can :create, Project
      can :create, Story
      can :create, Task
      can :create, Attachment

      # Can update objects they own
      can :update, Project, owner_id: user.id
      can :update, Story, owner_id: user.id
      can :update, Task, owner_id: user.id
      can :update, Attachment, owner_id: user.id
      can :update, Comment, owner_id: user.id
    end

    if user.role? :admin
      can :manage, Project
      can :read, User
      can :assign_roles, User
      can :update, Settings

      # Can edit users below their role
      can :update, User, role: user.assignable_roles[0...-1]
    end

    if user.role? :owner
      # Can haz all the things
      can :manage, :all
    end

  end
end
