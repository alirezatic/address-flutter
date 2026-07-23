# Flutter Distribution UI v1

## Apply

Extract this package to:

```text
D:\Development\address_clean_v1\reference\flutter_distribution_ui_v1
```

Run:

```powershell
cd d:\development\address_clean_v1
powershell -executionpolicy bypass -file .\reference\flutter_distribution_ui_v1\apply_distribution_ui_v1.ps1
```

The script validates the exact audited source hashes, creates a backup, applies the UI, regenerates localization, and runs:

```text
dart format
flutter gen-l10n
flutter analyze
flutter test
```

On failure, it restores the prior project files automatically.

## Expected result

```text
No issues found!
All tests passed!
DISTRIBUTION UI V1 APPLIED SUCCESSFULLY
```
