module ImageGenie
  class MontageError < StandardError; end; 
  class Montage < Command
    attr_accessor :filenames, :options, :temp_image_file, :temp_image_list_file

    def output
      while !stdout.eof?
        temp_image_file.puts stdout.readline
      end
      temp_image_file.rewind
    end
    
    def cleanup
      logger.info("#{self.class.name} Cleaning up files")
      temp_image_list_file.close
    end

    def initialize(filenames,options={})
      logger.info("#{self.class.name} Attempting to make montage of #{filenames.count} files")
      self.filenames = filenames
      self.exception_class = MontageError
      raise(UnableToLocateBinaryError, 'montage') if path_for(:montage).blank?
      self.options = options
      # Montage hates when you attempt to give it files with a path in it, so we
      # need to change to the system specified temp directory to do our work.
      Dir.chdir(Dir::tmpdir)
      self.temp_image_file = Tempfile.new(['montage','.jpg'])
      self.temp_image_list_file = Tempfile.new(['montage_image_filenames','.txt']) 
      # Create a temp file that will be all component files of this montage
      temp_image_list_file.puts filenames.join("\n")
      temp_image_list_file.rewind
      super(self)
    end

    def run
      command = make_command(path_for(:montage), "@\"#{File.basename(temp_image_list_file.path)}\"", options, "jpeg:-")
      execute(command)
      return temp_image_file
    end
  end
end





