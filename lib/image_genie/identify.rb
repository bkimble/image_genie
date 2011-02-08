# Verify an image is valid by calling 'identify' on it and testing for errors on the return.
module ImageGenie
  class IdentifyError < StandardError; end;
  class Identify < Command
    def self.run(filename, options={})
      raise(UnableToLocateBinaryError, 'identify') if path_for(:identify).blank?

      begin
        raise Errno::ENOENT,"#{filename}" unless File.exists?(filename)
      rescue Errno::ENOENT => e
        logger.error("#{self.name} #{e.message}")
        raise
      end

      command = "#{path_for(:identify)} #{filename}"
      output = ''

      # We test for STDERR content
      execute(command) do |pid,stdin,stdout,stderr|
        while !stdout.eof?
          output += stdout.readline
        end

        ignored, status = Process::waitpid2 pid
        handle_errors(stderr,status,IdentifyError)
      end

      fields = [:filename,:format,:dimensions,:geometry,:bit,:image_class,:colors,:filesize,:usertime,:identify_time]                    
      return Hash[fields.zip(stdout.read.split(' '))]
    end
  end
end

