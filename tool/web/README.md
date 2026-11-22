# Web/PWA build and packaging (Windows PowerShell)

```powershell
# From the repository root
powershell -ExecutionPolicy Bypass -File tool/web/build_web.ps1
```

The script runs `flutter pub get`, a release web build, and copies `build/web`
to `dist/web/FishTextAdventure-<version>-web/`, then creates a zip for hosting.
It also verifies that the drift WebAssembly runtime and PWA manifest are present
in the output. It does not deploy anything.
