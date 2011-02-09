module ImageGenie
  class Base
    
    # Discover ImageMagick paths on the current system    
    def self.paths
      if !@paths
        @paths = {:identify => "",:montage => "",:convert => ""}
        @paths.keys.each do |program|
          command = "which #{program}"
          pid, stdin, stdout, stderr = Open4::popen4(command)
          path = stdout.read.strip
          @paths[program] = path
        end
      end
      @paths
    end    

    def self.execute(command)
      logger.info("Executing #{command}")
      pid, stdin, stdout, stderr = Open4::popen4(command)
      yield pid,stdin,stdout,stderr
    end

    def self.path_for(program)
      paths[program.to_sym]
    end    
    
    def self.make_command(command,*args)
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
    
    
    def self.make_args(args)
      args = [args] if !args.is_a?(Array)
      return nil if args.empty?
      args.join(' ')
    end
    
    
    # There is probably a better library to handle creation of command line flags,
    # but this works for now.
    def self.make_flags(options={})
      return nil if options.empty?
      options.collect{|k,v| "-#{k} #{v}"}.join(' ')
    end
        
    def self.logger
      @log ||= TimestampedBufferedLogger.new(Rails.root.join('log','image_genie.log'))
    end   
    
    def logger
      self.class.logger
    end     
  end
end