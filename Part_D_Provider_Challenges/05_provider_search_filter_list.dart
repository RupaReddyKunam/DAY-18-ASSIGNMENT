import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge D5: Add a search/filter to a Provider-managed list.

class ProductItem {
  final String name;
  final String category;

  ProductItem(this.name, this.category);
}

class SearchFilterModel extends ChangeNotifier {
  final List<ProductItem> _allProducts = [
    ProductItem('MacBook Pro', 'Electronics'),
    ProductItem('iPhone 15', 'Electronics'),
    ProductItem('Office Chair', 'Furniture'),
    ProductItem('Coffee Table', 'Furniture'),
    ProductItem('Flutter Cookbook', 'Books'),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'ALL';

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<ProductItem> get filteredProducts {
    return _allProducts.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'ALL' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SearchFilterModel(),
      child: const MaterialApp(home: SearchFilterScreen()),
    ),
  );
}

class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SearchFilterModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('D5: Live Search & Category Filter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: '🔍 Search product name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<SearchFilterModel>().setSearchQuery(val),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['ALL', 'Electronics', 'Furniture', 'Books'].map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: model.selectedCategory == cat,
                    onSelected: (_) => context.read<SearchFilterModel>().setCategory(cat),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: model.filteredProducts.length,
                itemBuilder: (context, idx) {
                  final p = model.filteredProducts[idx];
                  return Card(
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(p.category),
                    ),
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
