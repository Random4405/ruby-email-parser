require 'rest-client'

class SolveCaptcha
  attr_accessor :solved_key

  def initialize(captcha)
    result = request(captcha)
    @solved_key = solving(result)
  end

  def request(captcha)
    RestClient.get 'http://rucaptcha.com/in.php', params: {
      key: '4a4514f56bfc4339e59f0fa2258fe30b',
      method: 'userrecaptcha',
      googlekey: captcha,
      pageurl: 'https://mailboxlayer.com/signup?plan=71'
    }
  end

  def get_key(id)
    RestClient.get 'http://rucaptcha.com/res.php', params: {
      key: '4a4514f56bfc4339e59f0fa2258fe30b',
      action: 'get',
      id: id
    }
  end

  def solving(result)
    captcha_id = result.body.split('|').last.last(6)
    start_time = Time.now.strftime('%s').to_i
    puts "Started solving #{captcha_id} in #{Time.now.strftime('%T')}"
    a = loop do
      begin
        code = get_key(result.body.split('|').last)
      rescue
        next
      end
      break code unless code.eql?('CAPCHA_NOT_READY')
      sleep 5
    end
    end_time = Time.now.strftime('%s').to_i
    puts "Captcha #{captcha_id} solved in #{end_time - start_time} seconds"
    a
  end
end
