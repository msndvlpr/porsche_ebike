# CarOnSale Vehicle Auction App- A Coding Challenge

## Overview
This project is a Flutter-based application for vehicle auctions, where users can search for vehicles by VIN, view auction details, and authenticate using a repository-based 
authentication system. It also supports caching mechanisms, dark theme and also UI state handling for improved user experience in case of network success or failures.

## Features
- **User Authentication**: Uses an Authentication Repository and a mocked HTTP handler. Authentication is simulated with random success/failure responses.
- **VIN/Vehicle Search**: User can search for vehicles using a VIN. Based on the VIN, the user may get a full match or a list of similar vehicles.
- **Auction Data**: Users can select vehicles and view their auction details.
- **Caching**: Data is cached per VIN in the `VehicleSearchScreen` and per External ID (EID) in the `VehicleSelectionScreen`.
- **State Management**: The application follows the BLoC architecture pattern for state management and handles UI states Consequently.
- **VIN Validation**: A validator method checks user input based on Wikipedia and other online sources.
- **Dark Theme**: Application theme can be changed to Dark or Light.

## Project Architecture
### Overview
This project follows the **BLoC** (Business Logic Component) pattern for state management and also as the development architecture. It might be also similar to MVVM, because different layers in BLoC have a corresponding 
layer in MVVM, for example the view layer is the same, external packages for repositories and APIs correspond to repositories and datasources in the model layer
of MVVM, and bloc layer is also acting the same as view-model in MVVM. The reason why I have used BLoC for the above purposes is that it offers a structured and 
testable way to manage complex states and business logic in Flutter, promoting maintainability and scalability by clearly separating business logic from UI. On the
other hand it has also a very high number of reputation and popularity among Flutter developers.

### Structure
- **Repositories**: There are 2 repositories under `packages` directory, including `AuctionRepository` for managing backend requests for VIN and auction search stuff, and another 
  `AuthenticationRepository` for managing user authentication. The application business logic should be handled here.
- **APIs**: There are 2 APIs under `packages` directory, including `NetworkAPI` for handling http requests from network, and another `SecureStorageRepository` for handling secure
  local storage possibility in Flutter.
- **Modules**: Project has different modules based on the different features of the app, they are `User Authentication`, `Vehicle Search` and `Vehicle Auction`. Then each module 
  contains its own sub folders including `bloc`, `model`, `view` and `widget` (some of them might be not available for every module).
  - **bloc**: Serving as the state management framework and also acting as a intermediary layer between the repositories and the UI layer
  - **model**: Containing the data models necessary for UI layer. 
  - **view**: Serving as the contacting point of the application with user interaction and only responsible for data representation and not any business logic.
  - **widget**: Containing necessary UI widgets for reusing in different views.

(Following is the project structure based on bloc pattern)

### Project Structure Overview
```
lib/
├── app/
│   ├── app.dart
│   ..
│
├── user_authentication/
│   ├── bloc/
│   ├── view/
│   ├── widget/
│
├── utils/
│
├── vehicle_auction/
│   ├── bloc/
│   ├── model/
│   ├── view/
│   ├── widget/
│
├── vehicle_search/
│
├── main.dart
│
packages/
├── auction_repository/
├── authentication_repository/
├── network_api/
├── secure_storage_api/
│
test/
│
assets/
│
pubspec.yaml
..
```

## Screen Flow and Features Overview

### Login Screen:
In this screen user should enter it's username and password for the identification (authentication), for simulating a real situation username and password are arbitrary and 
on a random basis success or failure response will be returned from a Mocked Http Handler. Once the authentication is successful a token will be responded and it will be saved in a
local Secure Storage with the Username to be used later for the calling other mocked http requests (for auctions etc.), then it will be navigated to the next screen and for the
next time of application launch, the login page will be skipped as requested in the requirement document.

### Vehicle/VIN Search Screen:
In this screen a text field is provided to enter a VIN and it will be validated by a validator utility class upon user entry. Based on the requirement document there will be
a few number of response types, so if the response id an error or failure it will be shown here, otherwise it will navigate to the next page to display the corresponding 
vehicle auction data. User can also enable "use cache" feature by which a cached version of data will be shown if we receive error from backend (i.e. mocked http handler). 
Please also note that cached data is per VIN, so if we already receive a successful response for a VIN and then we enable use cache feature, then upon getting failure from 
backend, the cached data will be shown.
In this page user can also change the theme to dark or light, and also logout from th current user from the top left option menu, then they will be requested again to enter
username and password to authenticate and previous authentication data (i.e. token  and username) will be cleared from local storage.

### Vehicle Selection Screen:
This page will show the data in case of MultipleChoice (300 code) response, so all the vehicle options will be shown according to their similarity number from top to bottom. Also an
indicator is used to visualise the similarity number to the user. If user clicks on each arbitrary item, then "External Id" of the item will be used to call another backend endpoint
to fetch the Auction Details and accordingly and then navigate to the Auction Details Screen. 
Note: As it has been requested in the requirements document not to manipulate the mocked
http handler class, so response type 300 was filtered out and accounted as an error response in order to simulate a separate service for getting Auction Details from external id (EID).
If caching feature is enabled in the previous page, here it will also apply and if a data per EID is already cached, then in case of getting error response from backed, it will be shown.

### Auction Details Screen:
This screen is responsible to show the Auction Details data, it is possible to come to this page directly from VIN search screen if the response is 200, or from Vehicle Search Screen
when clicking on an option and receive a non error response. At the first glance, some important information of an auction/vehicle will be shown, and then user can click on the arrow
icon to expand the box and see further details including the relevant dates etc.


## Testing
- The project uses `flutter_test` and `mocktail` for unit and widget testing.
- Tests are available in the `test/` folder.
- Run tests using:
  ```sh
  flutter test
  ```
- Note: Tests under the 4 packages might need run only via `flutter test` command, because sometimes Flutter has some issues recognizing them as Test to be run visually.
  Other Tests in the main app may run without issue either visually or command line. 

## VIN Validation
- A static validator in `utils/data_validator.dart` checks user input.
- The validation logic is based on real-world VIN examples.
- While accurate, it may not be 100% reliable. (successfully tested with valid WBAYK510405N35485 vin)

## Running the Project
1. Install Flutter dependencies:
   ```sh
   flutter pub get
   ```
2. Run the application:
   ```sh
   flutter run
   ```
   
