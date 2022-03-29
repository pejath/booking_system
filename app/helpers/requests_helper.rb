module RequestsHelper
  def filter_by_params(scope, params)
    params.each do |key, value|

      next if value.nil?

      scope = case key.to_s
              when 'apartment_class'
                scope.where(apartment_class: value)
              when 'status'
                scope.where(status: value)
              else
                scope.all
              end
    end

    scope
  end

  def sort_by_params(scope, params)
    params.each do |key, value|

      scope = case key.to_s
              when 'sort_apartment_class'
                scope.order(:apartment_class)
              when 'sort_status'
                scope.order(:status)
              else
                scope.all
              end
    end
    scope
  end
end
