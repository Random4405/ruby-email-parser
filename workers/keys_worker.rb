require 'watir'
require 'active_record'
require 'nokogiri'
require 'sidekiq-scheduler'
require_relative '../lib/solve_captcha'
require_relative '../models/key'

class KeysWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'keys'

  def perform
    @browser = Watir::Browser.new
    @browser.goto 'https://mailboxlayer.com/signup?plan=71'
    @doc = Nokogiri::HTML(@browser.html)
    fill_form
    save_key
    sleep 2
    @browser.close
  end

  def fill_form
    letters = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
    email = "#{letters}#{(rand * 20000).round}@gmail.com"
    @browser.text_field(name: 'email_address').set email
    @browser.text_field(name: 'email_address_repeat').set email
    @browser.text_field(name: 'password').set 'qwerty4405'
    @browser.text_field(name: 'first_name').set 'Nikita'
    @browser.text_field(name: 'last_name').set 'Random'
    @browser.text_field(name: 'address').set 'Random string of test'
    @browser.text_field(name: 'post_code').set '223034'
    @browser.text_field(name: 'city').set 'Minsk'
    @browser.select_list(name: 'country_code').select 'Belarus'
    @browser.checkbox(name: 'tos_accepted').check
    begin
      element = @browser.textarea(id: 'g-recaptcha-response')
      script = "arguments[0].setAttribute('style', '')"
      @browser.execute_script(script, element)
      @browser.textarea(id: 'g-recaptcha-response').set solve_captcha
      @browser.label(class: 'login_button').click
    rescue
      @browser.close
    end
  end

  def solve_captcha
    SolveCaptcha.new(captcha_key).solved_key.body.split('|').last
  end

  def save_key
    @doc = Nokogiri::HTML(@browser.html)
    key = @doc.xpath("//div[contains(@class, 'alert_inner')]").text
    Key.create(
      key: key,
      status: true
    ) unless key.eql?('Please prove that you are human by ticking the box.')
  end

  def make_field_visible
    element = @browser.textarea(id: 'g-recaptcha-response')
    script = "arguments[0].setAttribute('style', '')"
    @browser.execute_script(script, element)
  end

  def captcha_key
    captcha_link = @doc.xpath("//div[contains(@class, 'captcha_container')]//iframe/@src").text
    captcha_key = captcha_link.split('&').map do |element|
      element.split('=')
    end.to_h.first.last
  end
end
