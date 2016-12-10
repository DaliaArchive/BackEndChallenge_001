# BackEnd Challenge 001

## 1. Dependencies
The application runs on:
- Ruby 2.3.x
- RubyGems
- Bundler gem
- Ruby on Rails 5
- MongoDB
- Mongoid 6

## 2. Running the application

### 2.1 With Docker
The application is configured to run with Docker.
You need to have both Docker Engine and Docker Compose installed.
Then build the application container and run it.

#### 2.1.1 Build the application container
From the root path of the application, run:
```
docker-compose build
```

Wait for the build to be finished.

#### 2.1.2 Create data
To create the databases and seed them, from the root path of the application, run:
```
docker-compose run web rake db:create
docker-compose run web rake db:seed
```

#### 2.1.3 Start the application
From the root path of the application, run:
```
docker-compose up
```

The application is up and running.
To access the application, go to `http://localhost:3000` on your web browser.

### 2.2 Manually
You must have the following dependencies installed:
- Ruby 2.3.x
- RubyGems
- Bundler gem
- MongoDB

#### 2.2.1 Configure database credentials
Conigure credentials for database access on `config/mongoid.yml` file.

#### 2.2.2 Install all gems
From the root path of the application, run:
```
bundle install
```

#### 2.2.3 Create data
To create the databases and seed them, from the root path of the application, run:
```
bundle exec rake db:create
bundle exec rake db:seed
```

#### 2.1.3 Start the application
From the root path of the application, run:
```
bundle exec rails s
```

The application is up and running.
To access the application, go to `http://localhost:3000` on your web browser.

## 3. API routes

### 3.1 Robots List
##### URI
```
GET /robots
```

### 3.2 Robot Attributes
##### URI
```
GET /robots/:id
```

### 3.3 Update Robot Attributes
##### URI
```
PUT/PATCH /robots/:id
```
##### Payload
```
{
  robot: {
    attributes: {
      <attribute_name:String>: <attribute_value:String>,
      <attribute_name:String>: <attribute_value:String>,
      ...
    }
  }
}
```

### 3.4 Robots History
```
GET /robots/:id/histories
```
