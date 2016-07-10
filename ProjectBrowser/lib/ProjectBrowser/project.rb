module ProjectBrowser
  class Project

    attr_accessor :info

    attr_reader :name,
                :path,
                :info_path

    # @param [String] path
    def initialize(path)
      @path = path
      @name = File.basename(path)
      @info_path = File.join(path, INFO_FILE_NAME)
      extract_info_message
    end

    def example_exists?
      not Dir["#{@path}/#{EXAMPLE}.*"].empty?
    end

    def example_path
      mp3_path = File.join(@path, "#{EXAMPLE}.mp3")
      wav_path = File.join(@path, "#{EXAMPLE}.wav")
      if File.exist?(wav_path)
        if COMPRESS_EXAMPLE
          system "cd #{@path}; #{SOX} #{EXAMPLE}.wav #{EXAMPLE}.mp3 && rm #{EXAMPLE}.wav"
          return mp3_path
        else
          return wav_path
        end
      end
      if File.exist?(mp3_path)
        mp3_path
      end
    end

    def extract_info_message
      if File.exist?(@info_path)
        @info = File.open(@info_path, 'r') { |file| file.read }
      else
        @info = EMPTY_INFO_STRING
      end
    end

  end
end