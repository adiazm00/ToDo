module Role
    extend ActiveSupport::Concern
  
    VALID_ROLES = ['user', 'admin']
  
    included do
      validates :role, inclusion: { in: VALID_ROLES }
    end

  end
  