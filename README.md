# Vagrant Phabricator

Run an instance of the latest Phabricator in a vagrant box

#### Start
```
vagrant up && vagrant provision
```

Add a line to your `/etc/hosts` file

```
127.0.0.1 phabricator.local
```

Browse to `http://phabricator.local:8010`

Set up the admin account

enjoy