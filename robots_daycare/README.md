##  Robot Daycare Center

### Application Local Installation
- Ruby version 2.1.3
- Rails version 4.2.5
- Mongoid gem 5.1.0


### Mongodb application config
Refer config/mongoid.yml

### Mongodb Installation Installation

On ubuntu 14.04 follow following steps :

Step 1) Importing the Public Key

```sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10```

Step 2) Creating a List File

```echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list```

Step 3) Installing and Verifying MongoDB

```sudo apt-get install -y mongodb-org```

For more info check https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-14-04

If you are using other operating system then please check following site to install mongodb
https://docs.mongodb.org/manual/installation/


### API documentation 

### [Update] update a robot's attributes ###

**Endpoint Url** : /robots/<robot_name>

**HTTP action** : PATCH/PUT

**Sample Input**     : "attribs=<attributes_json>"

**Sample Output** : {"attribs":<attributes_json>}

**Error Output** : { "error": <error_message> }

----------------**Example** -------------------

**Endpoint Url**  : /robots/XX8

**Sample Input**  : "attribs={\"size\":\"1000cm\", \"weight\":\"111kg\", \"color\":\"black\"}"

**Sample Output** : {"attribs":{"size":"1000cm","weight":"111kg","color":"black"}}

**Sample Error Output** : { "error": "Error occurred while processing record" }

**Curl command**  : curl -X PATCH --data "attribs={\"size\":\"1000cm\", \"weight\":\"111kg\", \"color\":\"blackkkkkkkskss\"}" http://localhost:3000/robots/XX8



### [Show] get a robot's actual attributes

**Endpoint Url** : /robots/<robot_name>

**HTTP action** : GET

**Sample Output** : {"attribs":<attributes_json>}

**Error Output** : { "error": <error_message> }

----------------**Example** -------------------

**Endpoint Url**  : /robots/XX8

**Sample Output** : { "attribs": {"size": "100cm", "weight": "9kg", "color": "black" }

**Sample Error Output** : { "error": "Error occurred while processing record" }

**Curl command**  : curl http://localhost:3000/robots/XX8


### [Index] get a list of all the robot's in our database

**Endpoint Url** : /robots

**HTTP action** : GET

**Sample Output** : [{ <robot_attributes> }, { <robot_attributes> }, ...]

**Error Output** : { "error": <error_message> }

----------------**Example** -------------------

**Endpoint Url**  : /robots

**Sample Output** : [
   {
      "name":"XX7",
      "attribs":{
         "size":"100cm",
         "weight":"9kg",
         "color":"black"
      },
      "created_at":"2016-04-07T15:33:42.298Z",
      "updated_at":"2016-04-07T15:33:42.299Z",
      "histories":[
         {
            "transaction_type":"create",
            "changed_attribs":[
               {
                  "key":"size",
                  "new_value":"100cm",
                  "old_value":""
               },
               {
                  "key":"weight",
                  "new_value":"9kg",
                  "old_value":""
               },
               {
                  "key":"color",
                  "new_value":"blackkkkkkkk",
                  "old_value":""
               }
            ]
         }
      ],
      "url":"http://localhost:3000/robots/XX7",
      "history_url":"http://localhost:3000/robots/XX7/histories"
   },
   {
      "name":"XX8",
      "attribs":{
         "size":"1000cm",
         "weight":"111kg",
         "color":"blackkkkkkkskss"
      },
      "created_at":"2016-04-07T15:34:59.167Z",
      "updated_at":"2016-04-11T13:31:36.910Z",
      "histories":[
         {
            "transaction_type":"create",
            "changed_attribs":[
               {
                  "key":"size",
                  "new_value":"100cm",
                  "old_value":""
               },
               {
                  "key":"weight",
                  "new_value":"9kg",
                  "old_value":""
               },
               {
                  "key":"color",
                  "new_value":"blackkkkkkkk",
                  "old_value":""
               }
            ]
         },
         {
            "transaction_type":"update",
            "changed_attribs":[
               {
                  "key":"weight",
                  "new_value":"10kg",
                  "old_value":"9kg"
               }
            ]
         },
         {
            "transaction_type":"update",
            "changed_attribs":[
               {
                  "key":"size",
                  "new_value":"1000cm",
                  "old_value":"100cm"
               }
            ]
         },
         {
            "transaction_type":"update",
            "changed_attribs":[
               {
                  "key":"color",
                  "new_value":"blackkkkkkksk",
                  "old_value":"blackkkkkkkk"
               }
            ]
         }
      ],
      "url":"http://localhost:3000/robots/XX8",
      "history_url":"http://localhost:3000/robots/XX8/histories"
   }
]

**Sample Error Output** : { "error": "Error occurred while processing record" }

**Curl command**  : curl http://localhost:3000/robots


### [History] get a robot's attributes changes

**Endpoint Url** : /robots/<robot_name>/histories

**HTTP action** : GET

**Sample Output** : [ { changed_attribs: [ <changed_attribs> ], "transaction_type": "create"}, {}, ...}

**Error Output** : { "error": <error_message> }

----------------**Example** -------------------

**Endpoint Url**  : /robots/XX8/histories

**Sample Output** : [
   {
      "changed_attribs":[
         {
            "key":"size",
            "new_value":"100cm",
            "old_value":""
         },
         {
            "key":"weight",
            "new_value":"9kg",
            "old_value":""
         },
         {
            "key":"color",
            "new_value":"blackkkkkkkk",
            "old_value":""
         }
      ],
      "created_at":"2016-04-07T15:34:59.171Z",
      "transaction_type":"create",
      "updated_at":"2016-04-07T15:34:59.171Z"
   },
   {
      "changed_attribs":[
         {
            "key":"weight",
            "new_value":"10kg",
            "old_value":"9kg"
         }
      ],
      "created_at":"2016-04-07T15:36:11.773Z",
      "transaction_type":"update",
      "updated_at":"2016-04-07T15:36:11.773Z"
   },
   {
      "changed_attribs":[
         {
            "key":"size",
            "new_value":"1000cm",
            "old_value":"100cm"
         }
      ],
      "created_at":"2016-04-07T15:48:53.655Z",
      "transaction_type":"update",
      "updated_at":"2016-04-07T15:48:53.655Z"
   },
   {
      "changed_attribs":[
         {
            "key":"color",
            "new_value":"blackkkkkkksk",
            "old_value":"blackkkkkkkk"
         }
      ],
      "created_at":"2016-04-11T13:16:18.443Z",
      "transaction_type":"update",
      "updated_at":"2016-04-11T13:16:18.443Z"
   },
   {
      "changed_attribs":[
         {
            "key":"color",
            "new_value":"blackkkkkkksks",
            "old_value":"blackkkkkkksk"
         }
      ],
      "created_at":"2016-04-11T13:26:22.925Z",
      "transaction_type":"update",
      "updated_at":"2016-04-11T13:26:22.925Z"
   },
   {
      "changed_attribs":[
         {
            "key":"color",
            "new_value":"blackkkkkkkskss",
            "old_value":"blackkkkkkksks"
         }
      ],
      "created_at":"2016-04-11T13:31:36.912Z",
      "transaction_type":"update",
      "updated_at":"2016-04-11T13:31:36.912Z"
   }
]


**Sample Error Output** : { "error": "Error occurred while processing record" }

**Curl command**  : curl http://localhost:3000/robots/XX8/histories
