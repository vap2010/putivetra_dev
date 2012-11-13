class WebForms < ActionMailer::Base
  default :from => "web_form@putivetra.ru"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.web_forms.order.subject
  #
  def order
    @greeting = "Hi"

    mail :to => "vadim-ip@mail.ru"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.web_forms.site_page_form.subject
  #
  def site_page_form
    @greeting = "Hi"

    mail :to => "sale@putivetra.ru"
  end
end
