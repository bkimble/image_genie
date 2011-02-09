module ImageGenie
  class ConvertError < StandardError; end; 
  class Convert < Command
    attr_accessor :src, :temp_image_file, :options, :src_format

    def output
      while line = stdout.gets
        temp_image_file.puts line
      end
      temp_image_file.rewind
    end

    def initialize(src,options={})
      self.src = src
      self.options = options
      self.src_format = File.extname(src.path).downcase.gsub(/\.|\?/,'')
      logger.info("#{self.class.name} Attempting to convert #{src.path}")
      raise Errno::ENOENT,"#{src.path}" unless File.exists?(src.path)
      self.temp_image_file = Tempfile.new([src.original_filename,".#{src_format}"]) 
      super(self)
    end

    def run
      execute("#{path_for(:convert)} #{make_flags(options)} #{src_format}:#{src.path} #{src_format}:-")      
      temp_image_file
    end
  end
end
