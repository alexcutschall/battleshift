class UserMailer < ApplicationMailer
  def activation_email
    @user = params[:user]
    @name = @user.name
    @url = "#{ENV['BASE_URL']}/activate/#{@user.activation_key}"
    @api_key = @user.api_key

    mail(to: @user.email, subject: 'Activate Your Battleshift Account')
  end
end
