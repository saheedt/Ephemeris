[![CircleCI](https://circleci.com/gh/saheedt/Ephemeris/tree/develop.svg?style=svg)](https://circleci.com/gh/saheedt/Ephemeris/tree/develop)
[![Maintainability](https://api.codeclimate.com/v1/badges/c12792e08691cac7adfb/maintainability)](https://codeclimate.com/github/saheedt/Ephemeris/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c12792e08691cac7adfb/test_coverage)](https://codeclimate.com/github/saheedt/Ephemeris/test_coverage)

# EPHEMERIS

Ephemeris is a journal-like app that could be used by all

#### RUBY
This application is a ruby on rails application and it was built using `ruby version 2.5.1` and `rails version 5.2.1`.

#### DATABASE
This application makes use of a postgreSQL database

#### FRONTEND
This application is bootstrapped with webpack to use `REACT` as the frontend framework. The frontend code can be found in the client folder at the root of the application

#### LINTING
**Rubocop** is to be used to lint all the ruby code.

To lint all ruby code, from root directory run `rubocop`

To lint specific file(s), run
```
rubocop path/to/file
```
or  
```
rubocop path/to/file-1 path/to/file-2 ...path/to/file-n
```

To autofix all lint issues, run rubocop in autocorrect mode with 
```
rubocop -a
```


**Eslint** is used to lint all the reactJS files(Frontend code is in the client folder). To fix auto-fixable errors using eslint run:
````
npm run lint
````

#### HOW TO SETUP

* Clone the app by running:
```
  git clone https://github.com/Orelongz/Ephemeris.git
```

* Bundle the dependencies:
```
  bundle install
```

* Install node packages using [yarn](https://yarnpkg.com/lang/en/docs/install/#mac-stable):
```
  yarn install
```

* Setup the database
```
  rake db:create
  rake db:migrate
```

* Install [hivemind](https://github.com/DarthSim/hivemind)
```
  brew install hivemind
```

* Run the application
```
  hivemind
```

The application should be running on `http://localhost:5000/`
