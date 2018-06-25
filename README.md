# CoreML-Classification-Comparison
Compare the classification results from different standard CoreML models and Firebase MLKit. You can search for public images with tags on Flickr or you can use images from your library or the camera to compare the different models.

## Prerequisites
- Xcode: 9.4.1
- Swift: 4.1
- iOS: 11.4

## Setup 
- run 'pod install' in your terminal
- add your 'GoogleService-Info.plist' from Firebase
- add your Flickr APIKey and Secret in Config.Flickr
- open 'CoreML-Classification-Comparison.xcworkspace' in Xcode

##### Download CoreML models:
- [SqueezeNet](https://firebasestorage.googleapis.com/v0/b/classification-comparison.appspot.com/o/SqueezeNet.mlmodel?alt=media&token=2b6a193e-0829-49c8-b809-5558c0464b40)
- [Resnet50](https://firebasestorage.googleapis.com/v0/b/classification-comparison.appspot.com/o/Resnet50.mlmodel?alt=media&token=80cb6718-06af-49ce-bbcc-809c6352ed54)
- [MobileNet](https://firebasestorage.googleapis.com/v0/b/classification-comparison.appspot.com/o/MobileNet.mlmodel?alt=media&token=97c6c5c4-ed36-48ce-a0f8-9c70ded3876d)
- [Inceptionv3](https://firebasestorage.googleapis.com/v0/b/classification-comparison.appspot.com/o/Inceptionv3.mlmodel?alt=media&token=f570ce5b-98a9-4964-8770-65da02a76931)
- [GoogLeNetPlaces](https://firebasestorage.googleapis.com/v0/b/classification-comparison.appspot.com/o/GoogLeNetPlaces.mlmodel?alt=media&token=6708b74c-07ae-4dba-b2ce-acc56dc543aa)

Drop the models in CoreML-Classification-Comparison/Utilities/MLModels and build the project

##### Add new CoreML models:
Drop the new CoreML model in the project and add the model to the MLModelType enum.
Then you can add your additional CoreMLViewModel with your new model type in the init of the ImageProcessingViewModel.

You can find additional models also here: https://github.com/likedan/Awesome-CoreML-Models

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
