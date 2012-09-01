set_default(:stripe_destination)    { "#{current_path}/config/initializers/stripe.rb" }
set_default(:stripe_source)         { "#{shared_path}/config/stripe.rb" }

namespace :stripe do
  desc "Move the production Stripe keys into position"
  task :move_key, roles: :app do
    run "#{sudo} cp #{stripe_source} #{stripe_destination}"
  end
  after "deploy:update", "stripe:move_key"
end