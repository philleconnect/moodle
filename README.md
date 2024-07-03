__Archived: Not actively maintained anymore!__

# moodle

This is a universal docker-container for the moodle learning management system.

The usage is not limited to PhilleConnect, it can also be used in oder setups or as a standalone-solution.

## Beta-State!

This is still in beta-state!

It does run, but there are still problems and it doesn't integrate in the PhilleConnect LADP yet, manual LDAP-integration will be necessary. See the [Moodle-Docs](https://docs.moodle.org/38/en/LDAP_authentication#Enabling_LDAP_authentication) for details.

Be sure to read this entire document on installation!

## How to use this

### clone

After cloning this repository be sure to execute

`git submodule update --init`

to get the current version of moodle.

To use a certain version of moodle (`v3.9.3` is our working version at the moment) execute

`git submodule foreach git checkout v3.9.3`

(or go to `moodle/` and execute `git checkout v3.8.2`)!

### configure

Copy the `settings.env.default` to `settings.env` (`cp settings.env.default settings.env`) and edit it according to your needs. For plain testing you don't need to change anything.

### run

`docker-compose up -d`

### upgrade

`docker-compose down`

`git submodule update` will update moodle.

\[Maybe you want to switch to a different branch here with `git submodule foreach git checkout v3.*.*`, but be aware that this is not tested by us. Refer to the moodle docs for further information.\]

`git pull`

check for changes in the `settings.env`-file

`docker-compose up --build -d`

## set up the LDAP-Connection

Logged in as admin-user:

Maybe you want to install the [LDAP server (sync plus)-plugin](https://moodle.org/plugins/auth_ldap_syncplus) first, but it is not necessary.

- go to 'Website-Administration' > 'Plugins' and select `LDAP-Server`
- type in your LDAP-url. This can just be an IP-address. The other defaults are ok.
- the bind-settings are not necessary, you don't need moodle to know your ldap-password!
- in 'user lookup' select the `rfc2307` for OpenLDAP
- important: as 'memberattribute' type in `memberuid` to be able to automatically assign roles
- the 'context' is `ou=users,dc=ldap,dc=philleconnect` for default PhilleConnect-Setup
- further down select for the 'passtype' `MD5`
- for 'removeuser' we recommend to user `delete`
- for 'coursecreatorcontext' type in `cn=teachers,ou=groups,dc=ldap,dc=schoolconnect` for default PhilleConnect-Setup
- in the section 'Data mapping' you can set for 'field_map_firstname' `displayName`, for 'field_map_lastname' `cn` and for 'field_map_email' `mail` and lock those values (updating them 'On every login') to prevent moodle from asking on Login. You will need the eMails to be set in PhilleConnect! moodle insists in an eMail-address being set up, even if an eMail-Server is not configured at all.


## Further Hints

(This is mainly for people searching for this problem)

A widely discussed problem with moodle-installations is a 303-redirect-Error. Even after updating a working moodle-installation this error can occur.

In that case the browser shows an error message, in german it is "Fehler: Umleitungsfehler", in the network analysis you see the status code `303`.

This is caused by the moodle-installation (also other products like Joomla et. al. show this behaviour) that is aware of the external url. When this is changed in the network chain, in this case a translated port in docker, this leads to a 303-redirect-loop when the site calls recources with absolute urls.

I solved this by

- setting the exernal url in the `config.php`
- including either `$CFG->reverseproxy = true;` xor `$CFG->sslproxy = true;` in the `config.php`
    - Be sure that you __do not cat it to the end of the file!__ It needs to be a little above, as last `$CFG`-entry for example.
