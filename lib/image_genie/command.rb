module ImageGenie
  class Command < Base    
    def self.handle_errors(stderr,status,exception)
      unless status.exitstatus.zero?
        errors = stderr.read.strip
        logger.error("#{self.name} #{errors}")
        raise(exception, errors)
      end      
    end
  end
end