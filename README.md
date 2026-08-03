# Day 18 Assignment — Flutter State Management

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-teal.svg)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/Provider-6.1.1-purple.svg)](https://pub.dev/packages/provider)

This repository contains the complete assignment solutions for **Day 18: Flutter State Management**, featuring core theory concepts, practical `setState` & `Provider` implementations, advanced state challenges, 5 full Flutter mini-projects, and technical research reports.

---

## 📂 Repository Structure

```text
DAY-18-ASSIGNMENT/
├── Part_A_Theory.md                          # 10 Theory questions with in-depth explanations
├── Part_B_Practical_Exercises/              # 5 Flutter state management code modules
│   ├── 01_setstate_counter.dart
│   ├── 02_text_controller_form.dart
│   ├── 03_provider_counter.dart
│   ├── 04_multi_screen_provider.dart
│   └── 05_dynamic_list_provider.dart
├── Part_C_State_Management_Challenges/     # 5 State management challenges
│   ├── 01_dark_mode_toggle.dart
│   ├── 02_shopping_cart_provider.dart
│   ├── 03_lifting_state_siblings.dart
│   ├── 04_multi_field_validated_form.dart
│   └── 05_consumer_child_selector_optimization.dart
├── Part_D_Provider_Challenges/               # 5 Advanced Provider challenges
│   ├── 01_user_model_auth.dart
│   ├── 02_theme_model_provider.dart
│   ├── 03_multi_provider_app.dart
│   ├── 04_provider_crud_list.dart
│   └── 05_provider_search_filter_list.dart
├── Part_E_Mini_Projects/                     # 5 Complete Flutter Applications
│   ├── 01_student_management_app/            # Student Management App with course filters & search
│   ├── 02_todo_app/                          # To-Do App with Provider state
│   ├── 03_notes_app/                         # Multi-screen Notes App with CRUD & search
│   ├── 04_contacts_app/                      # Contacts App with shared state across screens
│   └── 05_shopping_cart_app/                 # Shopping Cart App with products, cart & total
├── Part_F_Research_Activities.md             # In-depth research reports on Riverpod, BLoC, DevTools, Firebase & Selector
└── README.md                                 # Main repository documentation
```

---

## 🌟 Assignment Highlights

### 1. Part A — Theory Questions ([Part_A_Theory.md](file:///C:/Users/kunam/.gemini/antigravity-ide/scratch/DAY-18-ASSIGNMENT/Part_A_Theory.md))
Contains comprehensive technical answers for:
- Concept of state and the UI state cycle (`UI = f(State)`)
- Ephemeral (Local) vs Shared vs Global state
- `StatelessWidget` vs `StatefulWidget` comparison
- `setState()` rebuild mechanics and dirty element marking
- `initState()` and `dispose()` lifecycle hooks & controller leak risks
- Prop drilling and lifting state up
- `Provider`, `ChangeNotifier`, `Consumer`, and `notifyListeners()`
- Decision criteria for choosing `setState` vs `Provider`

### 2. Part B — Practical Exercises ([Part_B_Practical_Exercises/](file:///C:/Users/kunam/.gemini/antigravity-ide/scratch/DAY-18-ASSIGNMENT/Part_B_Practical_Exercises))
- **Counter App (`setState`):** Local state counter with increment, decrement, and reset.
- **Form with Controller:** `TextEditingController` initialization and proper disposal in `dispose()`.
- **Counter App (`Provider`):** Decoupled business logic using `ChangeNotifier` and `Consumer`.
- **Multi-Screen State:** Shared state model across two navigation screens.
- **Dynamic List:** Add and remove items dynamically with Provider.

### 3. Part C — State Management Challenges ([Part_C_State_Management_Challenges/](file:///C:/Users/kunam/.gemini/antigravity-ide/scratch/DAY-18-ASSIGNMENT/Part_C_State_Management_Challenges))
- **Dark Mode Toggle:** Side-by-side comparison of local `setState` vs app-wide `Provider` theme toggles.
- **Shopping Cart:** Cart state management with item counts and total price calculation.
- **Lifting State Up:** Sharing state between sibling widgets via parent callback functions.
- **Multi-Field Form Validation:** Validation using `GlobalKey<FormState>`.
- **Performance Optimization:** Optimized `Consumer` using `child` parameter and `Selector` filtering.

### 4. Part D — Provider Challenges ([Part_D_Provider_Challenges/](file:///C:/Users/kunam/.gemini/antigravity-ide/scratch/DAY-18-ASSIGNMENT/Part_D_Provider_Challenges))
- **UserModel Auth:** App-wide login/logout authentication state.
- **ThemeModel Switcher:** `ThemeMode.system`, `ThemeMode.light`, and `ThemeMode.dark` toggling.
- **MultiProvider:** Combining multiple `ChangeNotifier` models at the root.
- **Provider CRUD List:** Full item creation, updating, and deletion via Provider.
- **Live Search & Filter:** Real-time search query and category filter on Provider lists.

### 5. Part E — Mini Projects ([Part_E_Mini_Projects/](file:///C:/Users/kunam/.gemini/antigravity-ide/scratch/DAY-18-ASSIGNMENT/Part_E_Mini_Projects))
Each mini project is a complete Flutter app with `pubspec.yaml` and `lib/main.dart`:
1. 🎓 **Student Management App:** Full student CRUD, roll number search, course chips, and grade tracking.
2. 📝 **To-Do App:** Task completion check, add/delete tasks, progress indicators.
3. 📓 **Notes App:** Multi-screen navigation, note grid, pin toggle, tag search, and editing.
4. 🎴 **Contacts App:** Contact cards, details screen navigation, shared state updates.
5. 🛍️ **Shopping Cart App:** Product catalog screen, badge counts, cart view with quantity increment/decrement, and total price calculation.

### 6. Part F — Research Activities ([Part_F_Research_Activities.md](file:///C:/Users/kunam/.gemini/antigravity-ide/scratch/DAY-18-ASSIGNMENT/Part_F_Research_Activities.md))
In-depth technical research reports on:
1. **Riverpod:** Compile-time safety and improvements over Provider.
2. **BLoC Pattern:** Event/State stream architecture.
3. **Flutter DevTools:** Widget Inspector and Performance Profiler.
4. **Firebase for Flutter:** Preview of Auth, Firestore, and Push Notifications.
5. **Selector Widget:** Rebuild optimization mechanics.

---

## 👤 Author
**Rupa Reddy Kunam**  
GitHub: [https://github.com/RupaReddyKunam/DAY-18-ASSIGNMENT](https://github.com/RupaReddyKunam/DAY-18-ASSIGNMENT)
