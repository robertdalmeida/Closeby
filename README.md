# Closeby

This application searches places by a query string and radius using the Foursquare API.

## Design
![image](https://user-images.githubusercontent.com/96450350/208196892-9bea012d-d801-4957-bb2c-32fb2a5b2a7c.png)

I'm not a fan of the ViewModel pattern for this sample app. The only reason I see the benifit of a view model here is keeping the `View` type smaller. 
I generally lean to not using a view model and use the store directly when possible.

## Highlights
- Simple dark mode and light mode UI
- Error states handled - No results & Error on API response
- Configurable Radius & query
- Using Combine to determine when to fetch results.
- Testable Store & View Models

## Improvements
- A more complete way to get user location. 
- Could integrate the Place Details and show more details of a place.
- Tests could be added by mocking the injected dependencies


## Shots - DarkMode


https://user-images.githubusercontent.com/96450350/208197420-97fa3404-80d0-4651-a86e-b1f82539cf5f.mov

## Shots - Light


https://user-images.githubusercontent.com/96450350/208197441-59508832-fbc9-462a-9375-7a2b6bffec3d.mov


