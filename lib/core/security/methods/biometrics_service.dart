part of security_service;

class _BiometricsService extends _BaseLockService<_BiometricsOptions> {
  final _SecurityInformations info;
  _BiometricsService(this.info);

  @override
  Future<bool> unlock(_BiometricsOptions option) async {
    assert(option.object != null);
    if (!info.hasLocalAuth) return true;

    bool authenticate = await enhancedScreenLock(
      context: option.context,
      correctString: option.object!.secret,
      customizedButtonChild: const Icon(Icons.fingerprint),
      didUnlocked: () => Navigator.of(option.context).pop(true),
      customizedButtonTap: () async {
        await _authentication().then((authenticated) {
          if (authenticated) Navigator.of(option.context).pop(true);
        });
      },
      canCancel: option.canCancel,
      didOpened: () async {
        await _authentication().then((authenticated) {
          if (authenticated) Navigator.of(option.context).pop(true);
        });
      },
    );

    return option.next(authenticate);
  }

  @override
  Future<bool> set(_BiometricsOptions option) async {
    bool authenticated = await _authentication();
    return option.next(authenticated);
  }

  @override
  Future<bool> remove(_BiometricsOptions option) async {
    bool authenticated = await _authentication();
    if (authenticated) await info._storage.clearLock();
    return option.next(authenticated);
  }

  Future<bool> _authentication([
    String localizedReason = "Unlock to open the app",
  ]) async {
    try {
      return info._localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      // OpenSettings.openSecuritySetting();
    }
    return false;
  }
}
