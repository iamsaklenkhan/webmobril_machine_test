import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmobril_test/src/screen/home/model/product_model.dart';
import 'package:webmobril_test/src/screen/home/provider/homo_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: cartProvider.cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: _buildCartList(cartProvider),
                ),
                _buildTotalPrice(cartProvider),
              ],
            ),
    );
  }

  Widget _buildCartList(HomeProvider cartProvider) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 20,
        thickness: 1.5,
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: cartProvider.cart.length,
      itemBuilder: (context, index) {
        final product = cartProvider.cart[index];
        return _buildCartItem(cartProvider, product);
      },
    );
  }

  Widget _buildCartItem(HomeProvider cartProvider, Product product) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductHeader(product),
          _buildProductDetails(cartProvider, product),
          _buildProductActions(cartProvider, product),
        ],
      ),
    );
  }

  Widget _buildProductHeader(Product product) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            product.image!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            product.title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails(HomeProvider cartProvider, Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price: \$${product.price}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Subtotal: \$${cartProvider.getSubtotal(product)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductActions(HomeProvider cartProvider, Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () {
                final newQuantity = product.quantity! - 1;
                if (newQuantity == 0) {
                  cartProvider.removeFromCart(product);
                } else {
                  cartProvider.updateCartQuantity(product, newQuantity);
                }
              },
            ),
            Text(
              '${product.quantity}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              onPressed: () {
                cartProvider.updateCartQuantity(product, product.quantity! + 1);
              },
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: () {
            cartProvider.removeFromCart(product);
          },
        ),
      ],
    );
  }

  Widget _buildTotalPrice(HomeProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Total:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
