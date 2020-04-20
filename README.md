# moodle
moodle container for the learning management system

## Beta-State!

This is still in beta-state!

It does run, but there are still problems and it doesn-t integrate in the PhilleConnect LADP yet, manual LDAP-integration will be necessary. See the [Moodle-Docs](https://docs.moodle.org/38/en/LDAP_authentication#Enabling_LDAP_authentication) for details.

## How to use this

### clone

After cloning this repository be sure to execute

`git submodule update --init --recursive --remote`

to get the current version of moodle.

To use a certain version of moodle (`v3.8.2` is our working version at the moment) execute

`git submodule foreach git checkout v3.8.2`

(or go to `moodle/` and execute `git checkout v3.8.2`!

### confugure

Copy the `settings.env.default` to `settings.env` (`cp settings.env.default settings.env`) and edit it according to your needs. For plain testing you don't need to change anything.

### run

`docker-compose up -d`

### upgrade

`docker-compose down`

`git submodule update` will update moodle, maybe you want to switch to a different branch here with `git submodule foreach git checkout v3.*.*`

`git pull`

check for changes in the `settings.env`-file

`docker-compose up --build -d`


## Further Hints

(This is mainly for people searching for this problem)

A widely discussed problem with moodle-installations is a 303-redirect-Error. Even after updating a working moodle-installation this error can occur.

In that case the browser shows an error message, in german it is "Fehler: Umleitungsfehler", in the network analysis you see the status code `303`.

This is caused by the moodle-installation (also other products like Joomla et. al. show this behaviour) that is aware of the external url. When this is changed in the network chain, in this case a translated port in docker, this leads to a 303-redirect-loop when the site calls recources with absolute urls.

I solved this by

- setting the exernal url in the `config.php`
- including either `$CFG->reverseproxy = true;` xor `$CFG->sslproxy = true;` in the `config.php`
    - Be sure not to cat it to the end of the file!! It needs to be a little above!
