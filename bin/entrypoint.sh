#!/bin/bash -e

# If running the rails server then create or migrate existing database
if [ "${*}" == "./bin/bot" ]; then
  ./bin/rake db:migrate
fi

exec "${@}"
