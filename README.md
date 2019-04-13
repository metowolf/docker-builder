### docker-publish

install

```
sudo curl -L https://raw.githubusercontent.com/metowolf/docker-builder/master/scripts/publish.sh -o /usr/local/bin/docker-publish
sudo chmod +x /usr/local/bin/docker-publish
```

usage

```
~ docker-publish
usage: docker-publish repo[:tag] repo:tag [prefix count]
   ie: docker-publish build:travis metowolf/php:7.3.4
       docker-publish build metowolf/php:7.3.4 2
```
