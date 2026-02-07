
<img width="2400" height="1792" alt="Gemini_Generated_Image_3a7tcs3a7tcs3a7t" src="https://github.com/user-attachments/assets/ece4a69c-5f3e-4a99-9a22-42574cee77f2" />

####🏥 ClinExa Mobile App 

ClinExa is a comprehensive telemedicine and clinic management mobile application built with Flutter. It is designed to streamline the interaction between patients and healthcare providers, offering a seamless experience for booking appointments, managing prescriptions, and receiving real-time updates.

This application follows **Clean Architecture** principles to ensure scalability, testability, and maintainability, leveraging **BLoC/Cubit** for robust state management.

## 🚀 Features

### 🔐 Authentication & Security
- **Secure Login & Registration**: User-friendly authentication flow with email and password.
- **Password Recovery**: OTP-based password reset functionality securely handled via email.
- **Session Management**: Persistent login sessions using secure storage (`flutter_secure_storage`).
- **Logout Functionality**: Securely clears user session and navigates to the login screen.

### 📅 Appointment Management
- **Smart Booking System**: Book appointments with specific doctors by selecting available dates and times.
- **Status Tracking**: Real-time status updates (Pending, Confirmed, Completed, Cancelled).
- **Rescheduling**: Flexible rescheduling options with instant confirmation.
- **Cancellation**: Users can cancel appointments with valid reasons.
- **Appointment History**: Separate tabs for Upcoming and Past appointments for easy tracking.

### 💊 Prescription & Medical Records
- **Digital Prescriptions**: View detailed prescriptions directly within the app.
- **Medicine Details**: Clear display of medicine names, dosages, durations, and specific instructions.
- **PDF Generation**: Generate and download professional PDF versions of prescriptions (`pdf`, `printing`) for sharing or printing.
- **Doctor's Notes**: Access notes and instructions provided by the doctor for each visit.

### 🔔 Notifications & Real-time Updates
- **Push Notifications**: Integrated with Firebase Cloud Messaging (FCM) for critical alerts.
- **Real-time Synchronization**: Uses **Firebase Realtime Database** to instantly update appointment statuses and dashboard data without manual refresh.
- **In-App Notifications**: dedicated notifications screen to view history of alerts.

### 👤 User Profile
- **Profile Management**: Update personal details including Name, Age, Gender, Phone Number, and Address.
- **Health Information**: Store and manage essential patient data.

### 🌍 Localization & Accessibility
- **Multi-language Support**: Fully localized for **English** and **Arabic** (RTL support included).
- **Responsive Design**: UI adapts to various screen sizes using `flutter_screenutil`.
- **User-Friendly UI**: Implements Shimmer loading effects, Toast notifications, and intuitive navigation.

## 🏗️ Architecture

The project is structured using **Clean Architecture** to separate concerns and improve code quality.

### Layers
1.  **Domain Layer**:
    *   **Entities**: Core business objects.
    *   **Repositories (Interfaces)**: Abstract definitions of data operations.
    *   **Use Cases**: Specific business logic encapsulating single tasks.

2.  **Data Layer**:
    *   **Models**: Data transfer objects (DTOs) with JSON serialization (`json_serializable`).
    *   **Data Sources**:
        *   *Remote*: API calls using **Dio**.
        *   *Local*: Caching with **Shared Preferences** and Secure Storage.
    *   **Repositories (Implementations)**: Concrete implementations of domain interfaces.

3.  **Presentation Layer**:
    *   **State Management**: Uses **Flutter BLoC (Cubit)** pattern for predictable state changes.
    *   **Widgets**: Reusable UI components.
    *   **Pages**: Screen layouts.

### Folder Structure
```text
lib/
├── app/                  # Application configuration
│   ├── router/           # GoRouter configuration
│   ├── theme/            # App theme and styles
│   └── screens/          # Shared/Global screens
├── core/                 # Core functionality
│   ├── config/           # Environment and Firebase config
│   ├── di/               # Dependency Injection (GetIt)
│   ├── error/            # Error handling and failures
│   ├── network/          # Dio client and interceptors
│   ├── services/         # External services (PDF, Notification)
│   └── utils/            # Constants, extensions, and helpers
├── features/             # Feature-based modules
│   ├── auth/             # Authentication (Login, Register, Forgot Password)
│   ├── appointments/     # Booking, Listing, Details
│   ├── prescriptions/    # Prescription lists and details
│   ├── profile/          # User profile management
│   ├── home/             # Dashboard and main landing
│   ├── notifications/    # Notification logic and UI
│   └── doctors/          # Doctor listing and details
└── main.dart             # Application entry point
```

## 🛠️ Technology Stack

| Category | Package/Technology |
|----------|-------------------|
| **Framework** | Flutter, Dart |
| **State Management** | `flutter_bloc`, `bloc`, `equatable` |
| **Dependency Injection** | `get_it` |
| **Navigation** | `go_router` |
| **Networking** | `dio`, `pretty_dio_logger`, `dio_smart_retry` |
| **Local Storage** | `shared_preferences`, `flutter_secure_storage` |
| **Real-time & DB** | Firebase Realtime Database, Firebase Core |
| **Notifications** | Firebase Messaging, `flutter_local_notifications` |
| **UI Components** | `flutter_screenutil`, `shimmer`, `flutter_spinkit`, `google_fonts`, `iconsax` |
| **Utilities** | `intl`, `logger`, `form_field_validator`, `dartz` |
| **PDF & Printing** | `pdf`, `printing`, `path_provider`, `open_file_plus` |
| **Environment** | `flutter_dotenv` |
| **Code Generation** | `build_runner`, `json_serializable` |

## 📦 Getting Started

### Prerequisites
- Flutter SDK (>=3.4.3 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Firebase Project Setup (if running with your own backend)

### Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/your-repo/clinexa-mobile.git
    cd clinexa-mobile
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Environment Setup**
    Ensure you have the environment files set up in `assets/env/`:
    *   `assets/env/.env.dev`
    *   `assets/env/.env.prod`

4.  **Run the Application**
    ```bash
    # Run in debug mode
    flutter run

    # Run in release mode
    flutter run --release
    ```

## 🤝 Contribution

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

---

**Developed for ClinExa Healthcare Solutions.**
