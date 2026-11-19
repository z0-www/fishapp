import '../../world_backup/presentation/backup_pages.dart';

import 'dart:async';

import 'package:go_router/go_router.dart';

import '../domain/import_models.dart';

import '../../world_creator/application/definition_intake.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import 'import_providers.dart';

class ShareCoordinator extends ConsumerStatefulWidget {
  const ShareCoordinator({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<ShareCoordinator> createState() => _ShareCoordinatorState();
}

class _ShareCoordinatorState extends ConsumerState<ShareCoordinator>
    with WidgetsBindingObserver {
  StreamSubscription<void>? subscription;
  bool draining = false, again = false, checkedLocalQueue = false;
  late final GoRouteInformationProvider route;
  bool startup = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    route = ref.read(routerProvider).routeInformationProvider;
    startup = route.value.uri.path == '/startup';
    route.addListener(_routeChanged);
    final service = ref.read(shareIntakeProvider);
    service.start();
    subscription = service.events.listen((_) {
      drain();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      drain();
    });
  }

  void _routeChanged() {
    final leavingStartup = startup && route.value.uri.path != '/startup';
    startup = route.value.uri.path == '/startup';
    if (leavingStartup) {
      WidgetsBinding.instance.addPostFrameCallback((_) => drain());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) drain();
  }

  Future<void> drain() async {
    if (!mounted) return;
    // Startup refreshes the intake after the home route opens.
    if (ref.read(routerProvider).routeInformationProvider.value.uri.path ==
        '/startup') {
      return;
    }
    if (draining) {
      again = true;
      return;
    }
    draining = true;
    ref.read(intakeIssueProvider.notifier).setIssue(null);
    String? latest;
    bool definition = false;
    bool backup = false;
    var saved = false;
    try {
      final service = ref.read(shareIntakeProvider);
      final repository = ref.read(pendingShareRepositoryProvider);
      for (var round = 0; round < 64; round++) {
        final items = await service.pending();
        if (!mounted || items.isEmpty) break;
        for (final item in items) {
          final id = await repository.receive(item);
          // Database is durable first. Crash before ack replays safely.
          if (id == item.id) {
            await service.acknowledge(item.id);
          } else {
            await service.acknowledge(item.id, keepFiles: false);
          }
          if (!mounted) return;
          ref.invalidate(pendingImportsProvider);
          final job = await repository.get(id);
          if (job != null) {
            saved =
                job.state == 'saved' &&
                await repository.conversation(id) != null;
            latest = id;
            backup = job.share.files.any(
              (file) => isStoryBackupName(file.name),
            );
            definition = !backup && await isWorldDefinitionShare(job.share);
          }
        }
        if (items.length < 8) break;
      }
      if (!checkedLocalQueue) {
        checkedLocalQueue = true;
        if (latest == null) {
          final unfinished = (await repository.pending())
              .where(
                (job) =>
                    job.share.source != ImportSource.paste &&
                    [
                      'received',
                      'processing',
                      'preview',
                      'failed',
                    ].contains(job.state),
              )
              .firstOrNull;
          if (unfinished != null) {
            latest = unfinished.id;
            backup = unfinished.share.files.any(
              (file) => isStoryBackupName(file.name),
            );
            definition =
                !backup && await isWorldDefinitionShare(unfinished.share);
          }
        }
      }
      if (mounted && latest != null) {
        final router = ref.read(routerProvider);
        // Do not overwrite the user's current preview with a second event.
        if (!router.routeInformationProvider.value.uri.path.startsWith(
              '/imports/preview/',
            ) &&
            !router.routeInformationProvider.value.uri.path.startsWith(
              '/definition/import/',
            ) &&
            !router.routeInformationProvider.value.uri.path.startsWith(
              '/backup/restore/',
            )) {
          router.go(
            saved
                ? '/imports/result/$latest'
                : backup
                ? '/backup/restore/$latest'
                : definition
                ? '/definition/import/$latest'
                : '/imports/preview/$latest',
          );
        }
      }
    } catch (_) {
      // Keep native ready items unacked; retry on next resume/import-center visit.
      if (mounted) {
        ref.invalidate(pendingImportsProvider);
        ref
            .read(intakeIssueProvider.notifier)
            .setIssue('系统暂存交接未完成，原始暂存仍保留。请点击检查或重新打开应用重试。');
      }
    } finally {
      draining = false;
      if (again && mounted) {
        again = false;
        unawaited(drain());
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    route.removeListener(_routeChanged);
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
