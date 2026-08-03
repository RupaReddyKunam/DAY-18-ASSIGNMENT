import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.values.fold(0, (sum, i) => sum + i.quantity);

  double get totalAmount {
    return _items.values.fold(0.0, (sum, i) => sum + (i.product.price * i.quantity));
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
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
      create: (_) => CartProvider(),
      child: const MaterialApp(home: CatalogScreen()),
    ),
  );
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  final List<Product> catalog = const [
    Product(id: '1', name: 'Wireless Headphones', price: 99.99),
    Product(id: '2', name: 'Smart Watch Series 9', price: 299.50),
    Product(id: '3', name: 'Ergonomic Desk Chair', price: 149.00),
    Product(id: '4', name: 'Mechanical Keyboard', price: 79.99),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Store Catalog'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.itemCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: catalog.length,
        itemBuilder: (context, idx) {
          final p = catalog[idx];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  context.read<CartProvider>().addItem(p);
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping Cart'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty 🛒'))
                : ListView(
                    children: cart.items.values.map((item) {
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text('\$${item.product.price} x ${item.quantity} = \$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => context.read<CartProvider>().removeSingleItem(item.product.id),
                            ),
                            Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () => context.read<CartProvider>().addItem(item.product),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
                ElevatedButton(
                  onPressed: cart.items.isNotEmpty ? () => context.read<CartProvider>().clearCart() : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
