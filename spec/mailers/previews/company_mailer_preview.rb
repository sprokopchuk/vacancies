# Preview all emails at http://localhost:3000/rails/mailers/company_mailer
class CompanyMailerPreview < ActionMailer::Preview
  def denial_mail_preview
    employer = User.where(:role => :employer).take
    applicant = User.where(:role => :applicant).take
    CompanyMailer.denial_email(applicant, employer.company)
  end
end
