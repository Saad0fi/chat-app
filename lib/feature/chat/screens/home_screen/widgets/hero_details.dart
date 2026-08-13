import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('عرض الصورة')),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              : const Icon(Icons.error_outline, size: 50),
        ),
      ),
    );
  }
}
