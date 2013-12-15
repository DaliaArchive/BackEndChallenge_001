# Design decisions

- Have used rvm to lock the ruby version to 2.0 and a separate gemset.
- Have used rails-api gem for building the api and could have very well used sinatra which is much more light-weight, but i prefer the rails conventions and defaults around different environment modes, auto-reloading, security, caching, logging, routing etc and went ahead with it.
- For low loads both rails-api and sinatra are comparable. eg: https://gist.github.com/Lightpower/4251638. For a production system design i would let the complexity of the problem statement, expected traffic, and availability of hardware resources drive the framework choice. For a traffic intensive endpoint with a lot of blocking i/o exploring event loops based on event machine could be an option to improve throughput from the same hardware. In any case you should pick up something you and the team are most comfortable with to churn out the features quicky and get initial feedback. Essentially choose whatever makes you move fast and fail fast and let the application stats drive your technology choices of the future.
- Given that we do not have a list of pre-defined attributes for storing robot details, i went ahead with choosing mongodb document store over relational mysql store giving me the flexibility to store any key value pairs for a robot without having to worry about defining a fixed schema and focus on aggregates.
- I have used the mongoid driver to talk to mongodb.
- I have used rspec as the testing framework test driving my routes and actions which return simple json responses.
- For storing the audit trail for robots i had the option of either storing the history within each document or storing it in a separate collection. I went ahead with a separate collection to avoid worrying about the document size limit storing historic change data over a long period of time and traded off an extra write.
- From an API perspective there are a lot of things to consider around security, access control, versioning, throttling which i have not gone into given the nature of the problem.


# Instructions to run

- Install mongodb and run the mongo server
- cd into the directory and if you have rvm installed .rvmrc will set the right ruby and gemset version.
- gem install bundler
- bundle install
- bundle exec rspec (to run all the specs)
- bundle exec rails s (to run the default webrick server)
- run ./test_api to simulate all the robot api endpoints.



