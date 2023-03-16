module Priority
    extend ActiveSupport::Concern
  
    VALID_PRIORITIES = ['High', 'Medium', 'Low']
  
    included do
      validates :priority, inclusion: { in: VALID_PRIORITIES }
    end

    class_methods do
      def priority_count(collection, strPriority)
        i = 0
        collection.tasks.each do |task|
          if task.priority == strPriority
            i = i+1
          end
        end
        return i
      end
    end

    class_methods do
      def tasks_count(collection)
        i = 0
        collection.tasks.each do |task|
            i = i+1
        end
        return i
      end
    end

  end
  