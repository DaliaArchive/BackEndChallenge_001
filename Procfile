web: env DB_POOL=${WEB_DB_POOL:-5} bundle exec puma -t ${WEB_THREADS:-10}:${WEB_THREADS:-10} -w ${WEB_PROCESSES:-2} -p $PORT -e ${RACK_ENV:-development}

postgres_dev: pg_ctl -D "${PG_DIR:-/usr/local/var/postgres}" stop -s -m fast ; postgres -D "${PG_DIR:-/usr/local/var/postgres}"

tail_log: test -z $SKIP_RAILS_LOG && tail -0f log/development.log || read
