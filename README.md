# moodle
moodle container for the learning management system

## THIS IS STILL IN ALPHA-STATE

It does run, but there are still problems and it doesn-t integrate in the PhilleConnect LADP yet. So hang on and stay tuned!

## How to use this

After cloning this repository be sure to execute

`git submodule update --init --recursive --remote`

to get the current version of moodle.

To use a certain version of moodle (`v3.8.2` is our working version at the moment) execute

`git submodule foreach git checkout v3.8.2`

or go to `moodle/moodle` and execute `git checkout v3.8.2`!

## Further Hints

(This is mainly for people searching for this problem)

A widely discussed problem with moodle-installations is a 303-redirect-Error. Even after updating a working moodle-installation this error can occur.

In that case the browser shows an error message, in german it is "Fehler: Umleitungsfehler", in the network analysis you see the status code `303`.

This is caused by the moodle-installation (also other products like Joomla et. al. show this behaviour) that is aware of the external url. When this is changed in the network chain, in this case a translated port in docker, this leads to a 303-redirect-loop when the site calls recources with absolute urls.

I solved this by

- setting the exertnal url in the `config.php`
- not changing the ports in docher, nginx is listening on the same port `90` as the one that is exposed by Docker:

```
    ports:
      - 90:90
```

in the `docker-compose.yml`
