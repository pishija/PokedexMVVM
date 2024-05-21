# PokedexMVVM
Home assignment for BoostIT iOS Developer role. MVVM for fetching and liking Pokedex cards. 

# Architecture
This project is implemented using MVVM pattern. For projects of this type (one list screen and one details screen) the more structured patterns like VIPER will be overkill and the more simple patterns like MVP/MVC will not showcanse much of the candidate knowledge. The ModelView-View binding is done with Combine. Most of data flow from the View to the ViewModel is with delegates. For handling navigation and mamanging application state (maybe routing in the future) the Coordinator pattern is used. 

# Network
The network layer of the project is implemented with URLSession with helper interfaces where every endpoint is treated as resource with Payload and Response. 

# Data layer
For the sake of simplicity and brveity the API calls are peformed in the ViewModels. In normal circumstances the data layer will be a facade over the repository pattern. In order to give the architecture freedom to use any kind of storage interchangeably. 

# UI
The UI is simple just to showcase knowledge of UIKit. All of the UI code is written in code without using .nibs or .storyboards. 

# Dependencies
The project only uses frameworks from the iOS it does not use external dependencies. The reasoning behind this decision is because the future asigment will be working on one click payment SDK. When building SDK the developer's goal should be to have as least dependecies as possible. This simplifies the comilation of the SDK and lower the chances for dependcy hell for the users of the SDK. 
