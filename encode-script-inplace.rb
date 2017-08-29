#!/usr/bin/env ruby



# Transforms wav and flac files to mp3 files
def transform_flac (file, ending, target = '/dev/shm/')
  target_file = File.basename(file, ".#{ending}")
  cmd = "ffmpeg -i \"#{file}\" -codec:a libmp3lame -qscale:a 0 \"#{target}/#{target_file}.mp3\""
  puts cmd
  system ( cmd ) or raise "Something went wrong with #{file}"
end


#
# main
#
Dir['*'].sort().each do |file|
  if /wav$/ =~ file
      transform_flac(file, "wav", ".")
  elsif /flac$/ =~ file
      transform_flac(file, "flac", ".")
  elsif /ogg$/ =~ file
    transform_flac(file, "ogg", ".")
  else
    puts "skip #{file}"
  end
end
