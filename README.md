🦁 Wildlife Lens — Animal Object Detection App

Wildlife Lens is an intelligent mobile app that detects and classifies animals and other objects from images using a lightweight TensorFlow Lite (TFLite) model.
It’s optimized for on-device inference, making it fast, accurate, and ideal for real-time wildlife observation — even offline!

🧠 Overview

Wildlife Lens uses an Efficient-Lite CNN model built with TensorFlow and converted to TensorFlow Lite (TFLite) for mobile deployment.
Users can take or upload a picture, and the app instantly detects animals in the image — providing their names and confidence scores.

🚀 Features

📸 Capture or upload photos directly in the app

🧩 Detection using TensorFlow Lite

🐯 Specially trained for animal recognition (wild & domestic)

⚡ Optimized Efficient-Lite model for high-speed, low-latency inference

📴 Offline detection — works without an internet connection

🎨 Modern Flutter UI with smooth user experience

🧬 Tech Stack
Layer	Technology
Frontend	Flutter (Dart)
Machine Learning Model	TensorFlow → TensorFlow Lite (Efficient-Lite)
Model Integration	tflite_flutter and tflite_flutter_helper packages
Device Storage	Shared Preferences (for saving detection history)
⚙️ How It Works

The user captures or selects an image.

The app preprocesses the image (resizing, normalization, etc.).

The Efficient-Lite TFLite model runs inference locally.

Detected animals are displayed with bounding boxes and labels.

The results are saved locally for quick access.

📲 Installation
Prerequisites

Flutter SDK

Android Studio or VS Code with Flutter plugin
