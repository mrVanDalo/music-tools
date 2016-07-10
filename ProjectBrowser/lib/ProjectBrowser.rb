require 'ProjectBrowser/browser'
require 'ProjectBrowser/command_reader'
require 'ProjectBrowser/project'
require 'ProjectBrowser/selector'
require 'ProjectBrowser/version'
require 'ProjectBrowser/client'

module ProjectBrowser
  # Your code goes here...
  EMPTY_INFO_STRING = 'NO info yet'
  INFO_FILE_NAME = 'info'
  EDITOR = 'vim'
  PLAYER = '/usr/bin/mplayer -ao jack'
  DEFAULT_PROJECT = '/home/renoise/projects'
  START = 'start.sh'
  COMPRESS_EXAMPLE = true
  EXAMPLE = 'example'
  SOX = '/usr/bin/sox'
end
