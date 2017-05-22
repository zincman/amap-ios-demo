


# amap-ios-demo
A demo that include some amap sdk demo for iOS

## 1. Add Podfile
In project root folder add a `Podfile` that parallel with `.xcodeproj`

Then run `pod install`

## 2. Add Location Access
In info.plist add key `Privacy - Location Always Usage Description`

## 3. Add and Configure Bridging Header
New a AMapDemoSwift-Bridging-Header.h in the project.
Note: `AMapSearchKit.h` is necessary for reGeocode.

Then configure OC bridging header in target build settings

## 4. Open .xcworkspace
