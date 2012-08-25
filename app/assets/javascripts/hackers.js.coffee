# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  if typeof(Stripe) != 'undefined'
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    premium.setupForm()

premium =
  setupForm: ->
    $('#hacker_premium').submit ->
      $('#hacker_premium input[type=submit]').attr('disabled', true)
      premium.processCard()
      false
      
  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, premium.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#hacker_stripe_card_token').val(response.id)
      $('#hacker_premium')[0].submit()
    else
      $('#stripe-error-text').text(response.error.message)
      $('#stripe-error').toggle()
      $('#hacker_premium input[type=submit]').attr('disabled', false)
