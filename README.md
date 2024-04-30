# How to run

```sh
$ docker-compose build
$ docker-compose up
```
can open graphiql locally from `localhost:3000/graphiql`

setup and seed the database with
```sh
$ docker-compose run --rm app bash # enter the console in a running container
$ rails db:setup
```
