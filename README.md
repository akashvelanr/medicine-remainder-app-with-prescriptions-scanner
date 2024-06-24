# Medicine Reminder App

## Overview
The Medicine Reminder App is a Flutter application designed to help users manage their medication schedules efficiently. The app offers features to set reminders for taking medicines on time and to scan prescriptions for automatically setting reminders. This app uses `flutter_local_notifications` for managing local reminders and `google_ml_vision` for scanning prescriptions.

## Features
- **Set Reminders:** Users can manually set reminders for taking their medications.
- **Scan Prescriptions:** Users can scan their prescriptions, and the app will automatically set reminders based on the scanned information.
- **User-friendly Interface:** Easy-to-use interface for managing medication schedules.

## Tools and Libraries Used
- **Flutter:** The main framework used for developing the app.
- **flutter_local_notifications:** Used for setting and managing local notifications/reminders.
- **google_ml_vision:** Used for scanning prescriptions and extracting medication information.

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio or Visual Studio Code with Flutter and Dart plugins
- A physical device or emulator to run the app

### Installation

1. **Clone the Repository**
   ```sh
   git clone https://github.com/akashvelanr/medicine-remainder-app-with-prescriptions-scanner.git
   cd medicine-remainder-app-with-prescriptions-scanner
2. **Install Dependencies**
   ```sh
   flutter pub get
3. **Run the App**
   ```sh
   flutter run

  ### Usage

**Set Manual Reminders:**
1. Open the app.
2. Navigate to the 'Set Reminder' section.
3. Enter the medicine name, dosage, and the time to be reminded.
4. Save the reminder.

**Scan Prescriptions:**
1. Open the app.
2. Navigate to the 'Scan Prescription' section.
3. Use the camera to scan the prescription.
4. The app will automatically set reminders based on the scanned prescription.

### APK and Sample Prescription
- **APK:** [Download APK](link_to_your_apk)
- **Sample Prescription:** [Download Sample Prescription](https://github.com/akashvelanr/medicine-remainder-app-with-prescriptions-scanner/tree/main/sample%20prescriptions)



