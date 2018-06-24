# CoreML-Classification-Comparison
Compare the classification results from different standard CoreML models als Firebase MLKit. You can search for public images with tags on Flickr or you can use images from your library or the camera to compare the different models.

## Prerequisites
- Xcode: 9.4.1
- Swift: 4.1
- iOS: 11.4

## Setup 
- run 'pod install' on your terminal
- open 'CoreML-Classification-Comparison.xcworkspace' in Xcode

In your 'Pods' project set the Swift language version for 'Diff' to 3.3 (Build Settings)

## Features
### Flickr Image Search
<img align="right" width="100" src="https://github.com/MSWagner/CoreML-Classification-Comparison/blob/master/Screenshots/FlickrSearch.PNG">

You can search for images on Flickr with adding text into the searchbar. The minimum character count is 3. From then on the images will updated live and you have the possibilty to go through the differnt pages for a tag.

If you select an image, you will be forwarded to the classification screen.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
