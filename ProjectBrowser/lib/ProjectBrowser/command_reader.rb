
module ProjectBrowser
  class CommandReader

    # @param [ProjectBrowser::Selector] selector
    def initialize(selector)
      @selector = selector
    end

    def read_command_char
      char = STDIN.getc
      case char
        when 'j'
          @selector.next_project
        when  'k'
          @selector.previous_project
        when 'q'
          exit
        when 'e'
          edit_project_info
        when 'p'
          play_example
        else # should only happen if RETURN key is pressed, but don't know how
          open_project
      end
    end

    def open_project
      path = @selector.current_project.path
      system "cd #{path}; bash #{START}"
      puts
      puts '-------------------------------------------------------'
      puts path
      puts '-------------------------------------------------------'
      puts
      exit
    end

    def edit_project_info
      current_project = @selector.current_project
      system "#{EDITOR} #{current_project.info_path}"
      current_project.extract_info_message
    end

    def play_example
      if @selector.current_project.example_exists?
        system "#{PLAYER} #{@selector.current_project.example_path} > /dev/null"
      end
    end

  end
end