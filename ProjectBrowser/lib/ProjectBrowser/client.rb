require 'curses'

module ProjectBrowser
  class Client

    include Curses

    def initialize(path)
      @path = path || DEFAULT_PROJECT
      @all_projects = Dir["#{@path}/*"].sort.map { |file|
        Project.new(file)
      }
      @selector = Selector.new(@all_projects)
    end

    def main
      browser = Browser.new(@selector)
      command = CommandReader.new(@selector)
      init_screen
      begin
        crmode
        while true
          browser.headline_window
          browser.info_text_window
          browser.option_window
          browser.project_list_window
          command.read_command_char
          refresh
        end
      ensure
        #close_screen
      end
    end

  end
end