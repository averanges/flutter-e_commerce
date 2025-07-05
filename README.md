E_commerce is a Flutter application that implements a clean architecture with a modular structure. It uses GetX for state management and navigation, Dio for HTTP requests, and GetStorage for local storage. The app also includes features such as user authentication, product catalog, and shopping cart.


📁 lib  
├── 📄 app.dart                      # Entry point of the Flutter app  
├── 📁 bindings                     # Dependency injection (GetX)  
├── 📁 common                       # Reusable UI elements  
│   ├── 📁 styles                   # Colors, sizes  
│   ├── 📁 themes                   # App theming (AppBar, buttons, text…)  
│   └── 📁 widgets                  # Shared widgets  
├── 📁 data                         # Data layer  
│   ├── 📁 models                   # Data models (user, cargo, flight…)  
│   ├── 📁 repositories             # Business logic & data handling  
│   └── 📁 sources  
│       ├── 📁 api                  # Remote API services  
│       └── 📁 local                # Local storage and cache  
├── 📁 features                     # Modular app features  
│   ├── 📁 auth                     # Login, register, password reset  
│   ├── 📁 buyer                    # Buyer-specific logic and UI  
│   ├── 📁 seller                   # Seller dashboard, cargo management  
│   ├── 📁 admin                    # Admin panel and user management  
│   ├── 📁 home                     # Home screen  
│   ├── 📁 profile                  # User profile  
│   ├── 📁 cart                     # Shopping cart  
│   ├── 📁 favorites                # Wishlist / Favorites  
│   └── 📁 notifications, orders, etc. # Other core features  
├── 📁 localizations                # Multilanguage (JSON + service)  
├── 📁 utils                        # Helpers, constants, validators, loggers  



✨ Features

        Main technologies and structure used in the project:

        Modular Clean Architecture
        Each feature is separated into modules (auth, buyer, seller, etc.) with clear layer separation (data, domain, presentation).

        State Management & DI
        Uses GetX for dependency injection, state management, and routing.

        Navigation
        Simplified and reactive navigation with GetX.

        HTTP Requests
        Powered by Dio with support for interceptors and flexible configuration.

        Local Storage

        get_storage for lightweight persistence.

        flutter_map_tile_caching for offline map support.

        Media & Permissions

        image_picker for image upload.

        location and permission_handler for geolocation and permissions.

        UI Components & Effects
        Modern UI using carousel_slider, smooth_page_indicator, motion_tab_bar, badges, etc.

        Logging
        Integrated with logger for debugging.

        Localization
        Custom JSON-based i18n with localization_service.dart.

        Splash Screen
        Configured via flutter_native_splash.