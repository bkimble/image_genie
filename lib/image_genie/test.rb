module ImageGenie
  class TestError < StandardError; end; 
  class Test < Command
    attr_accessor :temp_image_file, :temp_image_list_file
    
    def input
    end
    
    def output
      while !stdout.eof?
        puts stdout.readline
#        self.temp_image_file.puts stdout.readline
      end
#      temp_image_file.rewind
    end
    
    
    def error
      if has_error?
        errors = stderr.read.strip
#        logger.error("#{self.name} #{errors}")
        raise(exception_class, errors)        
      end
    end        

    def initialize(options={})
      self.exception_class = TestError
      # Dir.chdir(Dir::tmpdir)
      # # Create a temp file that will be all component files of this montage
      # self.temp_image_file = Tempfile.new(['montage','.jpg'])
      # self.temp_image_list_file = Tempfile.new(['montage_image_filenames','.txt']) 
    end
    
    def run
      execute("ls WERIOWEK",self)
    end
  end
end





