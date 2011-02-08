module ImageGenie
  class MontageError < StandardError; end; 
  class Montage < Command
    attr_accessor :filenames,:filename,:options

    def initialize(options={})
      self.filenames = []
      self.options = options
    end


    def self.run(filenames, options={})
      raise(UnableToLocateBinaryError, 'montage') if path_for(:montage).blank?
      # Montage hates when you attempt to give it files with a path in it, so we
      # need to change to the system specified temp directory to do our work.
      Dir.chdir(Dir::tmpdir)
      # Create a temp file that will be all component files of this montage
      temp_image_file = Tempfile.new(['montage','.jpg'])
      temp_image_list_file = Tempfile.new(['montage_image_filenames','.txt']) 
      temp_image_list_file.puts filenames.join("\n")
      temp_image_list_file.rewind

      logger.info("#{self.name} Attempting to make a montage of #{filenames.size} files")

      command = make_command(path_for(:montage), "@\"#{File.basename(temp_image_list_file.path)}\"", options, "jpeg:-")

      begin
        execute(command) do |pid,stdin,stdout,stderr|
          while !stdout.eof?
            temp_image_file.puts stdout.readline
          end
          temp_image_file.rewind

          # Still foggy on if we need to wait until we read from STDOUT before waiting, or if
          # we wait until we read STDOUT and STDERR.
          ignored, status = Process::waitpid2 pid
          handle_errors(stderr,status,MontageError)
        end
      rescue Exception => e
        # Close the tempfile before raising
        temp_image_file.close
        raise
      ensure
        logger.info("#{self.name} Cleaning up files")
        temp_image_list_file.close
      end

      return temp_image_file

    end
  end
end





