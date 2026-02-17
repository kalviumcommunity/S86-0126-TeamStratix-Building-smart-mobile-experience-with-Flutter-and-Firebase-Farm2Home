import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../services/cloudinary_service.dart';

/// Widget for displaying a single optimized product image with Cloudinary transformations
class CloudinaryProductImage extends StatelessWidget {
  final String? imageUrl;
  final String? publicId;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String quality;
  final String format;
  final String crop;
  final bool showPlaceholder;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CloudinaryProductImage({
    super.key,
    this.imageUrl,
    this.publicId,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.quality = 'auto:good',
    this.format = 'auto',
    this.crop = 'fill',
    this.showPlaceholder = true,
    this.placeholder,
    this.errorWidget,
  });

  /// Create thumbnail version (square, small size)
  factory CloudinaryProductImage.thumbnail({
    String? imageUrl,
    String? publicId,
    int size = 150,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    return CloudinaryProductImage(
      imageUrl: imageUrl,
      publicId: publicId,
      width: size.toDouble(),
      height: size.toDouble(),
      fit: fit,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      quality: 'auto:low',
      crop: 'thumb',
    );
  }

  /// Create medium version (for product listings)
  factory CloudinaryProductImage.medium({
    String? imageUrl,
    String? publicId,
    double width = 400,
    double height = 300,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    return CloudinaryProductImage(
      imageUrl: imageUrl,
      publicId: publicId,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
  }

  /// Create large version (for product details)
  factory CloudinaryProductImage.large({
    String? imageUrl,
    String? publicId,
    double width = 800,
    double height = 600,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    return CloudinaryProductImage(
      imageUrl: imageUrl,
      publicId: publicId,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
    );
  }

  String _getOptimizedUrl() {
    if (publicId != null) {
      return CloudinaryService.instance.getOptimizedImageUrl(
        publicId!,
        width: width?.toInt(),
        height: height?.toInt(),
        quality: quality,
        format: format,
        crop: crop,
      );
    }
    return imageUrl ?? '';
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                size: (width != null && width! < 100) ? 24 : 48,
                color: Colors.grey.shade400,
              ),
              if (width == null || width! >= 100) ...[
                const SizedBox(height: 8),
                Text(
                  'No Image',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: (width != null && width! < 100) ? 24 : 48,
                color: Colors.red.shade400,
              ),
              if (width == null || width! >= 100) ...[
                const SizedBox(height: 8),
                Text(
                  'Load Error',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final url = _getOptimizedUrl();
    
    if (url.isEmpty) {
      return showPlaceholder ? _buildPlaceholder() : const SizedBox.shrink();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: borderRadius,
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Widget for displaying multiple product images in a carousel
class CloudinaryProductImageCarousel extends StatefulWidget {
  final ProductModel product;
  final double height;
  final bool showIndicators;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const CloudinaryProductImageCarousel({
    super.key,
    required this.product,
    this.height = 300,
    this.showIndicators = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<CloudinaryProductImageCarousel> createState() =>
      _CloudinaryProductImageCarouselState();
}

class _CloudinaryProductImageCarouselState
    extends State<CloudinaryProductImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    if (widget.autoPlay && widget.product.imageUrls.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayInterval, () {
      if (mounted && widget.product.imageUrls.isNotEmpty) {
        final nextIndex = (_currentIndex + 1) % widget.product.imageUrls.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.product.hasImages) {
      return CloudinaryProductImage.large(
        width: double.infinity,
        height: widget.height,
        borderRadius: BorderRadius.circular(16),
      );
    }

    final images = widget.product.imageUrls;
    final publicIds = widget.product.cloudinaryPublicIds;

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CloudinaryProductImage.large(
                imageUrl: images[index],
                publicId: index < publicIds.length ? publicIds[index] : null,
                width: double.infinity,
                height: widget.height,
                borderRadius: BorderRadius.circular(16),
              );
            },
          ),
        ),
        
        if (widget.showIndicators && images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              final isActive = entry.key == _currentIndex;
              return Container(
                width: isActive ? 12 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive 
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// Widget for displaying product images in a grid
class CloudinaryProductImageGrid extends StatelessWidget {
  final ProductModel product;
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;
  final VoidCallback? onImageTap;

  const CloudinaryProductImageGrid({
    super.key,
    required this.product,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
    this.spacing = 8,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!product.hasImages) {
      return CloudinaryProductImage.medium(
        width: double.infinity,
        height: 200,
        borderRadius: BorderRadius.circular(12),
      );
    }

    final images = product.imageUrls;
    final publicIds = product.cloudinaryPublicIds;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: onImageTap,
          child: CloudinaryProductImage.medium(
            imageUrl: images[index],
            publicId: index < publicIds.length ? publicIds[index] : null,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

/// Widget for displaying a single product image with fallback to placeholder
class CloudinaryProductThumbnail extends StatelessWidget {
  final ProductModel product;
  final double size;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const CloudinaryProductThumbnail({
    super.key,
    required this.product,
    this.size = 80,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget thumbnail = CloudinaryProductImage.thumbnail(
      imageUrl: product.primaryImageUrl,
      publicId: product.cloudinaryPublicIds.isNotEmpty 
          ? product.cloudinaryPublicIds.first 
          : null,
      size: size.toInt(),
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    );

    if (onTap != null) {
      thumbnail = GestureDetector(
        onTap: onTap,
        child: thumbnail,
      );
    }

    return thumbnail;
  }
}

/// Widget for full screen image viewer with pinch to zoom
class CloudinaryImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> publicIds;
  final int initialIndex;

  const CloudinaryImageViewer({
    super.key,
    required this.imageUrls,
    this.publicIds = const [],
    this.initialIndex = 0,
  });

  @override
  State<CloudinaryImageViewer> createState() => _CloudinaryImageViewerState();
}

class _CloudinaryImageViewerState extends State<CloudinaryImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.imageUrls.length}'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: CloudinaryProductImage.large(
                imageUrl: widget.imageUrls[index],
                publicId: index < widget.publicIds.length 
                    ? widget.publicIds[index] 
                    : null,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}