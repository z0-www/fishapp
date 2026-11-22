import 'web_storage_guard_stub.dart'
    if (dart.library.js_interop) 'web_storage_guard_web.dart' as impl;

/// Browser-only persistence helpers. Native builds report unavailable so the
/// UI can hide the section instead of pretending the browser applies.
bool get webStorageGuardAvailable => impl.available;

Future<bool> isStoragePersisted() => impl.isPersisted();

Future<bool> requestPersistentStorage() => impl.requestPersist();

Future<int?> webStorageQuotaBytes() => impl.quotaBytes();

Future<int?> webStorageUsageBytes() => impl.usageBytes();

bool get isSecureBrowserContext => impl.isSecureContext;
