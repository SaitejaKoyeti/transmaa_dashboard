import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

class ImageDetailScreen extends StatelessWidget {
  final List<String> imageUrls;

  ImageDetailScreen({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var imageUrl in imageUrls)
              Column(
                children: [
                  Image.network(imageUrl),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Download image on button click
                        var imageId = await ImageDownloader.downloadImage(imageUrl);
                        if (imageId == null) {
                          // Handle download failure
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to download image'),
                          ));
                          return;
                        }
                        // Retrieve the filename of the downloaded image
                        var fileName = await ImageDownloader.findName(imageId);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Image downloaded as $fileName'),
                        ));
                      } catch (error) {
                        print('Error downloading image: $error');
                        // Handle download error
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error downloading image'),
                        ));
                      }
                    },
                    child: Text('Download'),
                  ),

                ],
              ),
          ],
        ),
      ),
    );
  }
}
