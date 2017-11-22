require 'io/console'
require 'colorize'

class Interface
  def draw_menu
    menu_elements = [
      'Parse email database',
      'Export results to CSV',
      'Generate new keys',
    ]
    mlength = menu_elements.max_by(&:length).length + 7
    puts_center('#' * (mlength + 4))
    puts_center("MENU".center(mlength - 4).prepend('### ') +' ###')
    puts_center('#' * (mlength + 4))
    menu_elements.each_with_index do |element, index|
      puts_center("#{index + 1}. #{element}".center(mlength).prepend('# ') +' #')
    end
    puts_center('#' * (mlength + 4))
    puts ''
    puts "Please, choose action (1-#{menu_elements.count}) or 'Ctrl+C' to cancel"
  end

  def draw_empty_line
    puts ''
  end

  def draw_stats
    puts_center("Available keys: #{Key.where(status: true).count}")
    puts_center("Validated emails: #{Email.where.not(score: nil).count}/#{Email.count}")
  end

  def draw_logo
    puts_center('██████╗ ██╗   ██╗██████╗ ██╗   ██╗')
    puts_center('██╔══██╗██║   ██║██╔══██╗╚██╗ ██╔╝')
    puts_center('██████╔╝██║   ██║██████╔╝ ╚████╔╝ ')
    puts_center('██╔══██╗██║   ██║██╔══██╗  ╚██╔╝  ')
    puts_center('██║  ██║╚██████╔╝██████╔╝   ██║   ')
    puts_center('╚═╝  ╚═╝ ╚═════╝ ╚═════╝    ╚═╝   ')
    puts ''
    puts_center('██████╗  █████╗ ██████╗ ███████╗███████╗██████╗ ')
    puts_center('██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗')
    puts_center('██████╔╝███████║██████╔╝███████╗█████╗  ██████╔╝')
    puts_center('██╔═══╝ ██╔══██║██╔══██╗╚════██║██╔══╝  ██╔══██╗')
    puts_center('██║     ██║  ██║██║  ██║███████║███████╗██║  ██║')
    puts_center('╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝')
  end

  def draw_license
    puts_center('================================================')
    puts_center('This parser is available as open source')
    puts_center('under the terms of the MIT License.')
    puts_center('================================================')
  end

  private

  def puts_center(obj)
    puts(obj.center(term_size.last))
  end

  def term_size
    IO.console.winsize
  rescue LoadError
    [Integer(`tput li`), Integer(`tput co`)]
  end
end
