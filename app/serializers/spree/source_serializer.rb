module Spree
  class SourceSerializer < ActiveModel::Serializer
    embed :ids, include: true

    has_one :payment_method, serializer: PaymentMethodSerializer, root: :payment_methods

    def attributes
      # https://github.com/rails-api/active_model_serializers/issues/738
      # https://github.com/rails-api/active_model_serializers/issues/599#issuecomment-61915533
        data = super
        attrs = [ :id,
          :cc_type,
          :last_digits,
          :year,
          :month,
          :name,
          :gateway_customer_profile_id,
          :gateway_payment_profile_id]
         
        attrs.each do |attr|
          if object.methods.include? attr
            data[attr] = object.send(attr)
          end
        end
        data
    end

    def payment_method
      # https://github.com/rails-api/active_model_serializers/issues/599
      object.payment_method if object.methods.include? :payment_method
    end
  end
end
