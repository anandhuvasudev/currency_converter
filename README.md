# Currency Converter App

 
*(Replace this with a real screenshot of your app! I've added a placeholder.)*

A simple, elegant, and functional currency converter built with Flutter. This app provides real-time exchange rates and a user-friendly interface for quick and easy currency conversions.

## ✨ Features

-   **Real-time Conversion:** Fetches the latest exchange rates from a reliable API.
-   **Modern UI:** A clean, dark-themed, and intuitive user interface built with Material Design.
-   **Wide Currency Selection:** Supports a comprehensive list of world currencies.
-   **Easy Identification:** Displays currency codes, full names, and country flag emojis.
-   **Quick Swap:** Instantly swap the "From" and "To" currencies with a single tap.
-   **User Feedback:** Includes loading indicators for network operations and clear error messages.
-   **Input Validation:** Ensures that the user enters a valid amount before conversion.

## 🛠️ Tech Stack & Dependencies

-   **Framework:** [Flutter](https://flutter.dev/)
-   **Language:** [Dart](https://dart.dev/)
-   **API:** [Frankfurter.app API](https://www.frankfurter.app/) for real-time currency rates.
-   **Key Packages:**
    -   `http`: For making network requests to the API.

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Make sure you have the Flutter SDK installed on your machine. For more information, see the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/anandhuvasudev/currency_converter.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd currency_converter
    ```
3.  **Install the dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```

## 📂 Code Structure

The application's logic and UI are self-contained within `lib/currency_converter_material.dart`. The main components are:

-   `_CurrencyConverterMaterialState`: The main stateful widget class.
    -   **State Variables:** Manages the amount, selected currencies, loading states, and error messages.
    -   **API Logic:**
        -   `_fetchCurrencies()`: Fetches the list of all available currencies on app startup.
        -   `_convert()`: Performs the conversion using the amount and selected currencies.
    -   **UI Build Methods:**
        -   `build()`: The main method that constructs the widget tree.
        -   `_buildAmountField()`: Creates the styled text input for the amount.
        -   `_buildCurrencySwapSection()`: Builds the "From" and "To" currency cards with the swap button.
        -   `_buildConvertButton()`: The main call-to-action button.
    -   **Helper Functions:**
        -   `countryCodeToEmoji()`: A clever utility to convert a 2-letter country code into a flag emoji.
        -   `_showResultDialog()` / `_showCurrencySelection()`: Handle dialogs and modal bottom sheets for user interaction.

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🙏 Acknowledgements

-   This project relies on the free and excellent [Frankfurter.app API](https://www.frankfurter.app/) for providing currency data.
-   The Flutter team and community for creating an amazing framework.
