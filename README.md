# BookBuddy

BookBuddy is a Flutter app that show books from google apikey.


## Features

- Books with infinite scroll pagination
- Search books by title or author
- View book details including description, author, publish year, and page count
- Save and remove favorite books
- Favorites are stored locally (hive) and persist between sessions
- Pull to refresh the book list


## Tech Stack

- State Management: BLoC 
- Navigation: go_router
- HTTP Client: dio
- Local Storage: hive
- Dependency Injection: get_it
- Functional Error Handling: dartz
- Image Caching: cached_network_image


### Step 1: Get a Google Books API Key

1. Go to Google Cloud Console at https://console.cloud.google.com
2. Create a new project or select an existing one
3. Search for "Books API" and enable it
4. Go to Credentials, click Create Credentials, then select API key
5. Copy the key
Or
6. This is my book apikey for testing: AIzaSyAtDk8kMjrVtDBG3wPbAL4aMleU_zbfZ20

### Step 2: Add your API key

Copy the example secrets file and fill in your key:

```
lib/core/config/secrets.dart
class Secrets {
  static const booksApiKey = 'AIzaSyAtDk8kMjrVtDBG3wPbAL4aMleU_zbfZ20';
}
```

Open `lib/core/config/secrets.dart` and replace the placeholder with your actual key. This file is listed in `.gitignore` so it will never be accidentally committed.

### Step 3: Install dependencies and run

```
flutter pub get
flutter run
```

## Flavor Setup

This project uses `AppConfig` for environment configuration in lib/core/app_config.dart.

`AppConfig` is initialized once in `main()` before `runApp()`, holding the base URL, app name, flavor, and API key. All parts of the app read from `AppConfig.instance`.




<img width="1179" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-05-22 at 17 59 50" src="https://github.com/user-attachments/assets/753f23a2-09f1-4aa8-82c5-4349ff321d97" />
<img width="1179" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-05-22 at 18 00 07" src="https://github.com/user-attachments/assets/a5883a4b-4913-4f10-a6db-1095f7dae8f0" />
<img width="1179" height="2556" alt="Simulator Screenshot - iPhone 16 - 2026-05-22 at 18 04 21" src="https://github.com/user-attachments/assets/4c19d0ab-0028-489b-8496-5d8c3f42527b" />






