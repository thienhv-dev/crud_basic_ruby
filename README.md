# Building development environment

## Installation

First clone .env.example file to .env file. Something like this:
```shell
cp .env.example .env
```

**MUST** change the APP_CODE and COMPOSE_PROJECT_NAME that defines your application and error code of project.
```dotenv
APP_CODE=RB
COMPOSE_PROJECT_NAME=ruby
```
After that, lets following below command to build the docker containers:

*Note: If you are using M1 or M2 chip, let using this command `export DOCKER_DEFAULT_PLATFORM=linux/amd64` to set up docker compatible with your OS before building the containers.*
```shell
docker-compose build
```

## You need to install the Ruby dependencies (gems) by running:
```shell
docker-compose run --rm app bundle install
```

Waiting for a while to finish building containers. Then start run containers.
```shell
docker-compose up -d
```

You should be seen all containers state is `up`

#### Setup Ruby on Rails

Open workspace container then install bundler and rails gems.
```shell
docker exec -it {COMPOSE_PROJECT_NAME}_app bash
```
Open browser and type `localhost` then it should be load successful.
## Working with containers
### Database container

We recommended connect database by some tools:

- [DataGrip](https://www.jetbrains.com/datagrip/)
- [Mysql Workbench](https://www.mysql.com/products/workbench/)
- [DBeaver](https://dbeaver.io/)
- [Navicat](https://navicat.com/en/)

**NOT RECOMMENDED** use phpmyadmin to connect database because of the UI is too messy and the config is complex.

Tips: Some way to import data through docker container:

+ Using pv to import data with process pipe bar ([install pv](https://macappstore.org/pv/))
```shell
pv /path-to-your-file/data.sql | docker exec -i yourappname_db -u"root" -p app_db
```

+ Import file without pv
```shell
docker exec -i yourappname_db -u"root" -p app_db < /path-to-your-file/data.sql
```
### S3 bucket container

We are using [minio](https://min.io/docs/minio/container/index.html) to support storage objects with high performance. It provides an Amazon Web Services S3-compatible API and supports all core S3 features.

Site: `http://localhost:9001/login`
Login Info: `minio_access_key/minio_secret_key`

After login site, let create your bucket then update AWS_BUCKET value.

*Note: Must update env AWS_USE_PATH_STYLE_ENDPOINT=true and AWS_ENDPOINT=http://s3:9000 to using minio bucket on your local*

```dotenv
AWS_ACCESS_KEY_ID=minio_access_key
AWS_SECRET_ACCESS_KEY=minio_secret_key
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket
AWS_USE_PATH_STYLE_ENDPOINT=true
AWS_ENDPOINT=http://s3:9000
```

### Mailhog container

Access the site: `http://localhost:8025` to get your mailbox.

The .env variables should be config like this:

```dotenv
MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=info@example.com
MAIL_FROM_NAME="${APP_NAME}"
```

## Module Structure
```shell
modules/
├── user/
    ├── config/
    │  └── config.rb    #==> Declare all config of this module
    ├── database/
    │  ├── migrations/  #==> Contains all migration files
    │  └── seeders/     #==> Contains all seeder command
    ├── entities/       #==> Contains all model entry of this module
    ├── http/
    │  ├── controllers/ #==> Where we put all controller files to handler request
    │  ├── middleware/  #==> Contains all middleware if needed
    ├── routes/
    │  ├── api.rb       #==> Define all api route
    │  └── web.rb       #==> Define all web route
    ├── rules/          #==> Contains all validation rules
    ├── services/       #==> Where we put all service class to handler business logic
    ├── repositories/   #==> Repositories is used to abstract the data layer. Place of storage Business logic interacts to database
    ├── enums/          #==> Where we put all const used in module
    ├── Tests/  
    │  ├── feature/     #==> Write unit test as feature
    │  └── unit/        #==> Write unit test as unit
    ├── transformers/   #==> Contains all resource collection to format response   
```

### Some usually command when we're working with module

Example:

```shell
rails g modular:make ModuleName --api                                     Create a new Module with CRUD system
rails g modular:make_route ModuleName                                     Generate Route of module
rails g modular:make_config ModuleName                                    Generate Config file of module
rails g modular:make_migration create_abc_table ModuleName                Generate Migration of module
rails g modular:make_model ABC ModuleName                                 Generate Model of module
rails g modular:make_controller ABCController ModuleName                  Generate Controller of module
rails g modular:make_service ABCService ModuleName --with-base-repository Generate Service CRUD with base repository of module
rails g modular:make_repository ABCRepository ModuleName --model=ABC      Generate Repository of module
rails g modular:make_enum ABCEnum ModuleName                              Generate Enum of module
rails g modular:make_resource ABCResource ModuleName                      Generate Transformers of module
rails g modular:make_seed ABC ModuleName                                  Generate Seeder of module
```

Run command to seed data to database:
```shell
rails db:migrate                Run all migration
rails db:seed                   Run all seeder
rails db:seed:run[ModuleName]   Run seeder in modules
```

## Format error response:
The code information is in the file `config/locales/api.yml`
```json
{
  "error": {
    "status_code": 422,
    "code": "Unprocessable Content",
    "message": "Validation failed: Name is too long (maximum is 1 character), Description is too long (maximum is 1 character)",
    "error_code": "RB-422",
    "errors": [
      {
        "code": 1006,
        "field": "name",
        "message": "Name is too long (maximum is 1 character)"
      },
      {
        "code": 1006,
        "field": "description",
        "message": "Description is too long (maximum is 1 character)"
      }
    ]
  }
}
```
List validation code
```
  1000 => "The field is required",
  1001 => "The field is not valid",
  1002 => "The field must be accepted",
  1003 => "The field can't be blank",
  1004 => "The field must be present",
  1005 => "The field is too short",
  1006 => "The field is too long",
  1007 => "The field has wrong length",
  1008 => "The field is already taken",
  1009 => "The field is invalid",
  1010 => "The value is not included in the list",
  1011 => "The value is reserved",
  1012 => "The field is required",
  1013 => "The field is not a number",
  1014 => "The value must be greater than required",
  1015 => "The value must be greater than or equal to required",
  1016 => "The value must be equal to required",
  1017 => "The value must be less than required",
  1018 => "The value must be less than or equal to required",
  1019 => "The value must be other than restricted",
  1020 => "The value must be an integer",
  1021 => "The value must be odd",
  1022 => "The value must be even",
  1100 => "Record not found"
```