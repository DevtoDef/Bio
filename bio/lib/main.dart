import 'package:bio/Product.dart';
import 'package:bio/product_card.dart';
import 'package:bio/utils/guild_carousel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Entry point of the Flutter application. This file defines a simple
// interface that follows the structure discussed in the design report.
// The layout includes a hero section with a header image, avatar, user
// information and social links, followed by a search bar, category
// filters and a grid of product cards. The data is currently hard‑coded
// for demonstration purposes and can be replaced with network requests
// or a local database.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bio Link Reviewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'PatrickHand'),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // List of categories for filtering. The 'All' category shows all products.
  final List<String> categories = ['All', 'Công nghệ', 'Gia dụng', 'Decor'];
  String selectedCategory = 'All';

  // List of Guild Images
  final List<String> guideImages = [
    // Dùng ảnh mẫu trước; bạn thay bằng ảnh hướng dẫn thật (asset/network)
    'assets/images/guide_0.png',
    'assets/images/guide_1.png',
    'assets/images/guide_2.png',
  ];
  final TextEditingController _searchController = TextEditingController();

  // Sample data representing products. In a real application, this data
  // should come from an API or database.
  final List<Product> _allProducts = [
    Product(
      name: 'Loa bluetooth mini',
      category: 'Công nghệ',
      productId: '123456789',
      images: [
        'https://down-vn.img.susercontent.com/file/aa34621e021e095e94167ec8439d7656.webp',
        'https://down-vn.img.susercontent.com/file/aa34621e021e095e94167ec8439d7656.webp',
      ],
      link: '#',
    ),
    Product(
      name: 'Máy sấy quần áo',
      category: 'Gia dụng',
      productId: '12345678910',
      images: [
        'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2vs8k8c05psdb.webp',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2vs8k8c05psdb.webp',
      ],
      link: '#',
    ),
    Product(
      name: 'Đèn decor bàn làm việc',
      category: 'Decor',
      productId: '12345678',
      images: [
        'https://picsum.photos/seed/decor1/400/400',
        'https://picsum.photos/seed/decor2/400/400',
      ],
      link: '#',
    ),
    Product(
      name: 'Tai nghe không dây',
      category: 'Công nghệ',
      productId: '1234567',
      images: [
        'https://picsum.photos/seed/tech3/400/400',
        'https://picsum.photos/seed/tech4/400/400',
      ],
      link: '#',
    ),
    Product(
      name:
          'Máy pha cà phê acb xyz size cái qquanf quèasdasdadmfnsapodflsdjsgvoishdfgoksdjf',
      category: 'Gia dụng',
      productId: '123456',
      images: [
        'https://picsum.photos/seed/home3/400/400',
        'https://picsum.photos/seed/home4/400/400',
      ],
      link: '#',
    ),
    Product(
      name: 'Cây đèn ngủ',
      category: 'Decor',
      productId: '12345',
      images: [
        'https://picsum.photos/seed/decor3/400/400',
        'https://picsum.photos/seed/decor4/400/400',
      ],
      link: '#',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter products based on selected category and search query
    final query = _searchController.text.toLowerCase();
    final Map<String, int> categoryCounts = {
      for (final category in categories)
        category:
            _allProducts.where((product) {
              final matchesSearch = product.name.toLowerCase().contains(query);
              final matchesCategory =
                  category == 'All' || product.category == category;
              return matchesSearch && matchesCategory;
            }).length,
    };
    final List<Product> filtered =
        _allProducts.where((product) {
          final matchesCategory =
              selectedCategory == 'All' || product.category == selectedCategory;
          final matchesSearch = product.name.toLowerCase().contains(query);
          return matchesCategory && matchesSearch;
        }).toList();

    final Iterable<String> displayedCategories =
        selectedCategory == 'All'
            ? categories.where((category) => category != 'All')
            : [selectedCategory];

    final List<Widget> productSections = [];
    for (final category in displayedCategories) {
      final List<Product> categoryProducts =
          filtered.where((product) => product.category == category).toList();
      if (categoryProducts.isEmpty) {
        continue;
      }

      // Thêm khoảng cách trước tiêu đề (trừ category đầu tiên)
      if (productSections.isNotEmpty) {
        productSections.add(const SizedBox(height: 24));
      }

      // Tiêu đề category
      productSections.add(
        Text(
          '${category} (${categoryProducts.length})',
          style: const TextStyle(fontFamily: 'PatrickHand', fontSize: 18),
        ),
      );

      // Grid sản phẩm với padding zero để sát với tiêu đề
      productSections.add(
        Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.only(top: 8.0),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.625,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              final product = categoryProducts[index];
              return ProductCard(product: product);
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero section using SliverAppBar for collapsible effect
          SliverAppBar(
            expandedHeight: 260.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 226, 145, 197),
                          Color.fromARGB(255, 237, 230, 233),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/seed/avatar/200/200',
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Review Chất',
                          style: TextStyle(
                            fontFamily: 'PatrickHand',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Review công nghệ, gia dụng và decor',
                          style: TextStyle(
                            fontFamily: 'PatrickHand',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                print('Facebook tapped');
                              },
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 18,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                print('Instagram tapped');
                              },
                              child: FaIcon(
                                FontAwesomeIcons.instagram,
                                size: 18,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                print('TikTok tapped');
                              },
                              child: FaIcon(
                                FontAwesomeIcons.tiktok,
                                size: 18,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                print('YouTube tapped');
                              },
                              child: FaIcon(
                                FontAwesomeIcons.youtube,
                                size: 18,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guide images
                  GuideCarousel(images: guideImages),
                  const SizedBox(height: 12),
                  Text(
                    'Sản phẩm trong video đều ở bên dưới!👇',
                    style: TextStyle(fontFamily: 'PatrickHand', fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Tìm kiếm sản phẩm...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  // Category filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          categories.map((cat) {
                            final bool isSelected = selectedCategory == cat;
                            final int count = categoryCounts[cat] ?? 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ChoiceChip(
                                labelPadding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 12.0,
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      cat,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      ' ($count)',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product grid with gradient background
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 246, 220, 240),
                    Color.fromARGB(255, 248, 233, 244),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Thay đổi từ symmetric horizontal sang all để có padding đều
                child:
                    productSections.isEmpty
                        ? const Center(
                          child: Text(
                            'Không tìm thấy sản phẩm phù hợp',
                            style: TextStyle(
                              fontFamily: 'PatrickHand',
                              fontSize: 16,
                            ),
                          ),
                        )
                        : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productSections,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
