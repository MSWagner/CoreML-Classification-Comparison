# CoreML-Classification-Comparison
Compare the classification results from different standard CoreML models and Firebase MLKit. You can search for public images with tags on Flickr or you can use images from your library or the camera to compare the different models.

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

<br><br>

### Image classification
You can classify the selected image with different CoreML models or Firebase MLKit. In the settings you can set the precision for results, which should be shown on the screen and saved, if you press the save button. You can also preprocess the images for the CoreML models to the recommended input image size and you have the option to see the resized images. 

The saved images (flickr urls and classification results) are stored localy and remote in Firestore. You can search for the stored results on the right tabBarButton.

| MLTypes | MLKit Results | Settings |
|----------|-----------|-----------|
|<img src="https://github.com/MSWagner/CoreML-Classification-Comparison/blob/master/Screenshots/MLModelTypes.PNG" width="150">|<img src="https://github.com/MSWagner/CoreML-Classification-Comparison/blob/master/Screenshots/DogClassification.PNG" width="150">|<img src="https://github.com/MSWagner/CoreML-Classification-Comparison/blob/master/Screenshots/Settings.PNG" width="150">|

### Stored Result Search
<img align="right" src="https://github.com/MSWagner/CoreML-Classification-Comparison/blob/master/Screenshots/SearchSavedTags.PNG" width="150"><img align="right" src="https://github.com/MSWagner/CoreML-Classification-Comparison/blob/master/Screenshots/ImagePickerAction.PNG" width="150">

You can search for stored classification results and linked images from Flickr.

<br>

### Library / Camera Support

If you want to classify your own picture, you can click on the red camera button in the TabBar. It's also possible to preprocess an image from the camera.

<br><br>

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
