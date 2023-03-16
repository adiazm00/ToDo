module Status
    extend ActiveSupport::Concern
  
    VALID_STATUSES = ['Unstarted', 'In progress', 'Completed', 'Failed']
  
    included do
      validates :status, inclusion: { in: VALID_STATUSES }
    end

  end
  