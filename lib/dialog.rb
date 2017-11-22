class Dialog
  def self.keys_count
    puts 'How many keys do you want generate?'
    gets.chomp.to_i
  end

  def self.goodbye
    puts 'See you later!'
  end

  def self.generate_keys
    puts 'Generate new keys? (y/n)'

    if gets.chomp.downcase.first.eql?('y')
      Dialog.keys_count.times do
        KeysWorker.perform_async
        puts 'Key generation started'
        puts 'Wait please...'
      end
    else
      Dialog.goodbye
    end
  end
end
