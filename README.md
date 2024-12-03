# Public Transport Route and Stop Plotter
## Use
1. Enter your location

![Simulator Screenshot - iPhone 16 Pro - 2024-12-02 at 23 38 32](https://github.com/user-attachments/assets/b7ada7db-a280-4736-8f8e-80496d3e2a56)

2. Select a route to view more information about it (map, stop names and location, wheelchair access)

 ![Simulator Screenshot - iPhone 16 Pro - 2024-12-02 at 23 39 28](https://github.com/user-attachments/assets/15194b79-930e-4426-930e-25bc341addca)

3. Press back to return to the home screen

App in action:


https://github.com/user-attachments/assets/f66c8e2e-df23-4f33-890d-ab4229771b5e

## Tools and Purpose
I used Swift to develop this application and used JSONDecoder() in my services which decoded the response from Transit API.

## Features
- Custom location entry and range
- Real time data on routes and stops
- Plotting of stops
- Name, location, and wheelchair access info provided for each stop

## Obstacles and future additions
Initially, the data structures provided by Quicktype had to be edited to work. The biggest issue is that I was unable to get user location in the simulator. Future editions may incorporate real time tracking on the map, and automatic location detection. 







