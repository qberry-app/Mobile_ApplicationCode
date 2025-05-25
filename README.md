**Downloading & Installing the Budget Caddie Mobile Application**

**✅ Option 1: Install via GitHub Web Interface (Default Method)**

Visit the GitHub repository.

Click the green “Code” button.

Select “Download ZIP”.

Once the download completes, unzip the archive.

Navigate to the Mobile_ApplicationCode-Version1.0 folder.

Open the Budget_Caddie.xcworkspace file in Xcode.

Build and run the application.

**✅ Option 2: Install via Terminal (Recommended Method)**

Instead of downloading the ZIP file manually, you can clone the latest version (Version1.0) using terminal commands.

Steps:
bash
Copy
Edit
git clone -b Version1.0 https://github.com/qberry-app/Mobile_ApplicationCode.git

cd Mobile_ApplicationCode

✅ This ensures you are using the latest Version1.0 branch.

⚙️ Pod Installation (Dependency Setup)

The project already includes the required CocoaPods configuration.

If you face issues or want to update to the latest pod versions:

bash
Copy
Edit
cd path/to/project/directory
pod update
Or, to reinstall the pods as they were initially configured:

bash
Copy
Edit
pod install
After pod installation, open the workspace:

bash
Copy
Edit
open Budget_Caddie.xcworkspace
📋 Requirements
A Mac machine

Xcode (latest version recommended)

iOS Simulator with the latest iOS version or a real iOS device
