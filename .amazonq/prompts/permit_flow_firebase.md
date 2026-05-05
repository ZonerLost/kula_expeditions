# Permit Flow Firebase Integration Prompt

## Project Context
- Flutter app using GetX for state management and navigation
- Firebase Firestore for database, Firebase Storage for file uploads
- No authentication flow — all users identified by hardcoded `userId: "demo-mobile-user-1"`
- Design system: `AppColors`, `AppTextStyles`, `AppButton`, `AppTextField` — always follow existing patterns
- Font: ZalandoSans, scaffold bg: white, primary button: `AppColors.buttonGreen`

---

## Firestore Collection: `permits`
Each document has these exact fields:
```
userId           (string)   — hardcoded "demo-mobile-user-1"
fullName         (string)
passportNumber   (string)
nationality      (string)
dateOfBirth      (string)   — format: "YYYY-MM-DD"
placeOfBirth     (string)
email            (string)
emergencyContact (string)
startDate        (string)   — format: "YYYY-MM-DD"
endDate          (string)   — format: "YYYY-MM-DD"
crossingDate     (string)   — format: "YYYY-MM-DD"
fromCountry      (string)
toCountry        (string)
borderPoint      (string)
needsVisa        (boolean)
passportUrl      (string)   — Firebase Storage URL or dummy
visaUrl          (string)   — Firebase Storage URL or dummy, empty if needsVisa=false
status           (string)   — "pending" | "approved" | "rejected"
permitId         (string)   — auto-generated format: "BLK-XXXX-XXXX"
amountPaid       (int64)    — 0 until payment integrated
paymentStatus    (string)   — "unpaid" until payment integrated
hasDiscount      (boolean)  — false until discount flow integrated
submittedAt      (timestamp)— FieldValue.serverTimestamp()
createdAt        (timestamp)— FieldValue.serverTimestamp()
updatedAt        (timestamp)— FieldValue.serverTimestamp()
```

---

## Architecture

### New Files Created
```
lib/
  models/
    permit_firestore_model.dart         — Firestore model with toMap() + fromDoc()
  services/
    permit_service.dart                 — Firebase ops: submit, listen, upload
    permit_form_state.dart              — GetxService holding form data across steps
  modules/
    permit_waiting_approval/
      binding/permit_waiting_approval_binding.dart
      controller/permit_waiting_approval_controller.dart
      view/permit_waiting_approval_view.dart
    shell/
      permit_tab_view.dart              — Smart tab: PermitView or PermitListView
```

### Modified Files
```
lib/
  main.dart                                              — Register PermitFormState as permanent
  routes/app_routes.dart                                 — Add permitWaitingApproval route constant
  routes/app_pages.dart                                  — Register all routes; contactDocuments was missing!
  modules/
    permit_personal_info/controller/                     — Validation + save to PermitFormState
    hiking_crossing/controller/                          — Date logic + validation + save to PermitFormState
    contact_documents/controller/                        — File pick + Firebase submit + navigate
    permit_payment/controller/permit_approved_controller — Accept PermitFirestoreModel from Get.arguments
    permit_payment/view/permit_approved_view.dart        — Use real Firestore data
    permit_list/controller/permit_list_controller.dart   — Real-time Firestore stream
    permit_list/view/permit_list_view.dart               — PermitFirestoreModel + loading state
    shell/main_shell_view.dart                           — Use PermitTabView + add PermitListBinding
  widgets/
    permit_card_widget.dart                              — PermitFirestoreModel + status badge
```

---

## Key Implementation Details

### PermitFormState (GetxService)
- Registered as `Get.put(PermitFormState(), permanent: true)` in `main.dart`
- Holds all form fields across 3 screens: personal info, hiking details, contact & docs
- Call `formState.clear()` after successful Firestore submission

### PermitService (static methods)
- `userId` — hardcoded `"demo-mobile-user-1"`
- `_generatePermitId()` — generates `"BLK-XXXX-XXXX"` format
- `uploadFile(File, path)` — uploads to Firebase Storage, returns download URL
  - **Currently commented out** — returns dummy URL `"https://dummy-storage.example.com/$path"`
  - Uncomment when Firebase Storage rules are set to `allow read, write: if true`
- `submitPermit(model)` — adds doc to `permits` collection, returns `docId`
- `listenToPermit(docId)` — real-time stream for single permit (used in waiting screen)
- `listenToUserPermits()` — real-time stream of all user permits ordered by `createdAt desc`

### Validation Rules

**Personal Info:**
- Full name: required, min 3 chars
- Passport number: required
- Date of birth: required, picker range `1930 → (currentYear - 5)`
- Place of birth: required

**Hiking Details:**
- Start date: required, min = today
- End date: required, must be strictly after start date — reset if start changes and end becomes invalid
- Crossing date: required, must be between start and end dates — reset if out of range
- From / To / Border point: all required
- Dates stored as `"YYYY-MM-DD"` in Firestore, displayed as `"DD-MM-YYYY"` in text fields

**Contact & Documents:**
- Emergency contact: required, regex `^\+?[0-9\s\-]{7,15}$`
- Passport file: required (jpg/jpeg/png/pdf via file_picker)
- Visa file: required only if `needsVisa == true`

### Navigation Flow
```
PermitView (apply screen)
  → PermitPersonalInfoView    [saves to PermitFormState, navigates via AppRoutes]
    → HikingDetailsView       [saves to PermitFormState, navigates via AppRoutes]
      → ContactDocumentsView  [uploads files + submits Firestore → gets docId]
        → PermitWaitingApprovalView(docId)     [real-time Firestore listener]
          → PermitApprovedView(PermitFirestoreModel)  [auto on status=="approved"]
```

### PermitWaitingApprovalView
- Receives `docId` as `Get.arguments as String`
- Listens to Firestore doc via `StreamSubscription` in controller
- When `status == "approved"`: cancel sub → `Get.offNamed(permitApproved, arguments: permit)`
- Design: white card, yellow "Waiting for Approval" badge with hourglass icon
- Shows: permitId, fullName, passportNumber, travel dates, route, border point, "Pending" status badge
- Bottom tip: "This screen will automatically update once your permit is approved"

### PermitApprovedView
- Receives `PermitFirestoreModel` as `Get.arguments as PermitFirestoreModel`
- QR code via `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data={permitId}`
- Shows: permitId, validity (formatted dates), route (from→to), border point
- Green "Approved" badge
- "Download QR" button → `Get.offAllNamed(permitsList)`

### PermitTabView (shell)
- Observes `PermitListController.permits` and `isLoading`
- Loading → `CircularProgressIndicator`
- Permits empty → `PermitView` (apply screen)
- Permits exist → `PermitListView`
- `PermitListBinding` must be called in `MainShellView.initState()` for this to work

### PermitCardWidget
- Uses `PermitFirestoreModel` (replaced old `PermitListModel`)
- Status badge colors: pending=yellow `0xFFF4B400`, approved=green `0xFF4CAF50`, rejected=red `0xFFE53935`
- Button label: approved → "Download QR", pending → "View Status"
- Tapping approved → `Get.toNamed(permitApproved, arguments: permit)`
- Tapping pending → `Get.toNamed(permitWaitingApproval, arguments: permit.docId)`

### Date Formatting Helper (used in multiple views)
```dart
String _fmt(String iso) {
  // "2026-08-12" → "Aug 12, 2026"
  final parts = iso.split('-');
  if (parts.length != 3) return iso;
  final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}
```

---

## Firebase Rules (set in Firebase Console, not in code)

**Firestore → Rules:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Storage → Rules:**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

---

## pubspec.yaml Dependencies
```yaml
firebase_core: ^4.7.0
cloud_firestore: ^6.3.0
firebase_storage: ^13.3.0   # must be ^13.x.x to be compatible with firebase_core ^4.7.0
file_picker: ^8.1.4
intl: ^0.20.1
```

---

## Common Pitfalls to Avoid
1. **Missing route in AppPages** — `contactDocuments` was missing, causing null crash on `Get.toNamed`. Always register every route in both `app_routes.dart` AND `app_pages.dart`
2. **firebase_storage version conflict** — use `^13.3.0` not `^12.x.x` with `firebase_core ^4.7.0`
3. **PermitListBinding in shell** — must be called in `MainShellView.initState()` so `PermitListController` exists when `PermitTabView` calls `Get.find()`
4. **Duplicate imports in shell** — when patching imports causes duplicates, rewrite the full file
5. **Storage upload 404** — Firebase Storage rejects uploads without auth token; comment out real upload and use dummy URL until Storage rules are configured
6. **Date format split** — store dates as `YYYY-MM-DD` in Firestore, display as `DD-MM-YYYY` in text fields, format as `"Aug 12, 2026"` in summary/approved screens
7. **PermitFormState.clear()** — must be called after successful submission to reset form for next permit application
