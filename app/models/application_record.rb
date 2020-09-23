class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.inherited(subclass)
    super
    return if subclass.abstract_class? || subclass.base_class == ActiveRecord::InternalMetadata

    subclass.instance_eval do
      def multitenant?
        @multitenant
      end

      def multitenant
        @multitenant = true
      end

      def not_multitenant
        @multitenant = false
      end

      multitenant
    end

    trace = TracePoint.new(:end) do |tp|
      if tp.self == subclass
        trace.disable
        if subclass.multitenant?
          tp.self.instance_eval do
            default_scope { where(company_id: Company.current_id) }
          end
        end
      end
    end

    trace.enable
  end
end
