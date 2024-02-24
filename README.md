
# Metflix



# Key Features
- MVVM Design Pattern
- UIKit Framework
- Compatible with iOS 14.0+
- Fully SPM build
- SDWebImage 




## Screenshot

![Application Screenshot](https://raw.githubusercontent.com/metehangurgentepe/Metflix/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20-%202024-02-23%20at%2012.53.50.png)
![Application Screenshot](https://raw.githubusercontent.com/metehangurgentepe/Metflix/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20-%202024-02-23%20at%2012.53.58.png)
![Application Screenshot](https://raw.githubusercontent.com/metehangurgentepe/Metflix/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20-%202024-02-23%20at%2012.54.36.png)
![Application Screenshot](https://raw.githubusercontent.com/metehangurgentepe/Metflix/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20-%202024-02-23%20at%2012.54.26.png)


  
## Technologies Used

**Swift** 

**UIKit** 

**XCode** 

**Git** 

**Github** 

  
## API Usage

#### Get popular movies

```http
  GET /api/movie/popular?language=en-US
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key. |

#### Get movie details

```http
  GET /api/movie/${id}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `integer` | **Required**. Required. Key value of the movie to be called |


```http
  GET /api/search/movie
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `query`      | `string` | **Required**. Name value of the movie to be called |


```http
  GET /api/movie/{id}/videos?language=en-US
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `integer` | **Required**. Key value of the movie to be called |



  
## feedback

If you have any feedback, please contact us at metehangurgentepe@gmail.com

  
