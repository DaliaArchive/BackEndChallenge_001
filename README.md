# BackEnd Challenge 001

For us, it is not all about the CV or titles. The most important for us is to know how you face a concrete challenge and how you approach it. What is your way of thinking, how do you tackle the problem, which tools do you choose, ...

In order to understand all this, we would like you to complete the following challenge. This is a simplified case which illustrates the kinds of situations we have to deal with on a daily basis.

This is a good opportunity to demonstrate your style and your capabilities. To show us which kind of code you like to create.

There are no time limitations but we suggest you don't spend more than a few hours on it. We are not looking for a bullet-proof solution but it has to be elegant, clean, maintainable and intuitive approach.

Make it in your own style, use the tools you are more comfortable with, make the result to be as more representative of your skills as possible.

## Challenge Description

### The Robots' daycare center

Citizens are getting use to have robots as a personal companions, they build a very strong relationship with them, but robots also get old and start to malfunction and, at some point, they are not self-sufficient anymore. At this moment you have to choose between "terminate" him or take care of him until his vital functions stop working definitely.

Taking care of a malfunction robot is a time-consuming task and in our busy society not every one can afford it, so this is because we are building this _Robot's daycare center_.

Robot's daycare centers are subsidised by the government and in order to be beneficiary of this program we need to implement an access to the government inspectors to our database of _guesses_.

### The inspectors API

The inspectors come to our center and check our _guesses_ one by one and update our database.

As the inspectors are, at the same time, robots their-self they don't use a web browser to communicate with our system, they use a very simple API that we have to implement for them.

The API has 4 methods:

#### _[Update]_ update a Robot's attributes

1. The Inspector sends the attributes for a specific Robot.
2. Our system detects if this Robot is already in our database or not, if not we create him, if he is already in our database we go directly to next step.
3. We update the Robot's attributes, only changing the ones included in the actual update request.

##### Example

The Robot _XX1_ is already in our system and his attributes are: 

- stature: 100cm
- weight: 10kg 
- status: good conditions
- color: white
- age: 123years

The inspector check the Robot and decide to update his attributes and send the next information:

- color: dirty white
- age: 124years
- number of eyes: 1
- number of antenna: 2

The Robot _XX1_ now has these attributes: 

- stature: 100cm
- weight: 10kg 
- status: good conditions
- color: dirty white
- age: 124years
- number of eyes: 1
- number of antennas: 2

Beware that the attributes are not predefined and can be any thing in both sides: key and value.

#### _[Show]_ get a Robot's actual attributes

The inspector wants to know about the actual attributes of a Robot

##### Example

The inspector asks for the Robot _XX1_, the system responses with the next information:

- stature: 100cm
- weight: 10kg 
- status: good conditions
- color: dirty white
- age: 124years
- number of eyes: 1
- number of antennas: 2

#### _[Index]_ get a list of all Robot's in our database

The inspector wants to have an overview of all the Robot's in our database.

##### Example

The inspector makes the call, the system responses with the following information:

- 1
	- name: XX1
	- last_update: 2113-12-01

- 2
	- name: XX2
	- last_update: 2113-12-03

- 3
	- name: XX3
	- last_update: 2113-12-12
	
#### _[History]_ get a Robot's attributes changes

The inspector is interested in knowing the evolution of a robot so he asks for the changes on the attributes that have been done for this specific robot.

##### Example:

The inspector asks for history of the Robot _XX1_, the system responses with the next information:

- 2112-11-28 10:23:24
	- type: create
	- changes: 
		- stature: [] -> [100cm]
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

The whole details of the API are in your decision. You can define the URLs, request methods, headers, response types, response formats, ...

You don't even have to follow the information structures exposed in the examples, use whatever other structure you think is better, just be sure your proposition is including all the information included in the examples.

### Programming Requirements

Must be Ruby... frameworks, gems, databases are all in your decision.

### What we assess

- Legible, understandable and maintainable code
- Wisely choose of the tools, techniques and/or frameworks

## Submission Instructions

1. Fork this project
1. Complete the task and push on your own fork. (Nice, atomic and iterative commits are welcome)
1. Include instructions of how we can make it to work
1. Submit a pull request
1. Email us at hr@daliaresearch.com to review your solution

And of course: don't hesitate to **contact us with any question** you have, better use for this our _IT_ email: [it@daliaresearch.com](mailto:it@daliaresearch.com)


