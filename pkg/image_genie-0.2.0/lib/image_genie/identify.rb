# Verify an image is valid by calling 'identify' on it and testing for errors on the return.
module ImageGenie
  class IdentifyError < StandardError; end;
  class Identify < Command
    attr_accessor :filename
    
    def initialize(filename, options={})
      self.exception_class = IdentifyError
      raise(UnableToLocateBinaryError, 'identify') if path_for(:identify).blank?
      self.filename = filename
      raise Errno::ENOENT,"#{filename}" unless File.exists?(filename)
      super(self)
    end
    
    def run
      command = "#{path_for(:identify)} #{filename}"
      execute(command)
      fields = [:filename,:format,:dimensions,:geometry,:bit,:image_class,:colors,:filesize,:usertime,:identify_time]                    
      return Hash[fields.zip(output_buffer.split(' '))]
    end
  end
end