web: ./bin/unicorn --config-file ./config/unicorn.rb --port 3000 --env development
worker: ./bin/sidekiq --concurrency 5 --environment development --queue emails,2 --queue calculations,1
