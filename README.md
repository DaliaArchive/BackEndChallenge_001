#### Requirements interpretation:

* Name vs. Id: From the requirement it seems that the name of the robot is the robot's id prefixed with 'XX' (e.g. 1=>XX1, 2=>XX2), so the name of the robot is not an editable field but a method. Therefore, lookup is done using the name while maintaining the advantage of the fast search using id.

* Limitation: From the requirement it seems there is a limitation that there is no way to delete an attribute key once it was added (the requirement is only to merge and override values, not remove fields), so under the current behavior the value can only be changed to nil but the key is not removed. If the option to remove a key completely is required - then a condition that upon changing a value to nil we remove the key must be added.

#### Choices:

I started out with a rails app and two gems: paranioa and jsonapi-resources to have built in support for json api and for object revisioning. In the absence of any product requirements for such a bullet proof api, I decided to throw rails away entirely and use sinatra instead to keep the code small and fast.

#### Models

I implemented ths using two models: one for the Robot - the other for the attribute revisions named RobotInfo. 
The underlying databse is postgresql to allow storing and using jsons.

On every change to the robot attributes, a new robot_info is created and the previous one is soft deleted (marked as deleted) using the paranoia gem.

The action of replacing the robot info with another is done in the helper and is not an active record event, so we allow changes to be made to the data if needed, 



```bash

                                |-----------------------|
                                |       RobotInfo       |
|---------------|               |-----------------------|
|     Robot     |-------------->|      info (json)      |
|---------------|    has_one	|-----------------------|
                                |       deleted_at      |
                                |-----------------------|

```

rubysherpas/paranoia: for revisions 
cerebris/jsonapi-resources and .
parano

#### Example:

https://robots-daycare.herokuapp.com/robots

#### Routes:

```bash

:: GET ::
A/robots/:name/history\
A/robots/:name\
A/robots/XX:id/history\
A/robots/XX:id\
A/robots\

:: HEAD ::
A/robots/:name/history\
A/robots/:name\
A/robots/XX:id/history\
A/robots/XX:id\
A/robots\

:: POST ::
A/robots\

:: PUT ::
A/robots/:name\
A/robots/XX:id\

:: PATCH ::
A/robots/:name\
A/robots/XX:id\

:: DELETE ::
A/robots/:name\
A/robots/XX:id\

```
# BackEnd Challenge 001

For us, it is not all about the CV or titles. The most important for us is to know how you face a concrete challenge and how you approach it. What is your way of thinking, how do you tackle the problem, which tools do you choose, ...

In order to understand all this, we would like you to complete the following challenge. This is a simplified case which illustrates the kinds of situations we have to deal with on a daily basis.

This is a good opportunity to demonstrate your style and your capabilities. It is a way to show us which kind of code you like to create.

There are no time limitations but we suggest you don't spend more than a few hours on it. We are not looking for a bullet-proof solution but it has to be an elegant, clean, maintainable and intuitive approach.

Create it in your own way and use the tools you are most comfortable with. Show us your skills.

## Challenge Description

### The robots' daycare center

Citizens are getting more and more used to having robots around on a day to day basis. They build very strong relationship with them, however robots are also getting old and start to malfunction at one point. When this time comes, they are not self-sufficient anymore and you have to choose between "terminating" them or taking care of them until their vital functions stop working indefinitely.

Taking care of a malfunction robot is a time-consuming task and in our busy society not every person has the time to do so. Thats why we are building the _Robot's daycare center_.

The robot's daycare centers are subsidised by the government and in order for them to benefit from this program, they need to give government inspectors access to their database of _guests_.


### The inspectors API

The inspectors come to our center and check our _guests_ one by one and update the database.

As the inspectors are robots their selves, they don't use a web browser to communicate with our system, but a very simple API that we have to implement for them.

The API has 4 methods:

#### _[Update]_ update a robot's attributes

1. The inspector sends the attributes for a specific robot.
2. Our system detects if the robot is already in our database or not. If not, we create it and if yes, we go directly to the next step.
3. We update the robot's attributes, only changing the ones included in the actual update request.

##### Example

The robot _XX1_ is already in our system and has the following attributes: 

- size: 100cm
- weight: 10kg 
- status: good conditions
- color: white
- age: 123years

The inspector checks the robot and decides to update his attributes and sends the following information:

- color: dirty white
- age: 124years
- number of eyes: 1
- number of antenna: 2

The robot _XX1_ now has these attributes: 

- size: 100cm
- weight: 10kg 
- status: good conditions
- color: dirty white
- age: 124years
- number of eyes: 1
- number of antennas: 2

Be aware that the attributes are not predefined and can be anything on both sides: key and value.

#### _[Show]_ get a robot's actual attributes

The inspector wants to know about the actual attributes of a robot

##### Example

The inspector asks for the robot _XX1_ and the system responses with the following information:

- size: 100cm
- weight: 10kg 
- status: good conditions
- color: dirty white
- age: 124years
- number of eyes: 1
- number of antennas: 2

#### _[Index]_ get a list of all the robot's in our database

The inspector wants to have an overview of all the robot's in our database.

##### Example

The inspector makes the call and the system responses with the following information:

- 1
	- name: XX1
	- last_update: 2113-12-01

- 2
	- name: XX2
	- last_update: 2113-12-03

- 3
	- name: XX3
	- last_update: 2113-12-12
	
#### _[History]_ get a robot's attributes changes

The inspector is interested in knowing about the evolution of the robot, so he asks for the changes on the attributes that have been done for this specific robot.

##### Example:

The inspector asks for the history of the robot _XX1_, the system responses with the following information:

- 2112-11-28 10:23:24
	- type: create
	- changes: 
		- size: [] -> [100cm]
		- weight: [] -> [10kg]
		- status: [] -> [good conditions]
		- color: [] -> [white]
		- age: [] -> [123years]

- 2113-12-02 16:30:11
	- type: update
	- changes:
		- color: [white] -> [dirty white]
		- age: [123years] -> [124years]
		- number of eyes: [] -> [1]
		- number of antennas: [] -> [2]


### The API details

You can make your own decision on the details of your API. You can define the URLs, request methods, headers, response types, response formats, etc.

You don't even have to follow the information structures showed in the examples above. Use whatever structure you think is best, however just make sure that your proposition includes all the information in the examples.

### Programming Requirements

Must be Ruby... frameworks, gems, databases are all up to you.

### What we assess

- Legible, understandable and maintainable code
- Wisely choosen tools, techniques and/or frameworks

## Submission Instructions

1. Fork this project
1. Complete the task and push on your own fork. (Nice, atomic and iterative commits are welcome)
1. Include instructions of how we can make it to work
1. Submit a pull request
1. Send an email to hr@daliaresearch.com for us to review your solution

And of course: don't hesitate to **contact us with any question** you have, better use for this our _IT_ email: [it@daliaresearch.com](mailto:it@daliaresearch.com)


