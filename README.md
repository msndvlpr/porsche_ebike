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
- **USB devices Scan**: User can scan and see real connected USB devices to the PC, as well as some mocked devices. 
- **BLE devices Scan**: User can scan and see real nearby Bluetooth devices to the PC, as well as some mocked devices.
- **Connect to device (bike)**: User can select any device in the list and then connect to fetch information and diagnostic data in a data stream format.
- **Fetch bike overview data**: Fetch bike overview data including bike description and image from backend 
- **State Management**: The application follows the Riverpod for state management and reactive development.
- **HTTP Rest Handling**: This application uses the http package for client-server communication over REST, with two mocked request handlers implemented—one for authentication and another for bike data—to simulate backend responses during development and testing.
- **Dark/Light Theme**: Application theme can be changed to Dark or Light.

## Project Architecture
### Overview
The application follows the Riverpod package for state management and adopts the MVVM (Model-View-ViewModel) design pattern within a Clean Architecture structure. This combination offers a clear separation of concerns,
improved scalability, and enhanced testability. Riverpod enables reactive, type-safe state handling with minimal boilerplate, while MVVM ensures a well-organized flow of data and business logic between the UI
and the underlying models. Clean Architecture further reinforces modularity by dividing the project into distinct layers and making the codebase easier to maintain, test, and extend.
Riverpod is also used to implement View-Model layer for playing an intermediary role between Repositories and User Interface.

### Structure
- **Repositories**: There are three repositories under `packages` directory, including `AuthenticationRepository` for user login stuff and the handling related business logic, `BikeMetadataRepository` for bike metadata handling and related business logic and also  
 `HardwareConnectivityRepository` for handling USB abd BLE connectivity stuff and data transmission from different devices. Each repository might also benefit from one or more APIs depending on its responsibilities.
- **APIs**: There are 4 APIs (or data-sources) under `packages` directory, including `NetworkAPI` for handling http requests from backend, `SecureStorageAPI` for storing and handling important
  data storage on the local, `BleConnectionAPI` for handling all Bluetooth related connectivity and `UsbConnectionAPI` for handling connectivity over USP port.
- **Modules**: Project has different modules based on the different features of the app, they are `app`, `user login` and `bike dashboard`. Then each module 
  contains its own sub folders including `state` for provider and State Management, `model` for Entities, `view` for User Interface and `widget` for reusable view elements.

(Following is the project structure based on MVVM pattern)

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
- The project uses `flutter_test` and `mocktail` for unit testing.
- Tests are available in the `test/` folder.
- Run tests using:
  ```sh
  flutter test
  ```
- Note: Tests under some packages might need run only via `flutter test` command, because sometimes Flutter has issues recognizing them as Test to be run visually.
  So if any test runs with problem just run it via terminal with above command.


## Running the Project
1. Install Flutter dependencies:
   ```sh
   flutter pub get
   ```
2. Build the project for MacOs:
   ```sh
   flutter build macos
   ```
3. Run it on MacOS:
   ```sh
   flutter run -d MACOS_DEVICE_ID

   ```
   
