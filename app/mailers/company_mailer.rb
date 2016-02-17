class CompanyMailer < ApplicationMailer
  default from: "notifications@localhost.com"

  def denial_email user, company, email = {subject: nil, body: nil}
    @user = user
    @company = company
    email[:subject] = "From company #{company.name.capitalize}" unless email[:subject]
    mail(to: @user.email,
         subject: email[:subject],
         body: email[:body],
         content_type: "text/html")
  end
end
