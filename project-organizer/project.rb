#!/usr/bin/env ruby

# configuration
DEFAULT_PROJECT = '/home/renoise/projects'
PLAYER          = '/usr/bin/mplayer -ao jack'
EXAMPLE         = 'example.mp3'
INFO            = 'info'
START           = 'start.sh'
EDITOR          = 'vim'

#
# read all information from the project folder
#
def extract_info_message(info_path)
  if ( File.exist?(info_path) )
    return File.open(info_path, "r") { |file| file.read }
  else
    return "NO info yet"
  end
end
@project_folder = ARGV.shift || DEFAULT_PROJECT
@all_project_names = Dir["#{@project_folder}/*"].sort.map { |file|
  project_name  = file[(@project_folder.length + 1) .. file.length]
  path          = "#{@project_folder}/#{project_name}"
  info_path     = "#{path}/#{INFO}"
  example_path  = "#{path}/#{EXAMPLE}"
  {
    :name            => project_name,
    :path            => path,
    :info            => extract_info_message(info_path),
    :example         => example_path,
    :example_exists? => File.exist?( example_path ),
  }
}

# the current selected project
@current_project_index = 0

require "curses"
include Curses

#
# list all projects on the lift side oft the
# screen.
#
def project_list_window()
  win = Window.new(
    lines - 2,
    (cols / 2) - 2,
    1,1)
  win.box('|', '-')
  lines_height = lines - 5
  if @current_project_index > lines_height
    (0..lines_height).each do |current_line|
      diff = @current_project_index - lines_height
      win.setpos(current_line + 1,4)
      current = @all_project_names[current_line + diff]
      win.addstr(current[:name])
    end
    win.setpos(lines_height + 1 , 2)
  else
    (0..lines_height).each do |current_line|
      win.setpos(current_line + 1,4)
      current = @all_project_names[current_line]
      if (current)
        win.addstr(current[:name])
      end
    end
    win.setpos(@current_project_index + 1, 2)
  end
  win.refresh
end

def headline_window()
  headline_top    = 1
  headline_height = 3
  headline_width  = (cols / 2) - 2
  headline = Window.new(
    headline_height,
    headline_width,
    headline_top,
    headline_width + 1)
  name = @all_project_names[@current_project_index][:name]
  headline.setpos( 1 ,  (headline_width / 2) - (name.length / 2)  )
  headline.addstr( name )
  headline.refresh
end

def info_text_window()
  info_text = @all_project_names[@current_project_index][:info]
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

def option_window()
  example_exists = @all_project_names[@current_project_index][:example_exists?]
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
  if ( example_exists )
    example_win.box('|', '-')
    play_message = "p : Play example"
    example_win.setpos( 1, (example_width / 2 ) - (play_message.length / 2 ))
    example_win.addstr( play_message )
    example_win.refresh
  else
    example_win.refresh
  end
end

#
# understand the command pressed
#
def read_command_char()
  char = STDIN.getc
  case char
  when 'j'
    next_project()
  when  'k'
    previous_project()
  when 'q'
    exit
  when 'e'
    edit_project_info()
  when 'p'
    play_example()
  else # should only happen if RETURN key is pressed, but don't know how
    open_project()
  end
end

#
# command functions
#
def open_project()
  path = @all_project_names[@current_project_index][:path]
  system "cd #{path}; bash #{START}"
  puts
  puts '-------------------------------------------------------'
  puts path
  puts '-------------------------------------------------------'
  puts
  exit
end
def next_project()
  @current_project_index += 1
  if ((@all_project_names.length - 1) <= @current_project_index)
    @current_project_index = @all_project_names.length - 1
  end
end
def previous_project()
  @current_project_index -= 1
  if ( @current_project_index < 0 )
    @current_project_index = 0
  end
end
def edit_project_info()
  info_path = "#{@all_project_names[@current_project_index][:path]}/#{INFO}"
  system "#{EDITOR} #{info_path}"
  @all_project_names[@current_project_index][:info] = extract_info_message( info_path )
end
def play_example()
  example_exist = @all_project_names[@current_project_index][:example_exists?]
  if ( example_exist )
    example_path = @all_project_names[@current_project_index][:example] 
    system "#{PLAYER} #{example_path} > /dev/null"
  end
end

#
# main program
#
init_screen
begin
  crmode
  while true
    headline_window()
    info_text_window()
    option_window()
    project_list_window()
    read_command_char()
    refresh
  end
ensure
  close_screen
end
