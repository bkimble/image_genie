module ImageGenie
  class ConvertError < StandardError; end; 
  class Convert < Command
    def self.run(src, options={})
      raise(UnableToLocateBinaryError, 'convert') if path_for(:convert).blank?

      logger.info("#{self.name} Attempting to convert #{src.path}")

      begin
        raise Errno::ENOENT,"#{src.path}" unless File.exists?(src.path)
      rescue Errno::ENOENT => e
        logger.error("#{self.name} #{e.message}")
        raise
      end

      format = File.extname(src.path).downcase.gsub(/\.|\?/,'')

      command = "#{path_for(:convert)} #{make_flags(options)} #{format}:#{src.path} #{format}:-"
      temp_image_file = Tempfile.new([src.original_filename,".#{format}"]) 

      execute(command) do |pid,stdin,stdout,stderr|
        while line = stdout.gets
          temp_image_file.puts line
        end
        ignored, status = Process::waitpid2 pid
        handle_errors(stderr,status,ConvertError)
      end

      temp_image_file.rewind
      return temp_image_file
    end
  end
end
