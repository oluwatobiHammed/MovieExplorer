# MovieExplorer
A simple iOS app that allows users to search for movies and view their details

The master view shows a list of movies. Select a movie to show the details of the movie.

The movie detail view has multi views.

The Favorite pictures liked status are saved locally to keep the state of the like button 

## System Requirements

* Xcode 14.0+ for iOS version 
* iOS 14+
* macOS 13+

## Search Movies

Type in search bar to search for movies


### iOS

Tap the movie tile to view full detail of each movies


## Interesting Files

* The `MovieListViewController.swift` and `MovieViewModel.swift` files have all the core logic of list of movies.
* The `MovieDetailsViewController.swift` and `Movie.swift` files have the code for details of each movies.
* The `MovieDetailTableViewCell.swift` and `Movies.swift` files have the code for what is displaying what is on the tile.
* The `FavoriteMoviesViewController.swift` and `Movies.swift` files have the code for displaying favorite movies.

## Package Dependencies (Used Swift Package Manager)

* https://github.com/realm/realm-swift
* https://github.com/SnapKit/SnapKit
* https://github.com/onevcat/Kingfisher.git

## Description On my Decisions
* I used MVVM achitectural pattern because, i am very familiar with it and its easier to write clean, readable, maintainable code and isolate each functionality. It was a bit hard because it gets complex when setting up the code base but, using dependency injection makes it easier to achieve my goal.
* I wanted go with the Best UI Practise so i made sure the UI is Purposeful and easy to use. I had help from my wife to use the app and give me feedback on noticable bugs that i fixed.

## Future Improvement 
* I will add log in functionality to make it possible for different users to have there profile and list of favorite movies and add now showing moving 

## Screen Shot

![IMG_2618](https://github.com/oluwatobiHammed/MovieExplorer/assets/50711478/2a340f87-0d79-4365-81d7-523a6cc0cd8b)

![IMG_2619](https://github.com/oluwatobiHammed/MovieExplorer/assets/50711478/55f49a47-148c-4872-b704-1dd1544a06d5)

![IMG_2620](https://github.com/oluwatobiHammed/MovieExplorer/assets/50711478/749d5ac9-b3f3-4ed6-8bb4-11826a3cc14a)


