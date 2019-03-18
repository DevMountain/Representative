# Representatives

## Project Summary

Students will build an app to get the representatives (law makers) in a user-requested state to practice asynchronous network requests, working with JSON data, closures, and intermediate table views.

Students who complete this project independently are able to:

* use URLSession to make asynchronous network calls
* parse JSON data and generate model objects from the data
* use closures to execute code when an asynchronous task is complete
* build custom table views

## Setup

* If you haven't already, `fork` and `clone` this [student](https://github.com/DevMountain/iOS-Student) repository from GitHub
* Open the `Representative.xcodeproj` in the `Afternoon Projects/Unit 3 - Networking/Day 4/Representative` folder

## Step One - Implement Model

### Summary

Create a `Representative` model struct that will hold the information of a representative to display to the user.

### Instructions

* Create a `Representative.swift` file and define a new `Representative` struct.

* Go to a sample endpoint of the [Who is my Representative](https://whoismyrepresentative.com) API and see what JSON (information) you will get back.

* Pay close attention to and read the documentation. This is a very big gotcha moment with this API that can be completelty avoided if you read what it says.

* Using this information, add properties on `Representative`.
    * <details> 

        <summary> <code> Properties </code> </summary>

        * `let name: String`
        * `let party: String`
        * `let state: String`
        * `let district: String`
        * `let phone: String`
        * `let office: String`
        * `let link: String`
    </details>

* Make `Representative` conform to the `Codable` protocol.

## Step Two - Info.plist Arbitrary Loads

### Summary

As of iOS 9, Apple is boosting security and requiring developers to use the secure HTTPS protocol and require the server to use the proper TLS Certificate version. So for this app, you will need to turn off the App Transport Security feature.

### Instructions

* Open your `Info.plist` file

* At the bottom of the list, press the `+` button that appears when you hover over the field. This adds a new key-value pair to the plist.

* For the first key, enter in `App Transport Security Settings` and press enter.

* This created a new dictionary. Now on the `App Transport Security Settings` key, press the arrow to the left so tha tit now points down.

* Press the `+` button that shows up again and this will create a new value for the key `App Transport Security Settings`

* Enter in `Allow Arbitrary Loads` and change it's Boolean value from `NO` to `YES`

## Step Three - RepresentativeController

### Summary

You will create a `RepresentativeController` class. This class will use the `URLSession` to fetch data and deserialize the results into `Representative` objects. This class will be used by the view controllers to fetch Representative objects through completion closures.

### Instructions


* Create a new `RepresentativeController` .swift file and class

* The `RepresentativeController` should have a static constant that represents the `baseURL` of the API.
    * <details>

        <summary> <code> Hint </code> </summary>

        * We want the reps per state where we will change the state based on the users search.
    </details>

* Add a static function `searchRepresentatives(forState state: ...)` that allows the developer to pass in the search parameter, create a dataTask to fetch the representatives' data, and through a completion closure provide an array of `Representative` objects.

  * <details>

    <summary> <code> Tip </code> </summary>

    * In the completion handler, it should pass back a non-optional array of `Representative` objects, and whereever you would normally call `completion(nil)` with an optional, instead just call `completion([])` to return an empty array.
    * The reason for this is optional arrays can act irregurlarly depending on their contents, so we avoid that with just using an empty array.
  </details>

* This function should set create a dictionary of the URL parameters for the state and the output types, then create an array of `URLQueryItem`s from the dictionary.

* Create an instance of `URLComponents` with the `baseURL`, then attach the array of `URLQueryItem`s to it.

* Using the `url` property that is a part of your `URLComponents`, create a dataTask using `URLSession`. Use the initializer with that takes in a `URL`, and has a completion closure. This is used to get `Data` back from the API.

* In the completion closure of your dataTask, use a guard statement to check for nil data, and if the guard statement fails, print an error message to the console and run the completion with an empty array.

    * Currently, whoismyrepresentative.com incorrectly encodes letters with diacrtic marks, e.g. ú, using extended ASCII, not UTF-8. This means that trying to convert the data to a string using .utf8 will fail for some states, where the representatives have diacritics in their names. To workaround this, decode data into a string using `.ascii`, then reencode the string as data using `.utf8` before passing the fixed UTF-8 data into the JSON decoder.

    * You will need to use `String(data: Data, encoding: String.Encoding)` to decode the data and then `.data(using: String.Encoding)` to re-encode the string to data.

* If the guard statement doesn't fail then use `JSONDecoder` to decode the `Data` as a dictionary `[String: [Representative]]`.  
  
* Get the array of `Representative`s using resultsDictionary["results"]

* Call the completion closure with the array of decoded array of `Representative`s.

Note: There are many different patterns and techniques to deserialize JSON data into Model objects. Feel free to experiment with different techniques to turn the data returned from the URLSessionDataTask into an array of `Representative`s.

At this point you should be able to pull data for a specific state and deserialize a list of Representatives. Feel free to test this in your App Delegate by trying to print the results for a state to the console.

## View Hierarchy Notes

You will implement a 'Master-Detail' view hierarchy for this application.

Your Master View is a list of states. Selecting any state will segue to a Detail View displaying a list of representatives for the selected state.

Recognize that even though the list of representatives may be called a List view, it is also considered a Detail view in this project because it is the Detail view of the selected state.

## Step Four - State List View Controller

### Summary

Build a view that lists all states. Use the included `all` variable in the `States.swift` file to build the datasource for the UITableViewController. This view will be used to segue to a list of Representatives for the selected state.

### Instructions

* Add a `UITableViewController` as your root view controller in `Main.storyboard` and embed it in a `UINavigationController`

* Create an `StateListTableViewController` file as a subclass of `UITableViewController` and set the class of your root view controller scene

* Implement the `UITableViewDataSource` functions using the included `all` states array in the `States.swift` file

* Set up your cells to display the name of each state

## Step Five - State Detail View Controller

### Summary

Build a view that lists all of the Representatives for a selected state. Use a UITableViewController and a custom UITableViewCell that displays the properties of a Representative (name, party, state, district, phone, and url).

The State List View Controller will pass a State string to this scene. We will use that value to perform the network request. When the network request is completed, you will reload the UITableView to display the results.

### Instructions

* Add an additional `UITableViewController` scene to the Storyboard. Create a class file `StateDetailTableViewController.swift` and assign the class to the storyboard scene

* Create a prototype cell that uses a Stack View to display the name, party, district, website, and phone number of a `Representative`

* Create a custom `UITableViewCell` class with an `updateViews()` function that sets the labels to the `Representative` data and assign the prototype cell in storyboard to the class. (Don't forget to create outlets for your labels)
* Create a `representative` computed property and in the `didSet` of that property call `updateViews()`

* In the `StateDetailTableViewController`, add a computed property of type `[Representative]` that will be used to populate the Table View. Set it to an empty array to satisfy the requirement that all properties have values upon initialization and in the `didSet` reload the table view

* Add an optional `state` property of type `String`. This will be set by the `StateListViewController` in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function

* Implement the UITableViewDataSource functions to return your custom prototype cell by setting the cell's `representative` variable. (You'll need to cast the cell as the custom cell you created)

* Update your `viewDidLoad()` function to call the `RepresentativeController.searchRepresentatives(forState:...)` function using the unwrapped state property. In the completion closure, set `self.representatives` to the returned representatives and reload the UITableView on the main thread.

Note: It is good practice to let the user know that a network request is processing. This is most commonly done using the Network Activity Indicator in the status bar. Look up the documentation for the `isNetworkActivityIndicatorVisible` property on `UIApplication` to turn on the indicator when the view loads and to turn it off when the network call is complete.

## Step Six - Wire Up the Views

### Summary

Set up a segue from the State List View to the State Detail View that assigns the state that the State Detail View should load Representatives for.

### Instructions

* Add a segue from the prototype cell on the `StateListTableViewController` scene to the `StateDetailTableViewController` and assign an identifier

* Implement the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function on the `StateListTableViewController` class to capture the state and assign it to the `destinationViewController`'s `state` property.

The app is now finished. Run it, check for bugs, and fix any that you might find.

### Black Diamonds

* Implement another way for users to find their Congressman/Congresswoman.
* If no Representatives were found, notify the user that a search failed.
* Make the phone and website labels links that would call and open a web view.

## Contributions

If you see a problem or a typo, please fork, make the necessary changes, and create a pull request so we can review your changes and merge them into the master repo and branch.

## Copyright

© DevMountain LLC, 2017. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.

<p align="center">
<img src="https://s3.amazonaws.com/devmountain/readme-logo.png" width="250">
</p>
