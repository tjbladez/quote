require 'rake'

Gem::Specification.new do |s|
  s.name = %q{quote}
  s.version = '0.1.0'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['tjbladez']
  s.date = %q{2010-08-25}
  s.description = %q{Quotes - maintain them, get them conviniently from command line}
  s.email = %q{tjbladez@gmail.com}
  s.files = FileList['{bin,lib}/**/*', 'README.markdown'].to_a
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables = %w{quote}
  s.default_executable = 'bin/quote'
  s.homepage = %q{http://github.com/tjbladez/quote}
  s.summary = %q{Awesome quotes from different sources}
  s.post_install_message = %q{You are now ready to enjoy and maintain your quotes}
end