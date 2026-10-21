
# WhaTrain

### Location-Aware Train Information — iOS Prototype

[View Portfolio Case Study](https://lorenzobettin.github.io/projects/whatrain/)

## Overview

WhaTrain is a personal iOS development project exploring
how location services and railway information APIs could
provide passengers with convenient access to nearby
station and train information.

The prototype was developed using Swift, SwiftUI,
CoreLocation and the Nederlandse Spoorwegen (NS) API.

**Status:** Unreleased prototype. The intended real-time
information experience was not fully completed due to
API access and integration challenges.

## Project Objectives

- Obtain the user's location
- Identify a nearby railway station
- Request arrival and departure information
- Present railway information through a minimal interface

## Technologies

- Swift
- SwiftUI
- CoreLocation
- Combine
- URLSession
- REST APIs
- JSON decoding

## Architecture

### LocationManager.swift

Manages location permissions and position updates.

Includes a nearest-station calculation using geographic
coordinates and distance measurements.

### TrainDataManager.swift

Implements asynchronous API requests for:

- Station arrivals
- Station departures
- Upcoming-station information

Uses Combine publishers to process network responses
and publish data changes.

### Models.swift

Defines the data structures used by the application,
including train arrivals, departures and stations.

### SwiftUI Views

- ContentView.swift — Main interface
- StationDetailsView.swift — Station information screen
- UpcomingStationsView.swift — Upcoming station list
- WhaTrainApp.swift — Application entry point

## Challenges and Limitations

The original prototype encountered several difficulties:

1. Railway API access and response integration were incomplete.
2. Some UI properties were not updated by the data manager.
3. Location and API requests needed better asynchronous coordination.
4. The application was not distributed through the App Store.

Some schedule-related functionality remains unfinished.

## Running the Project

The repository contains exported Swift source files,
not a complete, ready-to-build Xcode project.

To continue development, the source would need to be
integrated into an Xcode iOS application project.

Additional requirements include:

- Xcode and the relevant iOS SDK
- Location permission configuration
- Required application image assets
- Valid NS API access and configuration
- Testing and possible updates to API response models

Never commit real API keys or other credentials.

## Development Status

WhaTrain remained a private demonstration prototype.

It is included in this portfolio to demonstrate experience
with native mobile development, location services,
asynchronous networking and API integration.

It should not be considered a production-ready
or fully functioning train information application.

## Portfolio

[WhaTrain — Full Project Description](https://lorenzobettin.github.io/projects/whatrain/)
