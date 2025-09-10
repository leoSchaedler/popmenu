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

I continued development keeping in mind the challenges requirements. I created the Restaurant Class and thought about how it would interact with the existing classes. The MenuItem name uniqueness and possibility of it being in many menus in the same restaurant were the big factors in choosing how to proceed development. In order to adhere to these rules, I created the Class MenuItemization, which is an association table that belongs to both menu and menu_item, bonding those two toghether. This approach enables one MenuItem object to "be in" many Menus objects via the association table, however for that logic to work, MenuItem couldn't belong to Menu anymore. That left the option of making it so that both Menu and MenuItem belonged to a Restaurant, which makes sense really, a Restaurant isn't supposed to get rid of dishes simply because they're changing they're menu.

With this direction in mind, I continued development on all sides: MVC with Jbuilder views, routing changes, factories, model and requests endpoints tests via RSpec. Which threw me in the same dillemma I finished Level 1 with: RSpec 403 Forbidden flags for request endpoints tests. In trying to fix this issue, I discovered a few oversights left over from Level 1: Controllers without the properly scoped Module (api), the same problem for the views and also discovred some misnamed files, with all that fixed and a lot of tests later, I discovered the problem: RSpec was running in the development environment and even when running on test env, the default "www.example.com" URL was not being allowed. So I created a RSpec Support Helper in order to enable this address when testing with the tool. After that, tweaks and changes to the tests were made in order to better represent the expected results and I'm happy to say all test are A-Okay at this point.

I also created a file that automatically sets the right environment for tests and runs rspec, it's located at: 'bin/rspec'.

One small note: Routes were kept nested and global for testing and debugging purposes, in reality some of the routs at this point would not be necessary and would be cut off for production environments.

Moving on to Level 3!

# Level 3:

## Useful quick commands:

docker-compose build --no-cache

docker-compose run --rm app bundle install

docker-compose up -d

docker-compose exec app bundle exec rails db:create

docker-compose down -v

docker-compose rm

docker-compose exec app bash -> bin/rspec