require 'open4'

# ImageGenie -- a simple wrapper for ImageMagick.
# Billy Kimble 2011

# Usage: 
#
# ImageGenie.convert(src=<File>, options)
#   converts a file at src.path with command line options given as options, and returns a handle to a tempfile containing the
#   contents of the converted file. Raises an exception with the errors if it can't find the file or has problems converting it.
#
# ImageGenie.montage(filenames=[], options)
#   combines all files contained in filenames into a montage (mosaic) image, and returns a tempfile handle to the contents of the montage.
#   Raises an exception with the errors if any 1 of the files in filenames has errors.
#
# ImageGenie.identify(filename=<String>, options)
#   identifies the file and returns a hash containing:
#   :filename, :format, :dimensions, :geometry, :bit, :image_class, :colors, :filesize, :usertime, :identify_time
#   Raises an exception with the errors if it can't find the file or has problems identfying it.
#
# ImageGenie.verify(filename=<String>, options)
#   verifies that the file pointed to by filename is valid. Returns true on success, or an an exception with the errors 
#  if it can't find the file or has problems identfying it
  
module ImageGenie
  class UnableToLocateBinaryError < StandardError; end;   
  # Autoload any modules defined in classes in the image_genie directory.
  module_path = [File.dirname(__FILE__),self.name.underscore,'*'].join('/')
  Dir[module_path].each do |file|
    constant_name = File.basename(file,'.rb').camelcase.to_sym
    autoload constant_name, file
  end
  
  module ClassMethods
    # Make helper methods
    [:convert,:montage,:identify,:verify].each do |method|
      define_method(method) do |*splat|
        module_name = "#{self.name}::#{method.to_s.capitalize}"
        target = module_name.constantize
        target.run(*splat)
      end
    end
  end
  
  class << self
    include ClassMethods
  end    
end

