class ContactMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def inquiry_email(contact)
    @name = contact.name
    @email = contact.email
    @message = contact.message

    mail(
      to: 'tama33.sid@gmail.com', # 管理者のメールアドレス
      subject: 'kakeibo25のお問い合わせ内容',
      reply_to: contact.email # 返信先として指定
    )
  end
end
