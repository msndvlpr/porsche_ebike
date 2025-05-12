# PORSCHE E-BIKE Performance Coding Challenge

## Overview
This project is a Flutter-based application for Porsche Ebikes Performance diagnostic purposes, where technician users can connect to an ebike via Bluetooth or USB interface and fetch the bike data and 
diagnostic information in a real-time basis. The application is designed and tested to run on MacOS as mentioned in the requirement document (Windows or MacOS).
The application has several features including scanning and finding available USB and BLE devices, fetching diagnostic information via stream, authentication, dark mode etc. 

## Project Assumptions
This project has been fully developed and tested on MacOS only. According to the challenge requirements, either of MacOS and Windows were the supported platforms. However, I did not have access to a Windows machine 
during development, so full compatibility on Windows could not be verified but can be easily provided.
While the application may run on other platforms, please note that it is officially tested and guaranteed to work on macOS.


## Technical Features
- **User Authentication**: Uses an Authentication Repository and a mocked HTTP handler. Authentication is simulated based on a random username and password, and based on any user input login will be successful.
- **VIN/Vehicle Search**: User can search for vehicles using a VIN. Based on the VIN, the user may get a full match or a list of similar vehicles.
- **Auction Data**: Users can select vehicles and view their auction details.
- **Caching**: Data is cached per VIN in the `VehicleSearchScreen` and per External ID (EID) in the `VehicleSelectionScreen`.
- **State Management**: The application follows the BLoC architecture pattern for state management and handles UI states Consequently.
- **VIN Validation**: A validator method checks user input based on Wikipedia and other online sources.
- **Dark Theme**: Application theme can be changed to Dark or Light.

## Project Architecture
### Overview
This project follows the Clean Architecture and **Riverpod** for state management. pattern for state management and also as the development architecture. It might be also similar to MVVM, because different layers in BLoC have a corresponding 
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
├── bike_dashboard/
│   ├── state/
│   ├── view/
│   ├── widget/
│
├── user_login/
│   ├── state/
│   ├── view/
│
├── theme/
│   ├── state/
│
├── vehicle_search/
│
├── main.dart
│
packages/
├── bike_metadata_repository/
├── authentication_repository/
├── hardware_connectivity_repository/
├── network_api/
├── secure_storage_api/
├── bluetooth_connection_api/
├── usb_connection_api/
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
In this screen user should enter it's username and password for the authentication, as the application deals with important diagnostic information about the bike usage the authentication is necessary to 
provided protection for unauthorised access to the app and to the client-backend communication. for simulating a real login, username and password are arbitrary and 
success response will be returned from a Mocked Http Handler. Once the authentication is successful a token will be responded and it will be saved in a
local Secure Storage with the Username to be used later for calling other backend endpoints (such as getting bike overview information, bike description and image).

### Bike Dashboard Screen
In this screen which is the main screen, there are three section including scanned and found USB and BLE devices to connect (left pane), bike diagnostic data readings which will be shown in a real time channel (center pane),
and the bike overview section in which bike additional information including the image will be displayed (right pane).
There are also two buttons in the left pane, one for scanning nearby devices and a another for connecting and disconnecting to the device (ebike) and starting the realtime data stream. As requested in the requirement
document, there are two bike models for which the received data model differ, and also some data attributes should be updated on a continuous basis (such as Gyroscope) and some other attributes should be changed once 
per request (sun as Last Error).



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
   
