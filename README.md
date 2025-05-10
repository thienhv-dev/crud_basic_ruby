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

```shell
docker-compose build
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