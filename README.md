# Collinson Assignment

## 1. Project overview

It helps users find activities that are suitable for the weather in a selected city. A user can search for a city, retrieve its forecast, and see activity recommendations ranked by how suitable the forecast is for each activity.

The activity categories include:

- Skiing
- Surfing
- Outdoor sightseeing
- Indoor sightseeing

The application uses weather data to calculate a suitability score for each activity and presents the results in ranked order.

## 2. Platform and tooling choices

| Area | Choice | Reason |
|---|---|---|
| Platform | iOS | The assignment is delivered as a native iOS application. |
| Language | Swift | Native language for the iOS implementation. |
| UI | SwiftUI | Declarative UI and state-driven rendering. |
| Reactive state | Combine | Used for reactive data flow, observing published state, and coordinating input changes where appropriate. |
| Architecture | Clean Architecture | Separates presentation, business rules, and external data access. |
| Concurrency | Combine | Used for asynchronous operations where implemented. |
| Weather and location data | Open-Meteo APIs | Provides geocoding and forecast data without requiring an API key for the endpoints used by this project. |
| IDE/build | Xcode | Native iOS development, simulator, build, and test tooling. |

## 3. Architecture and technical decisions
The project follows Clean Architecture, with dependencies directed towards the domain layer.

### Presentation
The presentation layer contains SwiftUI views and ViewModels.
Its responsibilities are to:
- Display city search and activity recommendations.
- Handle user input and user interactions.
- Expose screen state to SwiftUI.
- Call domain use cases rather than making API requests directly.
- Represent loading, content, and error states.

Combine is used for reactive state and input handling. For example, a search text publisher can use `debounce` and  to avoid issuing a request for every keystroke.

### Domain
The domain layer contains the application's business rules and is independent of API response formats.
Typical responsibilities include:
- Representing domain entities such as a city, weather forecast, and activity recommendation.
- Defining repository protocols.
- Providing use cases for searching cities, retrieving forecasts, and generating recommendations.
- Calculating activity suitability and ranking results.
Keeping recommendation logic in the domain layer makes it possible to test the rules without calling a live weather API.

### Data
The data layer handles external data sources.
Its responsibilities are to:
- Call the Open-Meteo geocoding and forecast endpoints.
- Decode API responses into data-transfer models.
- Map API models into domain models.
- Implement the repository protocols defined by the domain layer.
- Translate or propagate data-source errors for the upper layers to handle.

### Main dependency flow

```text
SwiftUI View
    |
    v
ViewModel
    |
    v
Use Case
    |
    v
Repository Protocol
    |
    v
Repository Implementation
    |
    v
API Client
    |
    v
Open-Meteo API
```

The domain layer does not depend on SwiftUI, Combine, or Open-Meteo response models. This keeps the core business rules easier to test and change.

### Notable technical decisions

- **Repository abstraction:** The domain layer depends on protocols rather than concrete networking implementations. This allows a mock repository to be supplied during tests.
- **Use cases:** Application operations are represented separately from UI code, keeping ViewModels focused on presentation state and user interaction.
- **Reactive state:** Combine supports observation of changing input and ViewModel state. It is used where a publisher-based flow is useful; it is not added to every operation merely for the sake of using the framework.
- **Asynchronous networking:** Network work is asynchronous so the UI does not need to wait synchronously for API responses.
- **Separate recommendation logic:** Scoring and ranking are kept out of SwiftUI views so that the rules can be tested independently.

## 4. How to build and run
### Requirements
- macOS with a compatible version of Xcode.
- An iOS Simulator runtime supported by the project.
- Git.

### Steps

1. Clone the public repository:

   ```bash
   git clone <PUBLIC_GITHUB_REPOSITORY_URL>
   cd <REPOSITORY_DIRECTORY>
   ```

2. Open the Xcode project or workspace:

   ```bash
   open <PROJECT_NAME>.xcodeproj
   ```
   
3. In Xcode, select the application scheme and an available iOS Simulator.

4. Build and run using **Product → Run**, or press `Cmd + R`.

No API key should be required for the Open-Meteo endpoints used by this project. If the implementation adds another service or configuration requirement, document it here.

## 5. How to run tests and testing strategy
Run the test suite in Xcode using **Product → Test** or `Cmd + U`.
A command-line test can be run after confirming the scheme and simulator destination:

```bash
xcodebuild test \
  -project <PROJECT_NAME>.xcodeproj \
  -scheme <SCHEME_NAME> \
  -destination 'platform=iOS Simulator,name=<SIMULATOR_NAME>'
```

## 6. API usage notes
The application uses Open-Meteo for city lookup and weather forecasts.

### Geocoding API
Used to search for a city and obtain the coordinates needed for the forecast request.
Documentation: https://open-meteo.com/en/docs/geocoding-api

### Forecast API
Used to retrieve forecast data for the selected city's latitude and longitude.
Documentation: https://open-meteo.com/en/docs
The forecast request should ask only for the weather variables required by the recommendation logic. Depending on the implementation, these can include:
- Temperature
- Precipitation probability
- Wind speed
- Snowfall
- Weather condition codes

### API considerations
- City search results should be handled when no match is found.
- Network failures and unsuccessful HTTP responses should not be treated as valid forecast data.
- Decoding failures should be reported as errors rather than silently converted into misleading recommendations.
- Forecast values should be interpreted using the units and meanings documented by Open-Meteo.
- The application should avoid unnecessary requests, particularly while the user is typing a city name.

## 7. Activity recommendation logic
The application uses a rule-based scoring approach to estimate how suitable the forecast is for each activity.
The general process is:
1. Read the relevant weather values from the forecast.
2. Normalize or evaluate those values against activity-specific reference ranges.
3. Calculate a suitability score for each activity.
4. Apply severe-weather handling where required.
5. Sort activities by score to show the most suitable activity first.

Different activities use different weather factors. For example:
| Activity | Relevant weather factors |
|---|---|
| Skiing | Cold temperatures, snowfall, and wind conditions |
| Surfing | Wind and other forecast conditions relevant to the implementation |
| Outdoor sightseeing | Dry conditions, comfortable temperature, and calm weather |
| Indoor sightseeing | Conditions that make outdoor activities less suitable |

### Scoring design
The scoring approach uses weighted factors. A factor's weight represents its relative contribution to the activity's overall score. The weights are product decisions and heuristic assumptions, not scientifically validated probabilities.
overall score ranges from 1 to 100 
       
        let dry = 1 - day.precipitationProbability / 100
        let calm = max(0, 1 - day.maximumWindSpeed / 50)
        let comfort = max(0, 1 - abs(temperature - 21) / 21)
        let snow = min(day.snowfall / 5, 1)
        let cold = max(0, min(1, (5 - temperature) / 15))
        let warm = max(0, min(1, (temperature - 8) / 16))
        let severe = day.hasThunderstorm || day.maximumWindSpeed >= 60
        
        let outdoor = severe ? 0 : 100 * (0.45 * dry + 0.35 * comfort + 0.20 * calm)
        let skiing = severe ? 0 : 100 * (0.60 * cold + 0.25 * snow + 0.15 * calm)
        let surfing = severe ? 0 : 100 * (0.45 * warm + 0.30 * calm + 0.25 * dry)
        let indoor = 100 * (0.35 + 0.35 * (1 - dry) + 0.20 * (1 - comfort) + 0.10 * (1 - calm))
- Outdoor sightseeing
- Skiing
- Surfing `
- Indoor sightseeing

### Limitations of the model
The score is a recommendation heuristic, not a guarantee that an activity is safe or suitable. It is limited by the forecast variables, forecast accuracy, and thresholds selected for this assignment. It should not replace local safety guidance or activity-specific checks.
