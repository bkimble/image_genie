module ImageGenie
  class Command < Base    
    attr_accessor :stdin,:stdout,:stderr,:pid,:status
    attr_accessor :exception_class,:caller_obj
    attr_accessor :output_buffer

    def has_error?
      !self.status.zero?      
    end
        
    def initialize(obj)
      self.output_buffer = ''
      self.caller_obj = obj
    end

    def execute(command)
      begin
        caller_obj.pid, caller_obj.stdin, caller_obj.stdout, caller_obj.stderr = Open4::popen4(command)
        caller_obj.input if caller_obj.respond_to?(:input)
        caller_obj.output if caller_obj.respond_to?(:output)
#        puts "Waiting"
        ignored, status = Process::waitpid2 caller_obj.pid
        self.status = status.exitstatus
#        puts "checking for error now"
        caller_obj.error if caller_obj.respond_to?(:error)
      rescue Exception => e
        raise
      ensure
        caller_obj.cleanup if caller_obj.respond_to?(:cleanup)
      end
    end    

    def self.handle_errors(stderr,status,exception)
      unless status.exitstatus.zero?
        errors = stderr.read.strip
        logger.error("#{self.name} #{errors}")
        raise(exception, errors)
      end      
    end

    def path_for(program)
      self.class.paths[program.to_sym]
    end

    def make_command(command,*args)
      command.strip!
      components = [command]
      args.each do |component|
        components << case (component.class.name)
        when 'Hash': make_flags(component)
        when 'Array': make_args(component)
        else " #{component}"
        end
      end
      components.compact.join(' ')
    end

    def make_args(args)
      args = [args] if !args.is_a?(Array)
      return nil if args.empty?
      args.join(' ')
    end

    # There is probably a better library to handle creation of command line flags,
    # but this works for now.
    def make_flags(options={})
      return nil if options.empty?
      options.collect{|k,v| "-#{k} #{v}"}.join(' ')
    end
    
    
    # define generic error/input/output handlers
    def error
      if has_error?
        errors = stderr.read.strip
        logger.error("#{caller_obj.class.name} #{errors}")
        raise(caller_obj.exception_class, errors)        
      end
    end
    
    def output
      # Generic output processing -- just read it and store it in a buffer. We may want to restrict the amount of data
      # in here via a configuration directive so we don't eat up all of the available system memory.
      while !stdout.eof?
        self.output_buffer += stdout.readline
      end
    end
    
  end
end



