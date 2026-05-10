# Firebase Integration — Sawari 2.0

This document describes how the Sawari Flutter app is wired to Firebase and
what you (the project owner) need to do once to make it run.

## 1. Architecture overview

```
lib/
├─ main.dart                 # initializes Firebase, routes via AuthGate
├─ auth_gate.dart            # decides destination based on auth state + role
├─ models/                   # Firestore data models
│  ├─ user_model.dart
│  ├─ ride_model.dart
│  ├─ wallet_transaction.dart
│  └─ notification_model.dart
├─ services/                 # Singleton service layer
│  ├─ auth_service.dart      # sign-up / sign-in / phone OTP / profile streams
│  ├─ ride_service.dart      # request / accept / list rides
│  ├─ wallet_service.dart    # balance + transactions (atomic txns)
│  ├─ storage_service.dart   # profile photos + driver docs
│  ├─ notification_service.dart
│  └─ support_service.dart
└─ <existing UI screens>     # now consume the services above via StreamBuilder
```

Auth model:

- The UI collects **CNIC + Password** and **Phone**.
- Firebase requires email — so the AuthService synthesizes an email
  `<cnic>@sawari.app` for `createUserWithEmailAndPassword` /
  `signInWithEmailAndPassword`.
- After sign-up, the OTP screen automatically calls
  `verifyPhoneNumber` and links the resulting `PhoneAuthCredential` to the
  newly-created user, marking `users/{uid}.isVerified = true`.

## 2. One-time setup

You picked “I’ll run FlutterFire CLI myself”. Do this once:

```powershell
# 1. Install dependencies
flutter pub get

# 2. Install / update FlutterFire CLI
dart pub global activate flutterfire_cli

# 3. Configure for your Firebase project (creates lib/firebase_options.dart
#    and platform configs).
flutterfire configure --project=<your-firebase-project-id>
```

In the [Firebase Console](https://console.firebase.google.com):

1. **Authentication → Sign-in method**: enable **Email/Password** and **Phone**.
2. **Firestore Database**: create database (Production mode).
3. **Storage**: enable.
4. **Rules**: paste `firestore.rules` and `storage.rules` from the project root,
   or deploy them via the Firebase CLI:

```powershell
npm install -g firebase-tools
firebase login
firebase init firestore storage   # link to your project, accept default file names
firebase deploy --only firestore:rules,storage:rules
```

For Android, ensure `android/app/build.gradle` has:

```
apply plugin: 'com.google.gms.google-services'
```

(`flutterfire configure` should add this automatically.)

For iOS, in `ios/Runner.xcworkspace` ensure `GoogleService-Info.plist` is
included. Phone Auth on iOS additionally requires an APNs key — see
[Firebase docs](https://firebase.google.com/docs/auth/ios/phone-auth).

## 3. Firestore schema (created by the app at runtime)

```
users/{uid}
  name, phone, cnic, email, role: passenger|driver
  rating, totalRides, isVerified, isActive
  createdAt, updatedAt, fcmToken
  photoUrl
  walletBalance               (passengers)
  licenseNumber, vehicleMakeModel, vehicleRegistration,
  driverStatus: online|offline|on_trip,
  approvalStatus: pending|approved|rejected,
  totalEarnings               (drivers)

  transactions/{txnId}
    type: topup|ridePayment|refund|withdrawal|bonus
    amount (signed), rideId, status, note, createdAt

  notifications/{nid}
    title, body, type, read, createdAt, data

rides/{rideId}
  passengerId, driverId, passengerName, driverName, vehiclePlate
  vehicleType, paymentMethod
  pickup: {address, lat, lng}
  dropoff: {address, lat, lng}
  status: requested|accepted|arrived|ongoing|completed|cancelled
  fare, distanceKm, durationMin
  requestedAt, acceptedAt, completedAt
  passengerRating, driverRating, cancelReason

supportTickets/{ticketId}
  uid, subject, message, status, createdAt
```

## 4. What is now live

| Page                       | Firebase wiring                                                       |
| -------------------------- | --------------------------------------------------------------------- |
| `splash.dart`              | Routes to `/home` → `AuthGate`                                        |
| `auth_gate.dart`           | Listens to auth state and loads role-correct dashboard                |
| `passenger_sign_up.dart`   | Creates auth user + Firestore profile, then sends OTP                 |
| `driver_sign_up.dart`      | Same as above, includes vehicle + license fields                      |
| `sign_in.dart`             | Signs in with CNIC + password, validates role                         |
| `otp_verification.dart`    | Sends + verifies SMS code via Firebase Phone Auth, links credential   |
| `passenger_dashboard.dart` | (UI only — drawer can be wired further if needed)                     |
| `passenger_orders_tab.dart`| Live stream of `rides` filtered by current `passengerId`              |
| `passenger_wallet_tab.dart`| Live balance + transactions, working **Top Up** sheet (Firestore tx)  |
| `passenger_profile_tab.dart`| Header / stats from Firestore profile, real **Log Out**              |
| `driver_dashboard.dart`    | Drawer shows live name + rating                                       |
| `driver_home_tab.dart`     | Online / offline toggle persists `driverStatus` to Firestore          |
| `driver_history_tab.dart`  | Live trips + total earnings summary                                   |
| `driver_earnings_tab.dart` | Live balance, weekly bar chart, period stats, recent trips            |
| `driver_profile_tab.dart`  | Live profile, vehicle docs, approval status, real **Log Out**         |
| `notifications_screen.dart`| Live `users/{uid}/notifications` stream + mark-read / mark-all-read   |
| `help_support_screen.dart` | "Contact Us" FAB opens a sheet that writes to `supportTickets`        |

## 5. Things still using mock data (intentionally)

These pages have static UI that doesn’t depend on persisted data yet:

- `passenger_home_tab.dart` — booking screen. The `RideService.requestRide`
  helper is ready; wire it into your "Confirm Ride" button when you finalize
  the booking flow.
- `settings_screen.dart` — toggles aren’t persisted; hook to
  `users/{uid}.settings` if you want them stored.
- `safety_screen.dart`, `location_access.dart`, `get_started.dart`,
  `role_selection.dart` — pure UI / navigation.

## 6. Helpful code paths to copy when wiring more screens

Read profile (one-shot):

```dart
final user = await AuthService.instance.getCurrentProfile();
```

Listen to profile changes:

```dart
StreamBuilder<UserModel?>(
  stream: AuthService.instance.currentProfileStream(),
  builder: (_, snap) { ... },
);
```

Create a ride:

```dart
final ride = await RideService.instance.requestRide(
  pickup: RideLocation(address: 'A', lat: 0, lng: 0),
  dropoff: RideLocation(address: 'B', lat: 0, lng: 0),
  vehicleType: 'Car',
  estimatedFare: 12.5,
);
```

Top up wallet (atomic):

```dart
await WalletService.instance.topUp(amount: 100);
```

## 7. Production hardening (next steps)

- Replace the synthesized `<cnic>@sawari.app` email pattern with phone-only auth
  if you don’t want CNIC values exposed in Firebase Auth records.
- Move sensitive writes (`walletBalance` increments, ride-fare charges, driver
  approval) into **Cloud Functions** with stricter rules.
- Add **App Check** to block unauthorized clients.
- Enable **FCM** + foreground notification handling for ride alerts.
- Add geo-querying (e.g. GeoFlutterFire) for the `requested` rides feed.
