# bolao2014

The "bolão" software running powering [Bolão PiTTlândia Copa do Mundo 2014](http://bolao.pittlandia.net)

[![Build Status](https://travis-ci.org/rtopitt/bolao2014.svg?branch=master)](https://travis-ci.org/rtopitt/bolao2014)
[![Code Climate](https://codeclimate.com/github/rtopitt/bolao2014.png)](https://codeclimate.com/github/rtopitt/bolao2014)
[![Test Coverage](https://codeclimate.com/github/rtopitt/bolao2014/coverage.png)](https://codeclimate.com/github/rtopitt/bolao2014)

## Running on development

You will need:

- Ruby 2.1+
- PostgreSQL 9.3+
- Redis 2.8+

Clone the repo and setup `.env` with values for your environment (use `.env.example` as a starting point, changing the values where needed). If you use [direnv](https://github.com/zimbatm/direnv) (highly recommended), also use `.envrc.example` as a starting point to your `.envrc`.

Next run the standart Rails app seup:

```
$ bundle install
$ bin/rake db:setup
```

To start the app, run:

```
$ bin/foreman start
```

## Testing

Simply run:

```
$ bin/rake spec
```

## Contributing

Read [TODO.md](https://github.com/rtopitt/bolao2014/blob/master/TODO.md) to see what needs to be done still if you would like to contribute. Then fork this repo, make your changes on your fork in a topic branch and submit a pull request against this repo's master branch.

Please write all code, comments, tests and commit messages in english. Use 2 spaces to indent code and follow idiomatic Ruby as close as possible. No CoffeeScript, please.
