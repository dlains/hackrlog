class StripeService

  class << self

    # Cancel a hacker's subscription.
    def cancel_customer_subscription(hacker)
      begin
        customer = Stripe::Customer.retrieve(hacker.stripe_customer_token)
        customer.cancel_subscription
      rescue Stripe::InvalidRequestError => e
        logger.error "Stripe error while canceling customer subscription: #{e.message}."
        hacker.errors.add :base, "There was an error cancelling your subscription: #{e.message}."
      end
    end

  end
end