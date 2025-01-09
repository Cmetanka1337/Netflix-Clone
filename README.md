# Netflix Clone
[![temp-Imagetf-XUc-R.avif](https://i.postimg.cc/zXsJmHjQ/temp-Imagetf-XUc-R.avif)](https://postimg.cc/dL9Mr1gR)

# Project overview

This project is an educational app that simulates the interface and some of the functionality of the original Netflix. The app retrieves movie data and displays it to the user through a simple and intuitive interface.

## Technologies and Tools
* __UIKit__: The interface is built using UIKit to create a seamless user experience.
* __The Movie Database API__: Movie data is fetched via The Movie Database (TMDb) API.
* __APICaller__: URLSession and JSONDecoder are used for fetching and parsing data. Escaping completion handlers are used to pass both success responses and errors.
* __SDWebImage__: The SDWebImage library is used for efficient image downloading, caching, and displaying.
* __YouTube API__ : The YouTube API is used to display movie trailers on the Overview page using WKWebView.
* __Core Data__ : Core Data is used to store movie data locally within the app.
* __Error Handling__ : The app includes views that notify users about errors and confirm when a movie has been successfully saved.

## Functionality
* Viewing movie information from __TMDb__.
* Displaying movie trailers from __YouTube__.
* Saving selected movies using __Core Data__.
* __Notifying users__ about the successful saving of a movie or errors during data fetching.

# Screenshots
### Home Page
![](https://i.postimg.cc/7hVCWY3h/temp-Image-Jmn0-R9.avif)

[![temp-Image9-Lj-Qgp.avif](https://i.postimg.cc/BbhGwXvm/temp-Image9-Lj-Qgp.avif)](https://postimg.cc/wRsP1xLN)
#
### Upcoming Page
[![temp-Image-MRu-TFk.avif](https://i.postimg.cc/VsBb64xw/temp-Image-MRu-TFk.avif)](https://postimg.cc/7bhLt1Pt)
#
### Search Page
[![temp-Image3js-NKP.avif](https://i.postimg.cc/2ymbGBBg/temp-Image3js-NKP.avif)](https://postimg.cc/Q94dxCmq)

[![temp-Image8w9-Yzc.avif](https://i.postimg.cc/mrzHg4sp/temp-Image8w9-Yzc.avif)](https://postimg.cc/SX4sgwjc)

#### Error handling
[![temp-Imagez-WKJd5.avif](https://i.postimg.cc/Qdn7DtRW/temp-Imagez-WKJd5.avif)](https://postimg.cc/FY3zg9F9)
#
### Overview Page

[![temp-Image7n-SOCN.avif](https://i.postimg.cc/9Qf9sTNh/temp-Image7n-SOCN.avif)](https://postimg.cc/kBkDbVm1)

[![temp-Imagej-FCDF8.avif](https://i.postimg.cc/m2ckMskQ/temp-Imagej-FCDF8.avif)](https://postimg.cc/HVgTDFQx)

[![temp-Imageaw-SDxt.avif](https://i.postimg.cc/m2jMdVjj/temp-Imageaw-SDxt.avif)](https://postimg.cc/N5y5F6W2)
#
### Downloaded Page
[![temp-Imageoo-PKs-W.avif](https://i.postimg.cc/yYscX2mW/temp-Imageoo-PKs-W.avif)](https://postimg.cc/CdrRwP6V)

# How to download
Since the project uses a third-party library __SDWebImage__, you need to install it through _Swift Package Manager_.
And then in XCode, click _"Add Existing project"_ and paste this link there 

```
https://github.com/Cmetanka1337/Netflix-Clone.git
```

Or by running the following command in the console
```
git clone https://github.com/Cmetanka1337/Netflix-Clone.git
```

# The project was partly based on the tutorial
> https://youtu.be/KCgYDCKqato?si=mWvyUSg0uy2rhyVP
