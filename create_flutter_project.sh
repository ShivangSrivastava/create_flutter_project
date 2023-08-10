#!/bin/bash

# Initialize variables with default values
INTERNET_ACCESS=false
FULL_SCREEN=false
MULTIDEX=false
DEFAULT_APP_NAME=true
APP_NAME=""
PROJECT_NAME=""
FIREBASE=false
FULL_APP=false

# Extract arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --internet-access)
        INTERNET_ACCESS=true
        shift
        ;;
        --full-screen)
        FULL_SCREEN=true
        shift 
        ;;
        --multidex)
        MULTIDEX=true
        shift 
        ;;
        --app-name)
        DEFAULT_APP_NAME=false
        APP_NAME="$2"
        shift 
        ;;
        --firebase)
        FIREBASE=true
        MULTIDEX=true
        INTERNET_ACCESS=true
        shift 
        ;;
        --full-app)
        FULL_APP=true
        shift 
        ;;
        *)
        # Assume it's the project name
        PROJECT_NAME="$1"
        shift
        ;;
    esac
done

if [ -z "$PROJECT_NAME" ]; then
    echo "Project name is missing. Type './setup_project.sh ?' for help."
    exit 1
fi

if [ "$PROJECT_NAME" == "?" ]; then
    echo "Help:"
    echo "  Usage: setup_project.sh project_name [options]"
    echo ""
    echo "Options:"
    echo "  --internet-access     Add internet access permission to AndroidManifest.xml"
    echo "  --full-screen         Configure app for full-screen immersive mode"
    echo "  --multidex            Enable Multidex support for larger apps"
    echo "  --app-name <name>     Set a custom app name"
    echo "  --firebase            Configure Firebase services"
    echo "  --full-app            Keep only the mobile platform, remove others"
    echo ""
    echo "Arguments:"
    echo "  project_name          Specify the name of the Flutter project"
    exit 0
fi

mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# create flutter app
flutter create .

if [ "$INTERNET_ACCESS" = true ];then
    if ! grep -q '<uses-permission android:name="android.permission.INTERNET"\/>' android/app/src/main/AndroidManifest.xml; then
    sed -i '/<manifest xmlns:android="http:\/\/schemas.android.com\/apk\/res\/android">/a\
        <uses-permission android:name="android.permission.INTERNET"\/>
    ' android/app/src/main/AndroidManifest.xml
    fi
fi

if [ "$FULL_SCREEN" = true ];then
    if ! grep -q '<item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>' android/app/src/main/res/values/styles.xml; then
    sed -i '/<style name="NormalTheme" parent="@android:style\/Theme.Black.NoTitleBar">/a\
        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
    ' android/app/src/main/res/values/styles.xml
    fi


    if ! grep -q 'WidgetsFlutterBinding.ensureInitialized();SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);' lib/main.dart; then
    sed -i 'void main() {/a\
      WidgetsFlutterBinding.ensureInitialized();SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    ' lib/main.dart
    fi

    if ! grep -q '<item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>' android/app/src/main/res/values/styles.xml; then
    sed -i '/<style name="NormalTheme" parent="@android:style\/Theme.Black.NoTitleBar">/a\
        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
    ' android/app/src/main/res/values/styles.xml
    fi
fi

if [ "$MULTIDEX" = true ];then
    if ! grep -q 'multiDexEnabled true' android/app/build.gradle; then
    sed -i '/versionName flutterVersionName/a\
        multiDexEnabled true
    ' android/app/build.gradle
    fi

    if ! grep -q 'implementation("androidx.multidex:multidex:2.0.1")' android/app/build.gradle; then
    sed -i 'implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"/a\
        implementation("androidx.multidex:multidex:2.0.1")
    ' android/app/build.gradle
    fi
fi

if [ "$DEFAULT_APP_NAME" = false ];then
    sed -i 's/android:label="[^"]*"/android:label="$APP_NAME"/' android/app/src/main/AndroidManifest.xml
fi

if [ "$FIREBASE" = true ];then
    firebase login
    dart pub global activate flutterfire_cli
    export PATH="$PATH":"$HOME/.pub-cache/bin"
    flutterfire configure
    flutter pub add firebase_core
    echo 'afterEvaluate {
        tasks.whenTaskAdded {
            if (it.name == "app:debugSourceSetPaths") {
                it.dependsOn "app:processDebugGoogleServices"
            }
        }
    }' >> android/app/build.gradle
fi
if [ "$FULL_APP" = false ];then
    rm -rf ios windows macos web
fi

echo "Project setup complete!"
