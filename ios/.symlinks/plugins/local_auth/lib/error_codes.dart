// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Exception codes for `PlatformException` returned by
// `authenticateWithBiometrics`.

/// Indicates that the user has not yet configured a passcode (iOS) or
/// PIN/pattern/password (Android) on the device.
const String passcodeNotSet = 'PasscodeNotSet';

/// Indicates the user has not enrolled any fingerprints on the device.
const String notEnrolled = 'NotEnrolled';

/// Indicates the device does not have a Touch ID/fingerprint scanner.
const String notAvailable = 'NotAvailable';

/// Indicates the device operating system is not iOS or Android.
const String otherOperatingSystem = 'OtherOperatingSystem';
