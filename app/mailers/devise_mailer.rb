class DeviseMailer < ::ActionMailer::Base
  include Devise::Mailers::Helpers

  layout 'notifier'

  def confirmation_instructions(record, opts={})
    attachments.inline['logomail'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    devise_mail(record, :confirmation_instructions, opts)
  end

  def reset_password_instructions(record, opts={})
    attachments.inline['logomail'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, opts={})
    attachments.inline['logomail'] = File.read(Rails.root.join('app/assets/images/logomail.png'))
    devise_mail(record, :unlock_instructions, opts)
  end
end
