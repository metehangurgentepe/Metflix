# Metflix

Metflix is a Netflix clone app built with Swift and UIKit, showcasing modern iOS development practices and techniques.

## Key Features

- MVVM (Model-View-ViewModel) Architecture
- UIKit Framework with Programmatic UI
- iOS 14.0+ Compatibility
- Swift Package Manager (SPM) for Dependency Management
- Core Data for Local Data Persistence
- Custom Network Layer for API Interactions
- SDWebImage for Efficient Image Loading and Caching
- Localization Support

## Screenshots

<table>
  <tr>
    <td><img src="https://raw.githubusercontent.com/metehangurgentepe/Metflix/refs/heads/main/Screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-10-11%20at%2012.46.53.png" width="200"/></td>
    <td><img src="https://raw.githubusercontent.com/metehangurgentepe/Metflix/refs/heads/main/Screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-10-11%20at%2012.46.57.png" width="200"/></td>
    <td><img src="https://raw.githubusercontent.com/metehangurgentepe/Metflix/refs/heads/main/Screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-10-11%20at%2012.47.02.png" width="200"/></td>
    <td><img src="https://raw.githubusercontent.com/metehangurgentepe/Metflix/refs/heads/main/Screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-10-11%20at%2012.47.18.png" width="200"/></td>
    <td><img src="https://raw.githubusercontent.com/metehangurgentepe/Metflix/refs/heads/main/Screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-10-11%20at%2012.47.47.png" width="200"/></td>
    <td><img src="https://raw.githubusercontent.com/metehangurgentepe/Metflix/refs/heads/main/Screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-10-11%20at%2012.49.14.png" width="200"/></td>
  </tr>
</table>

## Technologies Used

- **Swift**: The primary programming language for iOS development
- **UIKit**: The framework used for building the user interface
- **Xcode**: The integrated development environment (IDE) for iOS app development
- **Git**: Version control system for tracking changes in source code
- **GitHub**: Hosting platform for version control and collaboration

## API Usage

The app uses The Movie Database (TMDb) API for fetching movie data. Here are some of the key endpoints used:

### Get Popular Movies

```http
GET /api/movie/popular?language=en-US
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key |

### Get Movie Details

```http
GET /api/movie/${id}
```

| Parameter | Type      | Description                                        |
| :-------- | :-------- | :------------------------------------------------- |
| `id`      | `integer` | **Required**. Key value of the movie to be called  |

### Search Movies

```http
GET /api/search/movie
```

| Parameter | Type     | Description                                    |
| :-------- | :------- | :--------------------------------------------- |
| `query`   | `string` | **Required**. Name value of the movie to search|

### Get Movie Videos

```http
GET /api/movie/{id}/videos?language=en-US
```

| Parameter | Type      | Description                                       |
| :-------- | :-------- | :------------------------------------------------ |
| `id`      | `integer` | **Required**. Key value of the movie to be called |

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/Metflix.git
   ```
2. Open the project in Xcode
3. Build and run the project on your simulator or device

## Future Improvements

- Implement user authentication
- Add a watchlist feature
- Enhance UI with custom animations
- Implement offline mode using Core Data

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Feedback

If you have any feedback or questions, please reach out to me at metehangurgentepe@gmail.com

## License

This project is open source and available under the [MIT License](LICENSE).
