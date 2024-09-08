import 'package:flutter/material.dart';
import 'package:webmobril_test/src/screen/datail_view/datail_view.dart';
import 'package:webmobril_test/src/screen/home/model/product_model.dart';
import 'package:webmobril_test/src/screen/home/provider/homo_provider.dart';

class SimpleProductCard extends StatelessWidget {
  final Product product;
  final HomeProvider homeProvider;

  const SimpleProductCard(
      {super.key, required this.product, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    // final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Product Title
            Text(
              product.title!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Flexible(
              child: Text(
                product.description!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
              ),
            ),
            const SizedBox(height: 6),

            // Product Price and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '\$${product.price!}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Text(product.rating!.rate.toString()),
                Text(" (${product.rating!.count.toString()})"),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    homeProvider.decreaseQuantity(product);

                    // homeProvider.addToCart(product);
                  },
                  child: const CircleAvatar(
                    child: Icon(Icons.remove_circle_outline_outlined,
                        color: Colors.red),
                  ),
                ),
                // Display Current Quantity
                Text(product.quantity.toString()),

                InkWell(
                  onTap: () {
                    // homeProvider.increaseQuantity(product);
                    homeProvider.addToCart(product);
                  },
                  child: const CircleAvatar(
                    child: Icon(Icons.add_circle_outline, color: Colors.red),
                    // child: Text(
                    //   "+",
                    //   style: TextStyle(
                    //     color: Colors.red,
                    //     fontSize: 24,
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
