require_relative 'lib/tinkoff_invest_api/version'

Gem::Specification.new do |spec|
  spec.name          = "tinkoff_invest_api"
  spec.version       = TinkoffInvestApi::VERSION
  spec.authors       = ["Alexandr Morozov"]
  spec.email         = ["morozvlg@gmail.com"]

  spec.summary       = "Tinkoff Invest API wrapper"
  spec.description   = "Tinkoff Invest API wrapper"
  spec.homepage      = "https://github.com/MoroZvlg/tinkoff_api"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 0.9"
  spec.add_development_dependency "webmock", "~> 3.0"
end
