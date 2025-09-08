# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
## Devlog:

# Level 1:

The application setup was okay, I'm using WSL 2 on a Windows 11 machine, developing in Ruby on Rails, I opted for a Postgres DB and containerized development environment using Docker.

There were some pitfalls in the interaction between these systmes, but in the end the application was set up and running fine. For level 1 the creation of models, controllers and even view using Jbuilder was standard procedure. As were the migrations. The integration with Rspec for unit testing was smooth. 

The only persistant issue at this stage is that "menus_spec.rb" tests are failing, these correspond to the "Menu" class endpoints in "/api/menus_controller.rb". I'm getting hit with a 403 forbidden, which is unexpected since I haven't implemented any authentication in this project. After a LOT of research and testing, I'm still not able to figure out what's happening, something tells me it's just a local problem, so I'll continue developing the next levels features and once I have all tests created, I'll focus on making them work properly. That aside, all other tests pass with flying colors, deeming the end of Level 1.

# Level 2:

# Level 3:

## Useful quick commands:

docker-compose build --no-cache

docker-compose run --rm app bundle install

docker-compose up -d

docker-compose exec app bundle exec rails db:create

docker-compose down -v

docker-compose rm