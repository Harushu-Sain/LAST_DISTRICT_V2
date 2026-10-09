# LAST DISTRICT V2

An original GTA-style 3D open-world survival game built with Godot 4.

## Build Instructions

### Prerequisites
- Godot 4.2.1 stable (Linux x86_64 editor for export)
- Android Export Template (matching Godot version)
- JDK 11 or later
- Android SDK (with API level 21+ and build-tools 33.0.0)
- Android NDK (r25b or later)

### Exporting Android APK
1. Install the Android export templates in Godot:
   - Open Godot editor
   - Go to Editor -> Manage Export Templates
   - Click "Install from file" and select the downloaded export template ZIP

2. Configure Android export preset:
   - Go to Project -> Export
   - Add Android preset
   - Set:
        - Package name: org.godotengine.lastdistrict
        - Version: 1.0.0
        - Keystore: create a debug keystore (or use the provided one)
   - Ensure the following are set:
        - Compile SDK version: 33
        - Minimum SDK version: 21
        - Target SDK version: 33
        - Custom debug keystore: enabled (password: android)
        - Architectures: arm64-v8a

3. Export the project:
   - Click "Export Project"
   - Choose "Android Debug (arm64-v8a)"
   - Select output path and save

### GitHub Actions
The project includes a GitHub Actions workflow that automatically builds the Android APK on push to main and on workflow_dispatch.

The workflow:
- Sets up JDK 11
- Downloads and sets up Godot 4.2.1 Linux x86_64 editor
- Downloads and installs Android export templates for Godot 4.2.1
- Sets up Android SDK and NDK
- Exports the project as an ARM64 debug APK
- Uploads the APK as a workflow artifact

## Game Features (Planned)
- Small 3D city district with roads and buildings
- Controllable third-person player
- Camera follow and collision detection
- Mobile touchscreen movement controls
- Health system and combat
- Enemy AI
- Hunger and thirst survival mechanics
- Inventory system
- Drivable vehicle
- Three small missions
- Save/load functionality

## License
MIT License