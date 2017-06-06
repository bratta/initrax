# README

cp .env.production.sample .env.production
docker-compose build
docker-compose run --rm app rake secret      # For secret keys in env.production
docker-compose run --rm app rake db:migrate
docker-compose run --rm app rake assets:precompile
docker-compose up -d

