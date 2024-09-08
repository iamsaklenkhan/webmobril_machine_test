import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmobril_test/src/screen/cart/cart_screen.dart';
import 'package:webmobril_test/src/screen/home/home_card/card_view.dart';
import 'package:webmobril_test/src/screen/home/provider/homo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider productProvider;

  @override
  void initState() {
    productProvider = Provider.of<HomeProvider>(context, listen: false);
    productProvider.fetchProducts();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected : ${value.seletCategory.split(" ")[0]}',
                  // You can dynamically update this to show the selected category
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  // icon: const Icon(Icons.menu), // Show category icon
                  onSelected: (String category) {
                    value.filterByCategory(category); // Trigger category filter
                  },
                  itemBuilder: (BuildContext context) {
                    return ['All', ...value.categoryList]
                        .map((String category) {
                      return PopupMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            InkWell(
              child: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            const SizedBox(width: 10),
            // InkWell(
            //   child: const Padding(
            //     padding: EdgeInsets.all(5.0),
            //     child: Text("Logout"),
            //   ),
            //   onTap: () {
            //     final auth =
            //         Provider.of<AuthenticationService>(context, listen: false);
            //
            //     auth.signOut();
            //
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => LoginScreen()));
            //   },
            // ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search products',
                  hintText: 'Enter product name or description',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  productProvider.searchProducts(value);
                },
              ),
            ),
            Expanded(
              child: productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : productProvider.error.isNotEmpty
                      ? Text(productProvider.error)
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 10 / 20.2),
                          itemCount: productProvider.products.length,
                          itemBuilder: (context, index) {
                            final product = productProvider.products[index];

                            return SimpleProductCard(
                              product: product,
                              homeProvider: productProvider,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
