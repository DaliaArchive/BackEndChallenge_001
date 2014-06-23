##Setup

```sh
vagrant up
```
This should provision a dev VM with dependenices and gems. After its done, the service should be up on http://localhost:8000


##Running the tests

```sh
vagrant ssh
cd robot_day_care
rspec spec/
```

##API

PUT http://localhost:8000/guests/XX1
```json
{"guest" :{
   "size":"100cm",
   "weight":"10kg",
   "status":"good conditions",
   "color":"white",
   "age":"123years"
}}
```

GET http://localhost:8000/guests

GET http://localhost:8000/guests/XX1

GET http://localhost:8000/guests/XX1/history




###Notes for Vagrant
- Tested on Vagrant v.1.3.5, should work with the latest as well.
- Please use vagrant from vagrantup.com and not the gem repo.
- It downloads the puppetlabs ubuntu-12.4 box if not found.


