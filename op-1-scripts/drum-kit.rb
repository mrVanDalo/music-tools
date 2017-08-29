#!/usr/bin/env ruby

# config
db_level = -8
sample_rate = 44100

# import
import_dir = "/dev/shm/export"

# work related
work_dir = "/dev/shm/work"
output_dir = "/dev/shm"
output_file = "drumkit.wav"
output_file_tmp1 = "drumkit_tmp1.wav"
output_file_tmp2 = "drumkit_tmp2.wav"


require 'fileutils'

if File.directory?(work_dir)
  FileUtils.rm_rf(work_dir)
end
FileUtils.mkdir_p(work_dir)

samples = Dir["#{import_dir}/*"].sort


def run ( command )
  puts command
  system command
end

# prepare
samples.each do |sample|
  run( "sox '#{sample}' " \
          "'#{work_dir}/#{File.basename(sample)}' " \
          "channels 1 " \
          "silence 1 0 0.4% 1 0 0.4% " \
          "gain -n #{db_level} " \
          "rate #{sample_rate}" )
end


# create empty file
run ( "sox --null " \
         "--channels 1 " \
         "--rate #{sample_rate} " \
         "'#{output_dir}/#{output_file_tmp1}' " \
         "trim 0 0" )
# merge
samples.map{ |sample|
  File.basename(sample)
}.each do |sample|
  run( "sox " \
          "'#{output_dir}/#{output_file_tmp1}' " \
          "'#{work_dir}/#{sample}' " \
          "'#{output_dir}/#{output_file_tmp2}'" )
  FileUtils.mv( "#{output_dir}/#{output_file_tmp2}", "#{output_dir}/#{output_file_tmp1}" )
end


run( "sox " \
         "'#{output_dir}/#{output_file_tmp1}' " \
         "'#{output_dir}/#{output_file}'" )

#FileUtils.rm("#{output_dir}/#{output_file_tmp1}")
