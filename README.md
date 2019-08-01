# simple weather api
--------------------
Simple PDX weather api using the [Open Weather Map API](https://openweathermap.org/). Deployed on [CentOS 7](https://app.vagrantup.com/geerlingguy/boxes/centos7).
I used Vagrant 2.2.4 and VirtualBox 6.0.10 on Debian Linux (Debian GNU/Linux 9 (stretch)).

# deployment
--------------------
The Open Weather Map API requires a key to make requests. One has been provided via email and will need to be placed into the supervisor config file before deployment(./site/rest_api/files/rest_supervisor.conf):
```
% sed -i s/paste_key_here/<api_key>/ site/rest_api/files/rest_supervisor.conf
```
Once the API key is in place the only command needed will be:
```
% vagrant up
```

# making requests
--------------------
Once the vm is up you can begin to make requests to http://localhost:8080. Only GET has been implemented here so an example call would look like:
```
% curl -X GET 'http://localhost:8080/temperature'
{query_time":"2019-08-01 03:06:29.697813","temperature":79.39}
```
The returned time is in UTC and will only return a "fresh" value if the currently stored value is > 5 minutes old.
