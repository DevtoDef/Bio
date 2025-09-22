// Widget representing a single product card in the grid
import 'package:bio/Product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ảnh
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Mã: ${product.productId}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Đẩy thanh nút xuống sát đáy
            const Spacer(),

            // Thanh nút dưới cùng
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 1, color: Colors.black12), // viền trên mảnh
                Row(
                  children: [
                    // TikTok (nửa trái)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // TODO: mở link TikTok của sản phẩm
                          // ví dụ: launchUrlString(product.tiktokUrl ?? product.link);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              FaIcon(FontAwesomeIcons.tiktok, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'TikTok',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // vạch chia
                    Container(width: 1, height: 28, color: Colors.black12),

                    // Shopee (nửa phải)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // TODO: mở link Shopee của sản phẩm
                          // ví dụ: launchUrlString(product.shopeeUrl ?? product.link);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Dùng asset logo Shopee (khuyến nghị)
                              Image.asset(
                                'assets/images/shopee-logo.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Shopee',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
