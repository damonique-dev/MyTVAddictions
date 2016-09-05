# MyTVAddictions
This app allows user to keep track of their favorite TV shows.

Users can use the tab bar at the bottom to navigate through the app. The tab view when the app is opened is the user's list of TV shows, if they have any. The second is where the users can search for their favorite show. The third is a list of the most popular shows at the moment. 

Clicking a show on any of the three tabs will take the user to the Show Details page. Here they can see the show poster, the show descriptions, main actors, and a list of seasons with their corresponding episodes. On the navigation bar on this page, there is an action button, where a user can add/remove the show from their list. 

The user can also click a listed show episode, which will take them to the Episodes Details page. Here they can find an Episode still image, the episode decription, and the actors who appear in this episode.

##Frameworks/CocoaPods
- AlamoFire for the networking
- ObjectMapper for mapping json to objects
- Realm for the database/persistance

##To build project
- Download/Clone repo and find it in your terminal
- If needed, install CocoaPods `sudo gem install cocoapods`
- Install project pods using `pod install`
- open Xcode project file in terminal `open MyTVAddictions.xcworkspace`

##Thing I want to add
- A calender tab so users can see when their shows are airing next
- Rating/Review ability
- Push notifications for when a new episode of their show is airing
- Movies
