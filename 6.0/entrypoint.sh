#!/bin/bash

echo "Starting redmine ..."

bundle config set --local without 'development test'
bundle config set --local path '/home/redmine/.local/share/gem'

if [ -z ${REDMINE_LANG} ]; then
    REDMINE_LANG=EN
fi

#
# generate configuration files according to environment variables
#
if [ -z "${DATABASE_ADAPTER}" ]; then
  echo "DATABASE_ADAPTER is not set"
  exit 1
fi

if [ "${DATABASE_ADAPTER}" == "sqlite3" ]; then

    if [ -z ${SQLITE_FILE} ]; then
        echo "SQLITE_FILE is not set"
        exit 1
    fi

    echo "Generating configuration for sqlite3..." 
    echo "production:" > config/database.yml
    echo -e " adapter: sqlite3" >> config/database.yml
    echo -e " database: ${SQLITE_FILE}" >> config/database.yml

elif [ "${DATABASE_ADAPTER}" == "mysql" ]; then
    if [ -z ${MYSQL_PORT} ]; then   
        MYSQL_PORT=3306
    fi

    if [ -z ${MYSQL_USER} ]; then
        MYSQL_USER="redmine"
    fi

    if [ -z ${MYSQL_DB} ]; then 
        MYSQL_DB="redmine"
    fi

    if [ -u ${MYSQL_HOST} ]; then
        echo "please provide mysql server hostname/ip in MYSQL_HOST"
        exit 1
    fi

    if [ -u ${MYSQL_PASSWORD} ]; then
        echo "please provide mysql password in MYSQL_PASSWORD"
        exit 1
    fi

    echo "Generating configuration for mysql2..." 
    echo "production:" > config/database.yml
    echo -e " adapter: mysql2" >> config/database.yml
    echo -e " database: ${MYSQL_DB}" >> config/database.yml
    echo -e " host: ${MYSQL_HOST}" >> config/database.yml
    echo -e " port: ${MYSQL_PORT}" >> config/database.yml
    echo -e " username: ${MYSQL_USER}" >> config/database.yml
    echo -e " password: ${MYSQL_PASSWORD}" >> config/database.yml
    echo -e " variables:" >> config/database.yml
    echo -e '  transaction_isolation: "READ-COMMITTED"' >> config/database.yml

elif [ "${DATABASE_ADAPTER}" == "postgres" ]; then

    if [ -z ${PSQL_PORT} ]; then   
        PSQL_PORT=3306
    fi

    if [ -z ${PSQL_USER} ]; then
        PSQL_USER="redmine"
    fi

    if [ -z ${PSQL_DB} ]; then 
        PSQL_DB="redmine"
    fi

    if [ -u ${PSQL_HOST} ]; then
        echo "please provide postgresql server hostname/ip in PSQL_HOST"
        exit 1
    fi

    if [ -u ${PSQL_PASSWORD} ]; then
        echo "please provide postgresql password in PSQL_PASSWORD"
        exit 1
    fi

    echo "Generating configuration for postgresql..." 
    echo "production:" > config/database.yml
    echo -e " adapter: postgresql" >> config/database.yml
    echo -e " database: ${PSQL_DB}" >> config/database.yml
    echo -e " host: ${PSQÖ_HOST}" >> config/database.yml
    echo -e " port: ${PSQL_PORT}" >> config/database.yml
    echo -e " username: ${PSQL_USER}" >> config/database.yml
    echo -e " password: ${PSQL_PASSWORD}" >> config/database.yml
    echo -e " encoding: utf8" >> config/database.yml
fi




if [ -n "${SIDEKIQ}" ]; then
    if [ "${SIDEKIQ}" == "true" ]; then
        echo "Setting up sidekiq configuration ..."
    
        if [ -z ${REDIS_URL} ]; then
            echo "sidekiq needs redis please provide redis URL in REDIS_URL"
            exit 1
        fi
    fi
fi

if [ -n "${USE_SIDEKIQ}" ]; then
    echo 'config.active_job.queue_adapter = :sidekiq' >> config/additional_environment.rb
fi


#
# set up logging
#

#echo 'config.log_path = "/dev/stdout"' >> config/additional_environment.rb
#echo 'config.log_level = :info'  >> config/additional_environment.rb


#
# redmine requires database initialization on the first run and selecting the first default language
# to identify a "first" run we check for an .initialized file in the file directory. This directory
# has to be mapped to any kind of persitent storage otherwise the application will be initialized
# again and again
#
if [ ! -e "files/.initialized" ]; then
    echo "Initializing Redmine ..."
    bundle exec rake generate_secret_token
    RAILS_ENV=production bundle exec rake db:migrate
    RAILS_ENV=production REDMINE_LANG=${REDMINE_LANG} bundle exec rake redmine:load_default_data
    RAILS_ENV=production bundle exec rake redmine:plugins:migrate
    
    cp config/initializers/secret_token.rb files/.initialized
fi

if [ -n "${SIDEKIQ}" ]; then
    if [ "${SIDEKIQ}" == "true" ]; then
        echo "Starting Sidekiq for Redmine"
        RAILS_ENV=production bundle exec sidekiq
        exit 0
    fi
fi


cp files/.initialized config/initializers/secret_token.rb


RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake redmine:plugins:migrate
RAILS_ENV=production bundle exec rake assets:precompile

bundle exec rails server -e production