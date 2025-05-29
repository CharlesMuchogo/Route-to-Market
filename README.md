
---

````markdown
# 🛣️ Route-to-Market (RTM) Sales Force Automation App

A Flutter-based mobile application designed to streamline the sales force automation process for Route-to-Market operations. The app enables sales teams to effectively manage their customer visits, track orders, and enhance on-the-ground decision-making.

## 📱 Features

- 🔍 Customer and visit management with search & filters
- 📅 Track customer visits and order statuses
- ⬆️ Offline-first data with persistent storage via Hive and Hydrated BLoC
- 🌐 Network status awareness using `connectivity_plus`
- 📸 Cached images for optimized performance
- 📈 Reactive UI with Flutter BLoC state management
- 🧪 Comprehensive testing support with `bloc_test` and `mocktail`

---

## 🛠️ Built With

| Package               | Description                                  |
|----------------------|----------------------------------------------|
| `flutter_bloc`       | Business logic component for state handling  |
| `hydrated_bloc`      | Automatically persists BLoC state            |
| `dio`                | Powerful HTTP client                         |
| `hive_flutter`       | Lightweight key-value database                |
| `json_serializable`  | Code generation for JSON models              |
| `cached_network_image` | Efficient image caching                    |
| `connectivity_plus`  | Network status monitoring                    |
| `intl`               | Date and number formatting                   |

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### 🔧 Prerequisites

- Flutter SDK >= 3.7.2
- Dart >= 3.x
- Android Studio / VS Code
- Emulator or real device

### 📦 Installation

1. **Clone the repo**

```bash
git clone https://github.com/yourusername/route_to_market.git
cd route_to_market
````

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run code generation (for JSON models, etc.)**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**

```bash
flutter run
```

---

## 📂 Project Structure

```bash
lib/
├── data/               # Manages the data layer from local database and remote repository
    ├── remote          #Data from the internet
    ├── local           #Data from database
├── domain/             # JSON models with annotations
    ├── dto             #Data serialization to and from the internet
    ├── models          #Data Models such as Activities, visits and customers
├── presentation/       # UI screens and widgets           
├── utils/              # Helper methods and constants
└── main.dart           # Entry point
```

---

## 🧪 Running Tests

```bash
flutter test
```

---

## 🤝 Contributing

Contributions are welcome! Fork the repo and submit a pull request.

---

## 📄 License

This project is private and not licensed for redistribution at this time.

---

## 👤 Author

* Charles Muchogo

