# Verify an image is valid by calling 'identify' on it with verbose turned on , 
# and testing for errors on the return.
module ImageGenie
  class VerifyError < StandardError; end;
  class Verify < Command

    def self.run(filename, options={})
      raise(UnableToLocateBinaryError, 'identify') if path_for(:identify).blank?

      begin
        raise Errno::ENOENT,"#{filename}" unless File.exists?(filename)
      rescue Errno::ENOENT => e
        logger.error("#{self.name} #{e.message}")
        raise
      end      

      command = "#{path_for(:identify)} #{filename}"
      # We test for STDERR content        
      execute(command) do |pid,stdin,stdout,stderr|
        ignored, status = Process::waitpid2 pid    
        handle_errors(stderr,status,VerifyError)
      end
      
      return true
    end
  end
end
