# PhotoSwipe

PhotoSwipe is a simple SwiftUI app for quickly reviewing the photos in your iPhone library and deciding whether to keep or delete them.

It uses a Tinder-style swipe interface:

- swipe right to keep a photo
- swipe left to delete a photo
- tap the buttons if you prefer a more deliberate action

When you finish reviewing your library, the app shows a summary of how many photos you kept and deleted.

## Features

- Requests access to your photo library on launch
- Loads your photos newest-first
- Shows one photo card at a time with a preview of the next one
- Supports drag gestures and button actions
- Deletes photos from the library using the Photos framework
- Displays a completion screen with keep/delete counts
- Handles denied or limited photo access
- Uses a dark, minimal interface with haptic feedback

## Project Structure

- `PhotoSwipeApp.swift` - app entry point
- `ContentView.swift` - main screen and app flow
- `Managers/PhotoLibraryManager.swift` - photo library access, loading, and deletion
- `ViewModels/PhotoViewModel.swift` - swipe state and review logic
- `Models/PhotoItem.swift` - photo model wrapper
- `Views/` - UI components for the cards, buttons, overlays, and summary screen
- `Extensions/Color+Hex.swift` - hex color helper

## Requirements

- Xcode
- iOS device or simulator with Photos access

## Install / Run

1. Open the project in Xcode.
2. Select the `PhotoSwipe` scheme.
3. Choose an iPhone simulator or a physical device.
4. Build and run the app.

If you are testing on a real device, make sure Photos permission is enabled when prompted.

## Permissions

The app requests access to the photo library so it can show and manage your photos.

## How It Works

1. The app asks for photo library permission.
2. If access is granted, it fetches all image assets.
3. Each photo is shown in a swipeable card.
4. Swiping right keeps the photo.
5. Swiping left deletes the photo.
6. After the last photo, a summary screen appears.

## Notes

- Deleted photos are removed from the actual Photos library.
- If the user grants limited access, only the visible subset of photos will be available.

## Contributing

Contributions are welcome.

If you want to improve the app, a good place to start is:

- UI polish
- better empty-state handling
- faster thumbnail loading
- undo support for deletes
- accessibility improvements

Before submitting changes, make sure the app still builds and the swipe flow works correctly.

