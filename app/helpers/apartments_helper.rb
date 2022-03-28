module ApartmentsHelper
  def filter_by_params(scope, params)

    params.each do |key, value|

      scope = case key.to_s
              when 'lowest_price'
                scope.order(:price_cents)
              when 'highest_price'
                scope.order(:price_cents).reverse_order
              else
                scope.all
              end

      next if value.nil?

      scope = case key.to_s
              when 'apartment_class'
                puts value
                scope.where(apartment_class: value)
              when 'price_begin'
                scope.where('price_cents>=?', value.to_i * 100)
              when 'price_end'
                scope.where('price_cents<=?', value.to_i * 100)
              when 'hotel'
                scope.includes(:hotel).where(hotel: { name: value })
              else
                scope.all
              end
    end
    scope
  end

end
