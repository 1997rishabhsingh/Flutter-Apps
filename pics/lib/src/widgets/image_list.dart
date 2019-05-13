import 'package:flutter/material.dart';

import '../models/image_model.dart';

class ImageList extends StatelessWidget {
  final List<ImageModel> images;

  ImageList(this.images);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, int index) {
        return buildImageItem(images[index]);
      },
    );
  }

  Widget buildImageItem(ImageModel imageModel) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: <Widget>[
          Image.network(imageModel.url),
          Padding(padding: EdgeInsets.all(5)),
          Text(imageModel.title),
        ],
      ),
    );
  }
}
