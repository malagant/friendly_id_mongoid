require File.expand_path('../lib/friendly_id/mongoid_adapter/version', __FILE__)

spec = Gem::Specification.new do |s|
  s.name              = "friendly_id_mongoid"
  s.rubyforge_project = "[none]"
  s.version           = FriendlyId::MongoidAdapter::Version::STRING
  s.authors           = ["Michael Johann"]
  s.email             = ["mjohann@rails-experts.com"]
  s.homepage          = "http://github.com/malagant/friendly_id_mongoid"
  s.summary           = "A mongoid adapter for FriendlyId"
  s.description       = "An adapter for using Mongoid::Document with FriendlyId."
  s.has_rdoc          = true
  s.test_files        = Dir.glob "test/**/*_test.rb"
  s.files             = Dir["lib/**/*.rb", "lib/**/*.rake", "*.md", "MIT-LICENSE", "Rakefile", "test/**/*.*"]
  s.add_dependency    "friendly_id",    "~> 3.1.0"
  s.add_dependency    "mongoid", "2.0.0.beta.18"
end
