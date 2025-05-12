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
Modules/
├── User/
    ├── Config/
    │  └── config.php   #==> Declare all config of this module
    ├── Database/
    │  ├── Migrations/  #==> Contains all migration files
    │  └── Seeders/     #==> Contains all seeder command
    ├── Entities/       #==> Contains all model entry of this module
    ├── Http/
    │  ├── Controllers/ #==> Where we put all controller files to handler request
    │  ├── Middleware/  #==> Contains all middleware if needed
    │  └── Requests/    #==> Contains all request validation
    ├── Routes/
    │  ├── api.php      #==> Define all api route
    │  └── web.php      #==> Define all web route
    ├── Rules/          #==> Contains all validation rules
    ├── Services/       #==> Where we put all service class to handler business logic
    ├── Repositories/   #==> Repositories is used to abstract the data layer. Place of storage Business logic interacts to database
    ├── Enums/          #==> Where we put all const used in module
    ├── Tests/  
    │  ├── Feature/     #==> Write unit test as feature
    │  └── Unit/        #==> Write unit test as unit
    ├── Transformers/   #==> Contains all resource collection to format response   
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
```