##The inspector API

#### Requirements interpretation:

1. **_Name vs. Id_**: From the requirement it seems that the name of the robot is the robot's id prefixed with 'XX' (e.g. 1=>XX1, 2=>XX2), so the name of the robot is not an editable field but a method. Therefore, lookup is done using the name while maintaining the advantage of the fast search using id.
2. **_Limitation_**: From the requirement it seems there is a limitation that there is no way to delete an attribute key once it was added (the requirement is only to merge and override values, not remove fields), so under the current behavior the value can only be changed to nil but the key is not removed. If the option to remove a key completely is required - then a condition that upon changing a value to nil we remove the key must be added.

#### Choices:

1.  **_PostgreSQL_** - obviously for json support to allow dynamic attributes
2.  **_Paranoia rubygem_** - for revisions (using soft deletes)
3.  **_From rails to Sinatra_**: I started out with a rails app and two gems: paranioa and jsonapi-resources to have built in support for json api and for object revisioning. In the absence of any product requirements for such a bullet proof JSON api, I decided to throw away the json api gem magic along with rails entirely and use sinatra instead to keep the code small and fast.

#### Models

I implemented ths using two models: one for the `Robot` - the other for the attribute revisions named `RobotInfo`. 
The underlying databse is postgresql to allow storing and using jsons.

On every change to the robot attributes, a new robot_info is created and the previous one is soft deleted (marked as deleted) using the paranoia gem.

The action of replacing the robot info with another is done directly and explicitely in the helper and is not an active record on save event.


```bash

                                |-----------------------|
                                |       RobotInfo       |
|---------------|               |=======================|
|     Robot     |-------------->|     + info(json)      |
|---------------|    has_one	|-----------------------|
                                |     + deleted_at      |
                                |-----------------------|

```

#### Example:

https://robots-daycare.herokuapp.com/robots (if you get forbidden, it's something with the headers and heroku, just copy and paste to the browser)


_Create_
```bash
curl -H "Content-Type: application/json" -X POST -d '{"I AM":"robot","this attribute will be nulled": "not null"}' https://robots-daycare.herokuapp.com/robots
```
```json
{"status":"success","id":3}
```

_Show_
```bash
curl https://robots-daycare.herokuapp.com/robots/XX3
```
```json
{"I AM":"robot","this attribute will be nulled":"not null"}
```

_Index_
```bash
curl https://robots-daycare.herokuapp.com/robots
```
```json
[{
	"name": "XX1",
	"last_update": "2017-01-18"
}, {
	"name": "XX2",
	"last_update": "2017-01-18"
}, {
	"name": "XX3",
	"last_update": "2017-01-18"
}]
```

_Update_
```bash
curl -H "Content-Type: application/json" -X PUT -d '{"I AM":"robot","this attribute will be nulled": null}' https://robots-daycare.herokuapp.com/robots/XX3
```

```json
{"status":"success","id":3}
```

_Update (PUT)_
```bash
curl -H "Content-Type: application/json" -X PUT -d '{"I AM":"robot","this attribute will be nulled": null}' https://robots-daycare.herokuapp.com/robots/XX3
```
```json
{"status":"success","id":3}
```

_Update (PATCH)_ (nothing is changed here)
```bash
curl -H "Content-Type: application/json" -X PATCH -d '{}' https://robots-daycare.herokuapp.com/robots/XX3
```
```json
{"status":"success","id":3}
```
_History_ (only one udpate, even though we updated the entry twice)
```json
[{
	"changes": {
		"I AM": [null, "robot"],
		"this attribute will be nulled": [null, "not null"]
	},
	"type": "create"
}, {
	"changes": {
		"this attribute will be nulled": ["not null", null]
	},
	"type": "update"
}]
```

_Delete_
```bash
curl -X DELETE https://robots-daycare.herokuapp.com/robots/XX1
```
```json
{"status":"success"}
```
#### Routes (rake routes):

```bash
:: GET ::
A/robots/:name/history\
A/robots/:name\
A/robots\

:: HEAD ::
A/robots/:name/history\
A/robots/:name\
A/robots\

:: POST ::
A/robots\

:: PUT ::
A/robots/:name\

:: PATCH ::
A/robots/:name\

:: DELETE ::
A/robots/:name\
```


