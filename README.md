# Video_Feed_App

## Overview
The Video Feed App is a Flutter application that displays a vertically scrollable video feed. Each video post can contain multiple sub-reply videos, which can be accessed by horizontally scrolling within a main video post. The app integrates video playback functionality with custom controls and progress indicators for a seamless user experience.
## Table of Contents
- Introduction
- Features
- Installation
- Usage
- Project Structure
- Implementation Details
- Design Decisions
- Known Issues
- Future Enhancements
- Contributing
## Introduction
The Video Feed App is designed to provide users with a rich video viewing experience, where they can browse through a list of video posts and explore related video replies. The app handles video playback smoothly, even with multiple videos on the screen, thanks to efficient resource management and a clean, intuitive user interface.
## Features
- Vertical Scroll for Main Video Posts: Browse through a list of video posts, each filling the screen entirely.
- Horizontal Scroll for Sub-Reply Videos: View related video replies by swiping horizontally on a main video post.
- Custom Video Playback: Play, pause, and scrub through videos with a custom progress indicator that tracks video duration.
- Responsive Design: Ensures a consistent user experience across different devices and screen sizes.
- Efficient Resource Management: Manages video controllers carefully to prevent memory leaks and ensure smooth playback.
## Installation
### Prerequisites
- Flutter SDK
- Dart
- Android Studio or Visual Studio Code (with Flutter extensions)
##  Steps
**1.Clone the repository:**
```bash
git clone https://github.com/Dipanshu22/Video_Feed_App.git
```
**2.Navigate to the project directory:**
```bash
cd video_feed_app
```
**3.Install dependencies:**
```bash
flutter pub get
```
**4.Run the app:**
```bash
Run the app:
```
## Usage
- **Main Video Feed:** The main screen displays a vertically scrollable list of video posts. Each post occupies the full screen.
- **Viewing Replies:** Swipe horizontally on a video post to view related video replies.
- **Video Controls:** Tap on the video to pause or play. Scrub through the video using the custom progress indicator at the bottom of the screen.
## Project Structure
```bash
video_feed_app/
📦 video_feed_app
 ┣ 📂lib
 ┃ ┣ 📂domain
 ┃ ┃ ┣ 📂models
 ┃ ┃ ┃ ┣ 📜post.dart
 ┃ ┃ ┃ ┗ 📜reply.dart
 ┃ ┃ ┣ 📂services
 ┃ ┃ ┃ ┗ 📜api_service.dart
 ┃ ┗ 📂presentation
 ┃ ┃ ┣ 📜main_screen.dart
 ┃ ┃ ┣ 📜post_widget.dart
 ┃ ┃ ┣ 📜reply_widget.dart
 ┃ ┃ ┗ 📜video_player_widget.dart
 ┃ ┗ 📂providers
 ┃ ┃ ┣ 📜post_provider.dart
 ┃ ┃ ┗ 📜reply_provider.dart
 ┗ 📜main.dart
```
## Implementation Details
- **Video Playback:** Video playback is managed using the video_player package. The VideoPlayerWidget is designed to handle play/pause functionality and display custom progress indicators.
- **Data Fetching:** Video posts and their replies are fetched from an external API. The PostProvider and ReplyProvider handle the state management using the provider package.
- **UI Design:** The UI is designed to provide a seamless experience with intuitive navigation and responsive layouts.
## Design Decisions
- **Modular Design:** The app is structured into modular components for easier maintenance and extension.
- **Resource Management:** Video controllers are initialized and disposed of properly to ensure smooth playback and prevent memory leaks.
- **Responsive UI:** The app is optimized for different screen sizes and orientations, ensuring a consistent experience.
## Known Issues
- **Video Progress Indicator for Replies:** There is an ongoing issue with the video progress indicator for reply videos not updating correctly.
## Future Enhancements
- **Offline Caching:** Implement offline caching for videos to improve load times and provide a better user experience in low-connectivity environments.
- **Interactive Features:** Add interactive features such as comments, likes, and sharing directly from the video feed.
- **Performance Optimization:** Further optimize video loading and buffering for smoother playback.
## Contributing
Contributions are welcome! Please submit a pull request or open an issue if you have suggestions or bug reports.

