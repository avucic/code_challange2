# Task

## NOTE:

The task is done based on the given instructions to cover as much as possible given requirements.
In "real life" situation, some things would be done differently.

Also it's not covered 100% with specs because to be done with production quality
it would take a lot of time. So some errors may occur.

It is also possible that business logic deviates from the given instructions because of my misunderstanding.
For example transactions flow: can initial transaction goes after invalidation or settlement etc.

Regarding the API and session some things are not implemented like for example refresh token logic
or merchant username/password sign functionality because is not required.

For demo purpose, there is a workaround and it's possible to sign in via token.

Generate api token, and use it to create session on `/login` page.

## Setup

Install all gems and create db's

```
bundle install
bundle exec rails db:create db:migrate db:seed
```

Make sure that all is green

```
# rails complains without this. Have to check

bundle exec rails db:environment:set RAILS_ENV=test
bundle exec rspec spec
```

Run server

```
bundle exec rails s
```

## Importing csv data run:

```
rake data:import_merchants\['db/seeds/data.csv']
```

## Generate API token

```
rake api:token\['admin@example.com']
```

## Run background jobs

```
bundle exec whenever
```

## API

### Example of JSON request

```
curl -X POST -d '{"transaction":{"amount":100.0,"type":"refund"}}' -H "Content-Type:application/json;charset=UTF-8" -H 'Accept: application/json' -H "Authorization:<token>" http://localhost:3000/api/v1/transactions
```

### Example of XML request

```
curl -X POST -d '<transaction><amount>100.0</amount><type>refund</type></transaction>' -H "Content-Type:text/xml;charset=UTF-8" -H 'Accept: application/xml' -H "Authorization:<token>" http://localhost:3000/api/v1/transactions
```
