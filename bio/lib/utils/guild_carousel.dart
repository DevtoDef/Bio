import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GuideCarousel extends StatefulWidget {
  const GuideCarousel({
    super.key,
    required this.images,
    this.borderRadius = 12,
  });

  /// Có thể là asset (bắt đầu bằng 'assets/') hoặc url network.
  final List<String> images;
  final double borderRadius;

  @override
  State<GuideCarousel> createState() => _GuideCarouselState();
}

class _GuideCarouselState extends State<GuideCarousel> {
  final PageController _pc = PageController(viewportFraction: .92);
  int _index = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Auto fit chiều cao theo bề ngang để “gọn” trong dải xanh
    final screenW = MediaQuery.of(context).size.width;
    final contentW = min(screenW - 32, 640); // khớp maxWidth khi chạy web
    final height = min(220.0, contentW * 0.55); // tỉ lệ ~2.2:1

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pc,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final src = widget.images[i];
              final isAsset = src.startsWith('assets/');
              final image =
                  isAsset
                      ? Image.asset(src, fit: BoxFit.cover)
                      : Image.network(src, fit: BoxFit.cover);

              return GestureDetector(
                onTap: () => _openGallery(context, initialIndex: i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      image,
                      // nhẹ nhàng caption góc dưới
                      Positioned(
                        left: 75,
                        right: 75,
                        bottom: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Hướng dẫn ${i + 1}/${widget.images.length} · chạm để phóng to',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: active ? 18 : 6,
              decoration: BoxDecoration(
                color: active ? Colors.purple : Colors.purple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _openGallery(BuildContext context, {required int initialIndex}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder:
            (_, __, ___) => FullscreenGallery(
              images: widget.images,
              initialIndex: initialIndex,
            ),
        transitionsBuilder:
            (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
      ),
    );
  }
}

class FullscreenGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  const FullscreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initialIndex);
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.95),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: controller,
            itemCount: images.length,
            builder: (context, i) {
              final src = images[i];
              final isAsset = src.startsWith('assets/');
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    isAsset
                        ? AssetImage(src)
                        : NetworkImage(src) as ImageProvider,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
              );
            },
            loadingBuilder:
                (context, event) =>
                    const Center(child: CircularProgressIndicator()),
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: padding.top + 8,
            right: 12,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
