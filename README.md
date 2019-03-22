# MovieDB :popcorn:
App to show movies using MovieDB API

## Setup :wrench:
This project was made with XCode 10.1 and has the following requisites:

- <a href="https://github.com/Carthage/Carthage">Carthage</a>
- an api key for <a href="https://www.themoviedb.org">MovieDB</a>


To perform the setup:

<span>(1)</span> Clone the project <br>
<span>(2)</span> run `carthage update --platform iOS` <br>
<span>(3)</span> <a href="#Setup-the-API-Key-:key:">Setup the API Key</a> <br>
<span>(4)</span> Open the .xcodeproj file from XCode <br>
<span>(5)</span> Run! :bomb: <br>

## Setup the API Key :key:
To setup the API key, you first need to create a key from <a href="https://www.themoviedb.org" >MovieDB</a>,
then create a file in `MovieDB/MovieDB/API_KEY.plist` with the following content:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>API_KEY</key>
        <string>**YOUR-API-KEY**</string>
</dict>
</plist>
```

And you are good to go! :sunglasses:
