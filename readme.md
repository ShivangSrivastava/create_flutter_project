# Project Setup Script (`create_flutter_project.sh`)

This script is designed to assist in setting up a Flutter project by automating various configuration tasks. It supports different options to customize the setup process based on your project's requirements.

## Usage

```bash
./create_flutter_project.sh project_name [options]
```

Replace project_name with your desired Flutter project name. Ensure that the project name is in lower snake case (e.g., my_app) and use the following options as needed:

- `--internet-access`: Add internet access permission to `AndroidManifest.xml`.
- `--full-screen`: Configure the app for full-screen immersive mode.
- `--multidex`: Enable Multidex support for larger apps.
- `--app-name <name>`: Set a custom app name.
- `--firebase`: Configure Firebase services.
- `--full-app`: Keep only the mobile platform and remove others.

## Examples

```bash
# Basic project setup
./create_flutter_project.sh my_flutter_app

# Setup with options
./create_flutter_project.sh awesome_app --internet-access --full-screen --multidex --app-name "My Awesome App" --firebase

# Help and usage information
./create_flutter_project.sh ?
```

## Script Details

The script performs the following actions:

1. Initializes variables with default values and processes command-line arguments.
2. Creates a new directory with the specified project name and navigates into it.
3. Creates a Flutter app using the `flutter create .` command.
4. Applies various configurations based on the provided options:

   - Adds internet access permission to `AndroidManifest.xml` if `--internet-access` option is set.
   - Configures the app for full-screen immersive mode if `--full-screen` option is set.
   - Enables Multidex support if `--multidex` option is set.
   - Sets a custom app name in `AndroidManifest.xml` if `--app-name` option is provided.
   - Configures Firebase services and dependencies if `--firebase` option is set.
   - Removes platform folders (ios, windows, macos, web) if `--full-app` option is not set.

5. Displays a completion message once the setup is complete.

## Note

- Ensure that you have Flutter and the necessary development tools installed before running the script.
- If you're using the `--firebase` option, make sure you have the Firebase CLI and the FlutterFire CLI (`flutterfire_cli`) installed.

## Help

For more information and detailed usage instructions, run:

```bash
./create_flutter_project.sh ?
```

This will display help and usage information about the script and its options.

---

**Disclaimer:** This script is provided as-is and may require adjustments based on your specific project needs and environment. Use it with caution and make sure to review the changes it makes to your project files.

```

Feel free to adjust and enhance the readme as needed to provide additional context, instructions, and warnings based on your project's requirements.
```
