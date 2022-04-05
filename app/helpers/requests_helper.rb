module RequestsHelper
  def filter_by_params(scope, params)
    params.each do |key, value|
      next if value.blank?

      scope = case key.to_s
              when 'apartment_class'
                scope.where(apartment_class: value)
              when 'status'
                scope.where(status: value)
              else
                scope
              end
    end
    scope
  end

  def sort_by_params(scope, params)
    params.each do |key, value|
      next unless %w[desc asc].include?(value)

      scope = case key.to_s
              when 'apartment_class'
                scope.order("apartment_class #{value}")
              when 'status'
                scope.order("status #{value}")
              else
                scope
              end
    end
    scope
  end
end
