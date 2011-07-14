# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rios}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["mooz"]
  s.date = %q{2011-07-15}
  s.default_executable = %q{script.rb}
  s.description = %q{Rios is a proxy framework which works as a proxy
 for command line applications and allows developer to hook input/output
 of the applications in a blazingly simple way.}
  s.email = %q{stillpedant@gmail.com}
  s.executables = ["script.rb"]
  s.extensions = ["ext/rios/extconf.rb"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Rakefile",
    "VERSION",
    "bin/script.rb",
    "ext/rios/extconf.rb",
    "ext/rios/util.c",
    "ext/rios/util.h",
    "lib/rios.rb",
    "lib/rios/proxy.rb",
    "lib/rios/terminal.rb",
    "rios.gemspec"
  ]
  s.homepage = %q{https://github.com/mooz/rios}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A proxy framework for command line interfaces}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-termios>, [">= 0.9.6"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<ruby-termios>, [">= 0.9.6"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby-termios>, [">= 0.9.6"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
