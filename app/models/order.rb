class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :job
  def purchase
    response = EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
    response.success?
  end

  def price_in_cents
    (price*100).round
  end

  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      # you can dump details var if you need more info from buyer
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      # self.discount = details.params["discount"]
      self.price = details.params["amount"] * 100
    end
  end

  def express_purchase_options
    {
      :ip => ip_address,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end

  def validate_card
    if express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end

  private

  def express_purchase_options
    {
      :ip => ip,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end
end
