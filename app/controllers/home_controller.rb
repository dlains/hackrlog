class HomeController < ApplicationController
  skip_before_filter :authorize

  def support
    Notifier.support_request(params[:name], params[:email], params[:subject], params[:comments]).deliver
    redirect_to home_help_path, notice: 'Your support request has been delivered.'
  end

end
