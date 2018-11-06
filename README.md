# OnTheMap


iOS Developer Nanodegree Project

The On The Map is result of **iOS Networking with Swift** lesson of **Udacity's iOS Developer Nanodegree** course.

The On The Map app allows udacity students to share their location and a URL with their fellow students. On The Map uses pins on a map to provide a visual representation of student locations. 

If the user is not a Udacity Student, there is a SignUp button provided on the login screen. The user will sign up, go back to the login screen, and proceed to login. 

After logging in , a map appears with pins already populated via code to access the Udacity/Parse API which includes infomration previously posted by past users. Each pin contains a name and a custom URL which is verified within the code. After viewing the information posted by other students, a user can post their own location and link via the add (+) button.

## Implementation
The app has five view controller scenes:

**Login** - allows the user to log in using their Udacity credentials or SignUp (via Safari on the Udacity page) to obtain credentials. 

When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers. 

If the login fails, alert views are available to inform the user as to why. 

**MapView** - displays a map with pins specifying the last 100 locations posted by students.

When the user taps a pin, it displays the pin annotation popup, with the student’s name (pulled from their Udacity profile) and the link associated with the student’s pin.

Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.

**TableView** - displays the most recent 100 locations posted by students in a table. Each row displays the name from the student’s Udacity profile and the link they have posted. Tapping on the row launches Safari and opens the link associated with the student.

**Add Location** - allows users to add their location and a their contact(linkedin or website). If the user already added their location and website they can overwrite it if they choose to do so.


## Requirements
Xcode 8.0 Swift 3.0
