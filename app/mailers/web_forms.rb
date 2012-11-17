class WebForms < ActionMailer::Base
  default :from => "application@vap2012-host.truevds.ru"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.web_forms.order.subject
  #
  # WebForms.order.deliver
  def order
    @greeting = "Hi"

    # mail :to => "vadim-ip@mail.ru"
    mail :to => "c-master@classy.ru"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.web_forms.site_page_form.subject
  #
  # WebForms.site_page_form.deliver
  def site_page_form
    @greeting = "Hi"

    mail :to => "sale@putivetra.ru"
  end
end
