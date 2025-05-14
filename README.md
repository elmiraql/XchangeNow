# XchangeNow iOS App -  Technical assignment for an iOS Developer position.  

Created as part of a hiring process.

An iOS application with two main features:

1. Currency Converter – converts currencies based on API data.
2. Online Quotes – displays real-time quotes via WebSocket.

## Features:

### Currency Converter
- Fetch a list of currencies from the API
- Select a base and target currency
- Dynamically convert based on user input and currency changes
- Utilizes async/await, follows the Clean Swift architecture

### Online Quotes
- Receive real-time quotes via WebSocket
- Option to hide or show specific quotes
- Caches the most recently received state
- Automatically reconnects if the connection drops

## Architecture
- Clean Swift (VIP)
- Logic separated into Interactor, Presenter, View, and Worker
- Modular approach

## Testing
- Unit tests for the Interactor and Presenter
- Tests for conversion logic, data fetching, and error handling

## Tech Stack
- Swift, UIKit
- URLSession, WebSocket
- UserDefaults (for caching)
- XCTest (for testing)

## Installation
1. Clone the project
2. Open the .xcodeproj file in Xcode
3. Run on a simulator or a real device

## Author

Developed by Elmira: https://github.com/elmiraql 😊
