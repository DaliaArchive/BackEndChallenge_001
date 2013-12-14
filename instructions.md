# Design decisions

- I have used rvm to set the ruby version and the gemset.
- I have picked up the rails-api gem for building the api which is a stripped down version of rails, instead of something like sinatra. I like the rails conventions and those default work well for building an API sans the UI/View code.
- From a performance point of view as well both rails-api and sinatra are comparable. eg: https://gist.github.com/Lightpower/4251638
- Given that we do not have a list pre-defined attributes for storing robot details, i went ahead with choosing mongodb document store over mysql giving me the flexibility to store any key values for a robot.
- I have used the mongoid driver to talk to mongodb.
- I have used rspec as the testing framework test driving my routes and actions which return simple json responses.
- For storing the audit trail for robots i had the option of either storing the history within each document or storing it in a separate collection. I went ahead with a separate collection to avoid worrying about the document size storing historic change data over a long period of time and traded off an extra write.
- From an API perspective there are a lot of things to consider around security, access control, versioning, throttling which i have not gone into given the nature of the problem.


# Instructions to run

- Install mongodb and run the mongo server
- cd into the directory and if you have rvm installed .rvmrc will set the right ruby and gemset version.
- gem install bundler
- bundle install
- bundle exec rspec (to run all the specs)
- bundle exec rails s (to run the default webrick server)
- run ./test_api to simulate all the robot api endpoints.



