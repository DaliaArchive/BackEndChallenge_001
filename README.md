#API

PUT http://localhost:8000/guests/XX1
{"guest" :{
   "size":"100cm",
   "weight":"10kg",
   "status":"good conditions",
   "color":"white",
   "age":"123years"
}}

GET http://localhost:8000/guests

GET http://localhost:8000/guests/XX1

GET http://localhost:8000/guests/XX1/history



#Setup

```sh
vagrant up
```

After its done, the service should be up on localhost:8000

#Running the tests

```sh
vagrant ssh
cd robot_day_care
rspec spec/
```


###Notes for Vagrant
- Tested on Vagrant v.1.3.5, should work with the latest as well.
- Please use vagrant from vagrantup.com and not the gem repo.
- Downloads the puppetlabs ubuntu-12.4 box if not found.


