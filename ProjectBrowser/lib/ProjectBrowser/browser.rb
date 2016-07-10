require 'curses'

module ProjectBrowser
  class Browser


    # @param [ProjectBrowser::Selector] selector
    def initialize(selector)
      @selector = selector
    end

    include Curses
    def project_list_window
      win = Window.new(
          lines - 2,
          (cols / 2) - 2,
          1,1)
      win.box('|', '-')
      lines_height = lines - 5
      if @selector.current_project_index > lines_height
        (0..lines_height).each do |current_line|
          diff = @selector.current_project_index - lines_height
          win.setpos(current_line + 1,4)
          current = @selector.all_projects[current_line + diff]
          win.addstr(current.name)
        end
        win.setpos(lines_height + 1 , 2)
      else
        (0..lines_height).each do |current_line|
          win.setpos(current_line + 1,4)
          current = @selector.all_projects[current_line]
          if current
            win.addstr( current.name )
          end
        end
        win.setpos(@selector.current_project_index + 1, 2)
      end
      win.refresh
    end

    def headline_window
      headline_top    = 1
      headline_height = 3
      headline_width  = (cols / 2) - 2
      headline = Window.new(
          headline_height,
          headline_width,
          headline_top,
          headline_width + 1)
      name = @selector.current_project.name
      headline.setpos( 1 ,  (headline_width / 2) - (name.length / 2)  )
      headline.addstr( name )
      headline.refresh
    end

    def option_window
      example_exists = @selector.current_project.example_exists?
      example_width  = (cols / 2 ) - 4
      example_left   = (cols / 2 ) + 1
      example_top    = 5
      example_height = 3
      example_win = Window.new(
          example_height,
          example_width,
          example_top,
          example_left
      )
      if example_exists
        example_win.box('|', '-')
        play_message = 'p : Play example'
        example_win.setpos( 1, (example_width / 2 ) - (play_message.length / 2 ))
        example_win.addstr( play_message )
        example_win.refresh
      else
        example_win.refresh
      end
    end

    def info_text_window
      info_text = @selector.current_project.info
      top = 10
      width = (cols / 2) - 2
      info_height = lines - top
      info_win = Window.new(
          info_height,
          width,
          top,
          width + 3)
      info_win.addstr( info_text )
      info_win.refresh
    end

  end
end