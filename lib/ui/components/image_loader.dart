import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader(
      {@required this.url,
      @required this.title,
      this.backdropUrl,
      this.boxFit,
      this.titleStyle})
      : assert(url != null),
        assert(title != null);

  final BoxFit boxFit;
  final String url;
  final String title;
  final String backdropUrl;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) => Image(
        fit: boxFit ?? BoxFit.fitHeight,
        image: NetworkImage(url),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  ),
        errorBuilder: (context, exception, stackTrace) => backdropUrl == null
            ? _ImagePlaceholder(
                title: title,
                titleStyle: titleStyle,
              )
            : Image(
                fit: boxFit ?? BoxFit.fitWidth,
                image: NetworkImage(backdropUrl),
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                errorBuilder: (context, exception, stackTrace) =>
                    _ImagePlaceholder(
                  title: title,
                  titleStyle: titleStyle,
                ),
              ),
      );
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({@required this.title, this.titleStyle})
      : assert(title != null);

  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          const Placeholder(),
          Center(
            child: Text(
              '$title',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}
