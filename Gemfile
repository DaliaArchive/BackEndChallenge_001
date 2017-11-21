source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# NOTE: Why postgres and not sqlite or mongodb?
#       PostgreSQL supports both JSON and array datatypes. These are sufficient
#       to represent the custom attributs and change history that we want on
#       Guests. MongoDB would also suffice, but I find PostgreSQL overall to
#       be a more reliable data storage platform. Personal curiousity also
#       played a part: I haven't used postgresql's JSON capabilities too
#       extensively, and I want to learn more.
#
#       sqlite doesn't support JSON at all, so it wasn't even considered.
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # NOTE: Why not factory girl? I don't have a strong opinion, but in the past
  #       (over 5 years ago) I've run into a few hiccups with Factory Girl that
  #       I never ran into with Fabrication. Now it's just a habit to use this
  #       gem.
  gem 'fabrication'
  gem 'nyan-cat-formatter'
  # NOTE: Why rspec? Habit. I would be okay with other testing frameworks
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
