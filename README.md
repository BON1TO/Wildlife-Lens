🦁 Wildlife Lens — Animal Object Detection App

Wildlife Lens is a mobile application that detects and classifies animals and other objects from images using a lightweight TensorFlow Lite (TFLite) model.
Built entirely in Flutter using Android Studio, the app runs efficiently on mobile devices and performs fast on-device inference without needing an internet connection.

✨ Overview

Wildlife Lens leverages an Efficient-Lite CNN model trained with TensorFlow and optimized for TensorFlow Lite.
Users can capture or upload photos, and the app instantly identifies animals in the image — showing their names and confidence percentages.

🚀 Features

📸 Take or upload images directly from your device

🧠 Detection using TensorFlow Lite

🐾 Specialized for wildlife and pet recognition

⚡ Runs fast on mobile devices (Efficient-Lite model)

📴 Fully offline inference — no server required

🎨 Smooth modern Flutter UI built with Material Design

💾 Local storage of past results using Shared Preferences

🧬 Tech Stack
Layer	Technology
Frontend	Flutter (Dart)
Backend / Model	TensorFlow → TensorFlow Lite (Efficient-Lite)
IDE	Android Studio
Model Integration	tflite_flutter, tflite_flutter_helper
Local Storage	Shared Preferences
⚙️ How It Works

User captures or uploads an image.

Image is resized and normalized for model input.

The Efficient-Lite TFLite model performs inference locally.

The app displays detected animals with confidence scores.

Results are stored for later viewing.

📲 Installation
Prerequisites

Flutter SDK

Android Studio (recommended IDE)

An Android device or emulator



STEPS TO RUN : 

# Clone the repository
git clone https://github.com/BON1TO/Wildlife-Lens.git

# Navigate to the project directory
cd Wildlife-Lens

# Get the dependencies
flutter pub get

# Run the app
flutter run

