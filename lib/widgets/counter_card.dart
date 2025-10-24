import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/counter.dart';
import '../models/counters_model.dart';
import '../l10n/app_localizations.dart';

class CounterCard extends StatelessWidget {
  final CounterItem item;

  const CounterCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Animated value change: smooth scale + fade
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: Text(
                        '${item.value}',
                        key: ValueKey<int>(item.value),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  _RoundIcon(
                    icon: Icons.remove,
                    onTap: () => Provider.of<CountersModel>(
                      context,
                      listen: false,
                    ).decrement(item.id),
                  ),
                  const SizedBox(width: 8),
                  _RoundIcon(
                    icon: Icons.add,
                    onTap: () => Provider.of<CountersModel>(
                      context,
                      listen: false,
                    ).increment(item.id),
                  ),
                  const SizedBox(width: 8),
                  // Modern action: open bottom sheet with actions (more modern than popup menu)
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => _showActionsSheet(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMenuSelect(BuildContext context, String action) async {
    final model = Provider.of<CountersModel>(context, listen: false);
    if (action == 'delete') {
      final ok =
          await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(AppLocalizations.of(ctx).t('delete_confirm_title')),
              content: Text(AppLocalizations.of(ctx).t('delete_confirm_body')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(AppLocalizations.of(ctx).t('cancel')),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(AppLocalizations.of(ctx).t('delete')),
                ),
              ],
            ),
          ) ??
          false;
      if (ok) await model.removeCounter(item.id);
    } else if (action == 'reset') {
      await model.reset(item.id);
    } else if (action == 'edit') {
      final ctl = TextEditingController(text: item.name);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(ctx).t('rename')),
          content: TextField(
            controller: ctl,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(ctx).t('name'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(ctx).t('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final nm = ctl.text.trim();
                final navigator = Navigator.of(ctx);
                if (nm.isNotEmpty) await model.rename(item.id, nm);
                navigator.pop();
              },
              child: Text(AppLocalizations.of(ctx).t('save')),
            ),
          ],
        ),
      );
    } else if (action == 'adjust') {
      final ctl = TextEditingController(text: '1');
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(ctx).t('adjust')),
          content: TextField(
            controller: ctl,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(ctx).t('adjust_hint'),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(ctx).t('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final delta = int.tryParse(ctl.text) ?? 0;
                final navigator = Navigator.of(ctx);
                await model.adjustBy(item.id, delta);
                navigator.pop();
              },
              child: Text(AppLocalizations.of(ctx).t('apply')),
            ),
          ],
        ),
      );
    }
  }

  void _showActionsSheet(BuildContext context) {
    final model = Provider.of<CountersModel>(context, listen: false);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(AppLocalizations.of(context).t('rename')),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _onMenuSelect(context, 'edit');
                },
              ),
              ListTile(
                leading: const Icon(Icons.tune),
                title: Text(AppLocalizations.of(context).t('adjust')),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _onMenuSelect(context, 'adjust');
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(AppLocalizations.of(context).t('reset')),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _onMenuSelect(context, 'reset');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(
                  AppLocalizations.of(context).t('delete'),
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  // confirm
                  final ok =
                      await showDialog<bool>(
                        context: context,
                        builder: (dctx) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(dctx).t('delete_confirm_title'),
                          ),
                          content: Text(
                            AppLocalizations.of(dctx).t('delete_confirm_body'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dctx).pop(false),
                              child: Text(
                                AppLocalizations.of(dctx).t('cancel'),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(dctx).pop(true),
                              child: Text(
                                AppLocalizations.of(dctx).t('delete'),
                              ),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (ok) await model.removeCounter(item.id);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _RoundIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIcon({required this.icon, required this.onTap});

  @override
  State<_RoundIcon> createState() => _RoundIconState();
}

class _RoundIconState extends State<_RoundIcon>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  Future<void> _doTap() async {
    // quick tactile animation
    setState(() => _scale = 0.88);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _scale = 1.0);
    // call action (don't await to keep UI snappy)
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        shape: const CircleBorder(),
        color: color.withAlpha(20),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _doTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(widget.icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }
}
