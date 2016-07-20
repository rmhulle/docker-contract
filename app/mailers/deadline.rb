class Deadline < ApplicationMailer
  default from: "contratosesa@gmail.com"

  def week_deadline_email(user)
    @user = user
    @accountabilities = user.accountabilities.includes(:contract)
    mail(to: @user.email, subject: 'Pendências Contratuais')
  end

  def accountability_email(user)
    @user = user
    @accountabilities = user.accountabilities.includes(:contract)
    mail(to: @user.email, subject: 'Termo de Designação')
  end



end
