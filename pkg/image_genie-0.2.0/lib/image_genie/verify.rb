# Verify an image is valid by calling 'identify' on it with verbose turned on , 
# and testing for errors on the return.
module ImageGenie
  class VerifyError < StandardError; end;
  class Verify < Command

    attr_accessor :filename

    def initialize(filename, options={})
      self.exception_class = VerifyError
      raise(UnableToLocateBinaryError, 'identify') if path_for(:identify).blank?
      self.filename = filename
      raise Errno::ENOENT,"#{filename}" unless File.exists?(filename)
      super(self)
    end

    def run
      execute("#{path_for(:identify)} #{filename}")
      return true      
    end    
  end
end
