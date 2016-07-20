# Preview all emails at http://localhost:3000/rails/mailers/deadline
class DeadlinePreview < ActionMailer::Preview
  def week_deadline_email_preview
    Deadline.week_deadline_email(User.first)
  end
  def accountability_email_preview
    Deadline.accountability_email(User.first)
  end
end
