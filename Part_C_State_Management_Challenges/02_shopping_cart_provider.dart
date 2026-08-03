import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge 2: Build a shopping cart (add/remove items, total calculation) with Provider.

class CartItem {
  final String id;
  final String title;
  final double price;

  CartItem({required this.id, required this.title, required this.price});
}

class ShoppingCartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.price);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingCartModel(),
      child: const MaterialApp(home: ShoppingCartApp()),
    ),
  );
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  final List<CartItem> availableProducts = const [
    CartItem(id: 'p1', title: 'Flutter Course', price: 49.99),
    CartItem(id: 'p2', title: 'Dart Programming Handbook', price: 29.99),
    CartItem(id: 'p3', title: 'UI/UX Design Kit', price: 19.99),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<ShoppingCartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge 2: Shopping Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Badge(
                label: Text('${cart.itemCount}'),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Available Catalog:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: availableProducts.length,
              itemBuilder: (context, index) {
                final product = availableProducts[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<ShoppingCartModel>().addItem(product);
                    },
                    child: const Text('Add to Cart'),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                ElevatedButton(
                  onPressed: cart.itemCount > 0 ? () => context.read<ShoppingCartModel>().clearCart() : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: const Text('Clear Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
