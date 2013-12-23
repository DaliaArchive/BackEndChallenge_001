#**Dalia Robots** *(Alpha)*
An API designed and implemented for the *[Dalia Research BackEnd Challenge 001][1]*

----------

Technology Overview
-------
Given the nature of this development challenge (a simple api to interact with a database with no predefined schema) and as the only limitation for it was Ruby, I decided to use the following tools and technologies: 

 - [Rails API][2]: A gem that lets you create applications that are subsets of Rails. This gave me the option to exclude stuff that is not required for this application (such as the template generation, for example) and make it lighter and (slightly) faster.
 - [Mongoid][3]: An Object-Document-Mapper for MongoDB. The fact that the attributes that would be stored in the database were not predefined made MongoDB the "de facto" option for the database and Mongoid is the ODM I find better to use.
 - [RSpec-Rails][4]: A testing framework for Rails applications. It's flexibility, power and syntax are a mixture that I haven't found in any other testing suites. I went further and combined it with [Database_Cleaner][5] to make my testing more efficient.
 - [httpi][6]: A common interface for Ruby’s most popular HTTP clients. I used this in order to make the use of the app from the terminal easier (by letting the user interact with it from within a ruby object instead of having him to type long server requests).

All the coding was done in [Sublime Text 2][7] and some manual testing was performed with [Postman][8].
 
Technical Analysis
-------
The core of the application is a controller that handles all the requests, which can can be a `GET index`, a `GET show`, a `PUT update` or a `GET history`, and responds with a `json` object that contains either the requested data, along with the appropriate message and status code, or just the error message and status code in the case that the request failed for some reason. Furthermore, the foundation for other types of responses has been implemented so adding them in the future would not be an issue.

Then, there is a `robot` model, which mimics the robots in the daycare center and a `history` one that holds all the required information for changes in the robot model. The second model could have been omitted, with data about changes being held in the robot document, but that would add a concern, over time, about the size of the robots documents becoming significantly large. With the approach I chose, each robot is one document and each change, of each robot, is a different one.

Finally, there is the `inspector` model. This was not part of the requirements but I figured it would be much nicer to interact with the api neither with a static script, nor by typing long and boring `curl -X METHOD -d url blahblah` all the time, but within an object that also somehow mimics the inspectors mentioned in the description of the challenge. This object has four methods (`index`, `show`, `update` and `history`) that utilize the `httpi` gem to send the requests and output the responses.
 
Setup and Instructions
-------
**Setup:**

 1. Install Rails (3.2.15), Ruby (1.9.3p484) and MongoDB and make sure it is running.
 2. Download (or clone) the application, bundle install it and optionally run the tests (`rspec`). 
 4. Finally, open the terminal and launch a Rails server (`rails s`) from the app directory.

**Usage:**

 - Manual Requests:
     - INDEX: `curl http://0.0.0.0:3000/` 
     - SHOW: `curl http://0.0.0.0:3000/robots/name` 
     - UPDATE: `curl -X PUT -H "Content-Type: application/json" -d '{"name":"robot_name", "attrX":"valueX", "attrY":"valueY", ...}' http://0.0.0.0:3000/robots/update/`
     - HISTORY: `curl http://0.0.0.0:3000/robots/name/history`

 - Inspector Object:
    - Enter the Rails console (`rails c`)
    - Create an inspector object (`inspector = Inspector.new`)
    - Then, do any of the following:
        - INDEX: `inspector.index`
        - SHOW: `inspector.show("name")`
        - UPDATE: `inspector.update("name", attrX: valueX, attrY: valueY)`
        - HISTORY: `inspector.history("name")`

*(both "/" and "/robots" route to index and "name" is the name of the robot)*

## Notes and Conclusion ##
I should begin by pointing out two things: 

 - The first one is that `id` is never mentioned in api description and in the specification for the `index` output there is `name: XX1 (and XX2)` so I coded my solution treating "XX1" and "XX2" as names ant not ids. Of course, robot documents have an `id` field but it's only used to associate `robots` with `history` documents. I am writing this to avoid giving the impression that I did this by mistake - if I have understood wrong the behavior can be easily changed.
 - The second one is that the timestamp in the `history` response doesn't have a time mark. Both `Mongoid::Timestamps` and `Time.now` in the controller failed me and although I tried to find out why this is happening, I didn't manage to make it work. I have the suspicion that I haven't set it up properly in my rails application but I wouldn't say I am entirely sure about it.

Going on, although I am not exactly a junior developer, this is the first api I design or implement and I tried to demonstrate my thinking and style without overdoing it or assuming a lot of things. For example, there is obviously the question about authentication but although I understand it I didn't do anything related to that because it was not part of the specifications. At the same time, I structured the responses in a way that would let a developer to quickly add other content types (such as xml) as well.

It's also pretty much the first project which I work at following the Test-Driven Development approach, so the same applies to my tests. In the controller spec, for example, there is two tests for every action when one could surely have way more and even break these eight tests (that test two or three related things at once) to smaller ones that only test individual things. Again, it's just a demo of my thinking.

*I can not commit this without mentioning [HTTP Status Dogs][9] which is one of the results that came up when I googled to find information about a `411 Content-Required` error. Here is the status dog for 100:*

![][10]


  [1]: https://github.com/DaliaResearch/BackEndChallenge_001
  [2]: https://github.com/rails-api/rails-api
  [3]: http://mongoid.org/en/mongoid/index.html
  [4]: https://github.com/rspec/rspec-rails
  [5]: https://github.com/bmabey/database_cleaner
  [6]: http://httpirb.com/
  [7]: http://www.sublimetext.com/2
  [8]: http://www.getpostman.com/
  [9]: http://httpstatusdogs.com/
  [10]: http://httpstatusdogs.com/wp-content/uploads/100.jpg