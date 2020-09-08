import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader(
      {@required this.url,
      @required this.title,
      this.fallbackUrl,
      this.boxFit,
      this.titleStyle})
      : assert(url != null),
        assert(title != null);

  final BoxFit boxFit;
  final String url;
  final String title;
  final String fallbackUrl;
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
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                ),
      errorBuilder: (context, exception, stackTrace) => fallbackUrl == null
          ? _ImagePlaceholder(
              title: title,
              titleStyle: titleStyle,
            )
          : ImageLoader(
              url: fallbackUrl,
              title: title,
              boxFit: boxFit,
              titleStyle: titleStyle,
            ));
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({@required this.title, this.titleStyle})
      : assert(title != null);

  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          const Placeholder(),
          Center(
            child: Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}
