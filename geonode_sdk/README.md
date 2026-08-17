# Dart SDK 

##  Getting Started 
### 1. Add the package to your pubspec.yaml.
### 2. Generate your SDK Key from the dashboard.
### 3. Initialize the SDK with your SDK Key.

## How it works?
### 1. Call SDKPeerClient.init('your_sdk_key'); to initialize the SDK.
### 2. Now you can call SDKPeerClient.start(); & SDKPeerClient.stop(); to connect & disconnect the peer.
### 3. You can see the logs & monitor running to check if peer is connected or not.

## Monitoring 
### There are two monitors implemented within the library:
### 1. Connection Monitor -> Which checks connection if present or not (peer will be stopped if not).
### 2. Peer Monitor -> Which checks if peer is connected correctly to the server or not.

## NOTE: This library doesn't support background proccess (You'll have to implement it on client side for Android).