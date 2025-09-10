# README

# Restaurant Importer API

A Ruby on Rails application to manage restaurants, menus, and menu items.
Includes a JSON importer service to create restaurants, menus, and menu items in bulk, with logging of successes, duplicates, and conflicts.

Part of a recruitment challenge for the company Popmenu.
---

## Table of Contents

* [Ruby Version](#ruby-version)
* [System Dependencies](#system-dependencies)
* [Configuration](#configuration)
* [Database Creation and Initialization](#database-creation-and-initialization)
* [Running the Test Suite](#running-the-test-suite)
* [Services](#services)
* [Importer Tool usage](#importer-tool-usage)
* [Sample JSON Structure](#sample-json-structure)
* [API Endpoints](#api-endpoints)
* [Deployment](#deployment)
* [Notes](#notes)
* [Devlog](#devlog)
* [Quick Commands](#useful-quick-commands)

---

## Ruby Version

```bash
ruby 3.3.0
Rails 8.0.2.1
```

---

## System Dependencies

* PostgreSQL (or your preferred Rails-supported database)
* Bundler 2.7.1 (or as specified in `Gemfile.lock`)

---

## Configuration

1. Clone the repository:

```bash
git clone https://github.com/leoSchaedler/popmenu.git
cd popmenu
```

2. Install dependencies:

```bash
bundle install
```

3. Copy the environment file and configure secrets:

```bash
cp .env.example .env
```

4. Fill in database credentials in DB viewer of your choice:

```bash
POSTGRES_USER: popmenu
POSTGRES_PASSWORD: popmenu
```

By default this project was developed using Docker and both default Postgres and localhost ports were shifted by 1:

* db port: 5432 -> 5433
* app port: 3000 -> 3001

This was due to conflict in other applications running in the development machine. If you're planning on using Docker and don't need these changes, they can be altered in `docker-compose.yml` in lines 6 and 21, respectively.

---

## Database Creation and Initialization

Create and migrate the database:

Using Docker:

```bash
docker-compose run --rm app rails db:create db:migrate db:seed
```

Locally (without Docker):

```bash
rails db:create db:migrate db:seed
```

The database includes four primary models:

1. `Restaurant` – has many `Menu`s and `MenuItem`s through menus.
2. `Menu` – belongs to a restaurant, has many `MenuItem`s via `MenuItemization`.
3. `MenuItem` – belongs to a restaurant, can belong to multiple menus via `MenuItemization`.
4. `MenuItemization` - Serves as an association table for `MenuItem` and `Menu`.

---

## Running the Test Suite

This project uses RSpec for unit and request specs:

With Docker:

```bash
docker-compose run --rm app bundle exec rspec
```

Locally:

```bash
bundle exec rspec
```

* Tests cover the importer service, API endpoints, and model relationships.
* JSON test files for the importer are stored in `spec/fixtures` for local testing.

---

## Services

* The project does not rely on background job queues for the importer (it runs synchronously).
* No external cache or search engines are required for basic functionality.
* The importer logs successes, conflicts, and duplicates for user visibility.

---

## Importer Tool Usage

### Web Interface

* Access the importer page at `/api/imports/new`, default at `http://localhost:3001/api/imports/new`.
* Upload a JSON file containing restaurants, menus, and menu items, such as the one provided for the challenge or any of the ones in `spec/fixtures`.
* View detailed logs of imported objects, duplicates, and conflicts.

### Via Rake:

With Docker:

```bash
docker-compose run --rm app rake import:restaurant FILE=spec/fixtures/og_restaurant_data.json
```

Locally:

```bash
# Default file
rails import:restaurant

# From a directory of JSON files
DIR=spec/fixtures rails import:restaurant

# Multiple files
FILES=spec/fixtures/og_restaurant_data.json,spec/fixtures/valid_restaurant_data.json rails import:restaurant

# Single file
FILE=spec/fixtures/og_restaurant_data.json rails import:restaurant
```
Via Curl:
```bash
curl -H "Accept: application/json" -F "file=@spec/fixtures/og_restaurant_data.json" http://localhost:3001/api/imports
```

Using directories, multiple files and default files is also supported via Docker, just adjust the command accordingly.

The importer supports:

* Restaurants without descriptions (defaults to `"No description provided"`)
* Menus without descriptions (defaults to `"No description provided"`)
* Menu items without descriptions or price (defaults to `"No description provided"` and `"No price provided"`)
* Prevents creation of objects without names to ensure uniqueness and a stable structure.

---

## Sample JSON Structure

```json
{
  "restaurants": [
    {
      "name": "Poppo's Cafe",
      "description": "Cozy cafe",
      "menus": [
        {
          "name": "Lunch",
          "menu_items": [
            { "name": "Burger", "description": "Beef burger", "price": 10.0 },
            { "name": "Salad", "price": 5.0 }
          ]
        },
        {
          "name": "Dinner",
          "menu_items": [
            { "name": "Burger", "price": 10.0 },
            { "name": "Steak", "price": 15.0 }
          ]
        }
      ]
    }
  ]
}
```
## API Endpoints

### Restaurant Items
- `GET /api/restaurants/:restaurant_id/menus/:menu_id/menu_items` → `api/menu_items#index`  
  Returns all menu items for a specific menu.

- `POST /api/restaurants/:restaurant_id/menus/:menu_id/menu_items` → `api/menu_items#create`  
  Creates a new menu item under a specific menu.

- `GET /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id` → `api/menu_items#show`  
  Returns details for a specific menu item.

- `PATCH /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id` → `api/menu_items#update`  
  Updates a specific menu item.

- `PUT /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id` → `api/menu_items#update`  
  Updates a specific menu item.

- `DELETE /api/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id` → `api/menu_items#destroy`  
  Deletes a specific menu item.

### Menus
- `GET /api/restaurants/:restaurant_id/menus` → `api/menus#index`  
  Lists all menus for a specific restaurant.

- `POST /api/restaurants/:restaurant_id/menus` → `api/menus#create`  
  Creates a new menu under a specific restaurant.

- `GET /api/restaurants/:restaurant_id/menus/:id` → `api/menus#show`  
  Returns details for a specific menu.

- `PATCH /api/restaurants/:restaurant_id/menus/:id` → `api/menus#update`  
  Updates a specific menu.

- `PUT /api/restaurants/:restaurant_id/menus/:id` → `api/menus#update`  
  Updates a specific menu.

- `DELETE /api/restaurants/:restaurant_id/menus/:id` → `api/menus#destroy`  
  Deletes a specific menu.

### Restaurant-level Menu Items
- `GET /api/restaurants/:restaurant_id/menu_items` → `api/menu_items#index`  
  Returns all menu items belonging to a restaurant.

- `POST /api/restaurants/:restaurant_id/menu_items` → `api/menu_items#create`  
  Creates a new menu item for the restaurant (linked via MenuItemization if attached to menus).

- `GET /api/restaurants/:restaurant_id/menu_items/:id` → `api/menu_items#show`  
  Returns details for a specific menu item of the restaurant.

### Restaurants
- `GET /api/restaurants` → `api/restaurants#index`  
  Lists all restaurants.

- `POST /api/restaurants` → `api/restaurants#create`  
  Creates a new restaurant.

- `GET /api/restaurants/:id` → `api/restaurants#show`  
  Returns details for a specific restaurant, including menus and menu items.

- `PATCH /api/restaurants/:id` → `api/restaurants#update`  
  Updates a specific restaurant.

- `PUT /api/restaurants/:id` → `api/restaurants#update`  
  Updates a specific restaurant.

- `DELETE /api/restaurants/:id` → `api/restaurants#destroy`  
  Deletes a specific restaurant.

### Imports
- `POST /api/imports` → `api/imports#create`  
  Uploads a JSON file to import restaurants, menus, and menu items.

- `GET /api/imports/new` → `api/imports#new`  
  Renders the file upload form for importing data.

## Deployment

1. Configure your production environment database.
2. Precompile assets (if applicable):

```bash
rails assets:precompile
```

3. Run database migrations in production:

```bash
rails db:migrate RAILS_ENV=production
```

4. Start the server:

```bash
rails server -e production
```

5. In theory...

* ...these would be the steps, however production deployment is not a scope of this project.
* So this section is here for general deployment information only.
---

## Notes

* JSON must be valid, otherwise the importer returns a parse error.
* Duplicate menu items in the same menu are skipped and logged as errors.
* Conflicts (menu items belonging to another restaurant) are logged but do not break the import.
* Each restaurant must have a `name`. Descriptions are optional.
* Each menu must have a `name`. Descriptions are optional.
* Menu items must have a `name`. Descriptions and prices are optional.
* Duplicate menu items in the same menu will be skipped and logged.
* Conflicting menu items (already belonging to another restaurant) are logged as errors but imported successfully otherwise.

---

# Devlog:

## Level 1:

The application setup was okay, I'm using WSL 2 on a Windows 11 machine, developing in Ruby on Rails, I opted for a Postgres DB and containerized development environment using Docker.

There were some pitfalls in the interaction between these systmes, but in the end the application was set up and running fine. For level 1 the creation of models, controllers and even view using Jbuilder was standard procedure. As were the migrations. The integration with Rspec for unit testing was smooth. 

The only persistant issue at this stage is that "menus_spec.rb" tests are failing, these correspond to the "Menu" class endpoints in "/api/menus_controller.rb". I'm getting hit with a 403 forbidden, which is unexpected since I haven't implemented any authentication in this project. After a LOT of research and testing, I'm still not able to figure out what's happening, something tells me it's just a local problem, so I'll continue developing the next levels features and once I have all tests created, I'll focus on making them work properly. That aside, all other tests pass with flying colors, deeming the end of Level 1.

## Level 2:

I continued development keeping in mind the challenges requirements. I created the Restaurant Class and thought about how it would interact with the existing classes. The MenuItem name uniqueness and possibility of it being in many menus in the same restaurant were the big factors in choosing how to proceed development. In order to adhere to these rules, I created the Class MenuItemization, which is an association table that belongs to both menu and menu_item, bonding those two toghether. This approach enables one MenuItem object to "be in" many Menus objects via the association table, however for that logic to work, MenuItem couldn't belong to Menu anymore. That left the option of making it so that both Menu and MenuItem belonged to a Restaurant, which makes sense really, a Restaurant isn't supposed to get rid of dishes simply because they're changing they're menu.

With this direction in mind, I continued development on all sides: MVC with Jbuilder views, routing changes, factories, model and requests endpoints tests via RSpec. Which threw me in the same dillemma I finished Level 1 with: RSpec 403 Forbidden flags for request endpoints tests. In trying to fix this issue, I discovered a few oversights left over from Level 1: Controllers without the properly scoped Module (api), the same problem for the views and also discovred some misnamed files, with all that fixed and a lot of tests later, I discovered the problem: RSpec was running in the development environment and even when running on test env, the default "www.example.com" URL was not being allowed. So I created a RSpec Support Helper in order to enable this address when testing with the tool. After that, tweaks and changes to the tests were made in order to better represent the expected results and I'm happy to say all test are A-Okay at this point.

I also created a file that automatically sets the right environment for tests and runs rspec, it's located at: 'bin/rspec'.

One small note: Routes were kept nested and global for testing and debugging purposes, in reality some of the routs at this point would not be necessary and would be cut off for production environments.

Moving on to Level 3!

## Level 3:

At first Level 3 seemed a bit daunting, however getting into it proved to be more fun and rewarding than expected. Doing something different other than dealing with mundande MVC structures and weird RSpec errors was a great change of pace. Although the challenge description allows for model and validation change in order for the importer tool to work, I set out with the goal of building my importer tool around what was already created, adjusting it as necessary instead of messing with already tested and established code of the previous 2 levels.

That proved to pay off. I tackled this challenge in four different fronts:

* Imports Controller

Provided a controller to manage both new and create routes I needed in order to deal with both ways I perceived the tool could be used for testing: a Web page with a file form or via command line.

* Restaurant Importer Service

Kept business rules outside of the controller's scope and does the bulk of operations needed in order accept, parse and extract data from the JSON file provided. It is neatly structured with separated functions for each object import and also has a centralized logging system to help out in logging the full operations of the import proccess.

* views/api/imports/new.html.erb

Builds a simple HTML web page with a file formulary that allows testing of the importer tool in a graphical interface.

* lib/tasks/import.rake

Allows for testing of the importer tool outside of HTTP requests, via command line. Supports individual file imports, as well as multiple files and even directories of files.

With all these functional and tested, I moved on the unit tests which successufuly passed. These tests as well as in development and earlier tests I tried to keep in mind all the requirements of this level and account for other obvious validations, such as duplication, within the imports.

Some of the JSON structures provided lacked some required attributes, this left me with two choices, I could loosen the validations, however that didn't feel right, since this application could have a web interface in the future and having loose validations would cause all sorts of problems down the road, so I opted for placeholder information in 'description' and 'price' attributes, since the most important attribute, especially for MenuItems is the Name, plus descriptions and prices can change all the time, so leaving them with placeholders, when needed, didn't feel wrong.

This was by far the most rewarding part of the challenge because I could see that all the previous work was solid and paid off, because everything was working as it should.

# Level X:

After finishing Level 3, I saw a clear path of where this project could go: Create a robust front end with CRUD structures for all objects, create views to visualize menus in an interactive way, all that would require tweaks and additions in the back end, such as more attributes for each object, like images for instance.

In the end, it was a fun challenge to take part in and I hope it has been fun to evaluate me ! :)

# Useful quick commands:

docker-compose build --no-cache

docker-compose run --rm app bundle install

docker-compose up -d

docker-compose exec app bundle exec rails db:create

docker-compose down -v

docker-compose rm

docker-compose exec app bash -> bin/rspec

docker-compose exec app bundle exec rails db:seed

curl -H "Accept: application/json" -F "file=@spec/fixtures/og_restaurant_data.json" http://localhost:3001/api/imports