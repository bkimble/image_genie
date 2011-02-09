# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{image_genie}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Billy Kimble"]
  s.date = %q{2011-02-08}
  s.description = %q{ImageGenie - Simple Wrapper for command line ImageMagick}
  s.email = %q{basslines@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/image_genie.rb", "lib/image_genie/base.rb", "lib/image_genie/command.rb", "lib/image_genie/convert.rb", "lib/image_genie/identify.rb", "lib/image_genie/montage.rb", "lib/image_genie/verify.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "lib/image_genie.rb", "lib/image_genie/base.rb", "lib/image_genie/command.rb", "lib/image_genie/convert.rb", "lib/image_genie/identify.rb", "lib/image_genie/montage.rb", "lib/image_genie/verify.rb", "test/test_helper.rb", "test/unit/base_test.rb", "image_genie.gemspec"]
  s.homepage = %q{https://github.com/bkimble}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Image_genie", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{image_genie}
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{ImageGenie - Simple Wrapper for command line ImageMagick}
  s.test_files = ["test/test_helper.rb", "test/unit/base_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<open4>, [">= 0"])
    else
      s.add_dependency(%q<open4>, [">= 0"])
    end
  else
    s.add_dependency(%q<open4>, [">= 0"])
  end
end
