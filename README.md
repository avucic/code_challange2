# Task
## Goal
Create a mock payment system:

1. Relations:
     - Merchants have many payment transactions of different types
     - Transactions are related (belongs_to)

     - You can also have follow/referenced transactions that refer/depend to/on the initial transaction

     - Example:
       - Initial Transaction -> Settlement (Charge) Transaction -> Refund Transaction
       - Initial Transaction -> Invalidation (Cancel) Transaction
     - Destroys all transactions, if merchant is deleted Has merchant and admin user roles (UI) (optional)
2. Model fields:
     - Merchant: name, description, email, status (active, inactive), total transaction sum (of all transactions)
     - Transaction: UUID, amount, status (processed, error)
3. Inputs and tasks:
    - Accepts payments using XML/JSON API (single point POST request) Include API authentication layer (basic auth, Token-based etc)
    - Imports new merchants from CSV (rake task)
    - Has background job deleting transactions older than an hour (cron job)
4. Presentation:
    - Display, edit, destroy merchants
    - Display transactions

## Technical requirements
1. Use the latest stable Rails version
2. Use Slim view engine
3. Frontend Framework (optional)
    - React JS
    - Angular
4. Cover all changes with Rspec tests
5. Add integration tests via Capybara
6. Create factories with FactoryBot
7. Apply Rubocop and other linters
8. For Rails models try to use:
    -  STI
    -  Scopes
    -  Validations and custom validator object, if necessary
    -  Factory pattern
    -  Demonstrate meta-programming by generating/defining similar predicate methods
    -  Encapsulate some logic in a module
    -  Have class methods
    -  Have a private section
9. For Rails controllers try to:
   -  Keep them 'thin'
   - Encapsulate business logic in service objects (1), use cases (2), or similar
operations (3), interactors (4)

10. Presentation:
    - Use partials
    - Define Presenters (View models, Form objects (5))

11. Try to showcase background and cron jobs
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
