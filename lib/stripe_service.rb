class StripeService

  class << self

    # Upgrade a hacker's account to premium.
    def create_customer(hacker, card_token)
      if hacker.subscription.stripe_customer_token == nil
        begin
          Stripe::Customer.create(email: hacker.email, plan: 'hackrlog_1', card: card_token)
        rescue Stripe::InvalidRequestError => e
          Rails.logger.error "Stripe error while creating customer: #{e.message}."
          hacker.errors.add :base, "There was a problem processing your credit card."
        end
      end
    end
    
    # Cancel a hacker's subscription.
    def cancel_customer_subscription(hacker)
      begin
        customer = Stripe::Customer.retrieve(hacker.stripe_customer_token)
        customer.cancel_subscription
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error "Stripe error while canceling customer subscription: #{e.message}."
        hacker.errors.add :base, "There was an error cancelling your subscription: #{e.message}."
      end
    end

  end
end