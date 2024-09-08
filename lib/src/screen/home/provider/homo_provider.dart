import 'package:flutter/material.dart';
import 'package:webmobril_test/src/api_service/api_service.dart';

import '../model/product_model.dart';

class HomeProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _products = [];
  List<Product> cart = [];
  bool _isLoading = false;

  String seletCategory = "All";
  String _error = '';

  List<Product> get products => _products; // Get the filtered products
  bool get isLoading => _isLoading;
  String get error => _error;

  int _pageSize = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  ApiService api = ApiService("https://fakestoreapi.com");

  ///
  Future<void> fetchProducts({bool isRefresh = false}) async {
    _isLoading = true;

    if (isRefresh) {
      _products.clear();
      _hasMore = true;
      _pageSize = 10;
    }

    try {
      final fetchedProducts = await api.fetchProducts();
      if (fetchedProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(fetchedProducts);

        _allProducts = _products;
        _error = '';
        // if (fetchedProducts.length >= _pageSize) {
        //   _pageSize += 10;
        // } else {
        //   _pageSize = 20;
        // }
      }
    } catch (e) {
      _error = 'Failed to fetch products';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///

  void searchProducts(String query) {
    if (query.isEmpty) {
      _products =
          _allProducts; // If the search query is empty, show all products
    } else {
      _products = _allProducts.where((product) {
        final titleLower = product.title!.toLowerCase();
        final descriptionLower = product.description!.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }

  void filterByCategory(String category) {
    if (category.isEmpty || category == 'All') {
      seletCategory = "All";
      _products = _allProducts; // If category is 'All', reset to all products
    } else {
      seletCategory = category;
      _products = _allProducts
          .where((product) => product.category == category)
          .toList();
    }
    notifyListeners(); // Notify the UI to update
  }

  List<String> categoryList = [
    "men's clothing",
    "jewelery",
    "electronics",
    "women's clothing",
  ];

  void addToCart(Product product) {
    final existingProduct = cart.firstWhere((item) => item.id == product.id,
        orElse: () => Product(id: -1, title: '', price: 0.0)); // Fallback
    if (existingProduct.id != -1) {
      // If product already exists in the cart, increase quantity
      existingProduct.quantity = (existingProduct.quantity ?? 1) + 1;
    } else {
      // If product does not exist, set quantity and add it to cart
      product.quantity = 1;
      cart.add(product);
    }
    notifyListeners();
  }

  void addToCart1(Product product, int quantity) {
    final existingProduct = cart.firstWhere(
      (item) => item.id == product.id,
      orElse: () => Product(id: -1, title: '', price: 0.0),
    );
    if (existingProduct.id != -1) {
      // Update quantity if the product is already in the cart
      // existingProduct.quantity = (existingProduct.quantity ?? 1) + quantity;
    } else {
      // If product is not in the cart, add with initial quantity
      product.quantity = quantity;
      cart.add(product);
    }
    notifyListeners();
  }

  void updateCartQuantity(Product product, int quantity) {
    if (quantity >= 0) {
      product.quantity = quantity;
    } else {
      cart.remove(product);
    }
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    print("===========sss===>${product.id}");
    product.quantity = (product.quantity ?? 1) + 1;
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    print("=========sss===========>${product.id}");
    final data = product.quantity! - 1;
    if (data == 0) {
      removeFromCart(product);
    } else if (product.quantity != null && product.quantity! >= 1) {
      product.quantity = data;
      // addToCart(product);
    }
    notifyListeners();
  }

  double getTotalPrice() {
    return cart.fold(
        0, (total, product) => total + (product.price! * product.quantity!));
  }

  double getSubtotal(Product product) {
    return product.price! * product.quantity!;
  }

  void removeFromCart(Product product) {
    cart.remove(product);
    product.quantity = 0;
    notifyListeners();
  }
}
