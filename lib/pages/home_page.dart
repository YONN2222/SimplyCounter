import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/counters_model.dart';
import '../widgets/counter_card.dart';
import '../l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('app_title')),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAbout(context),
          ),
        ],
      ),
      body: SafeArea(child: _CountersView()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: Text(AppLocalizations.of(context).t('new')),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameCtl = TextEditingController();
    final initialCtl = TextEditingController(text: '0');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).t('new_counter')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtl,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(ctx).t('name'),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: initialCtl,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(ctx).t('start_value'),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx).t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtl.text.trim();
              final initial = int.tryParse(initialCtl.text) ?? 0;
              if (name.isEmpty) return;
              final model = Provider.of<CountersModel>(ctx, listen: false);
              final navigator = Navigator.of(ctx);
              await model.addCounter(name: name, initial: initial);
              navigator.pop();
            },
            child: Text(AppLocalizations.of(ctx).t('create')),
          ),
        ],
      ),
    );
  }

  Future<void> _openGithub(BuildContext context) async {
    final uri = Uri.parse('https://github.com/YONN2222/SimplyCounter');
    final messenger = ScaffoldMessenger.of(context);
    final cannotOpenMsg = AppLocalizations.of(context).t('could_not_open');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        messenger.showSnackBar(SnackBar(content: Text(cannotOpenMsg)));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(cannotOpenMsg)));
    }
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(ctx).t('app_title'),
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text('v0.1.0', style: Theme.of(ctx).textTheme.bodySmall),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(ctx).t('about_text')),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => _openGithub(ctx),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: Text(AppLocalizations.of(ctx).t('about_github')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx).t('close')),
          ),
        ],
      ),
    );
  }
}

class _CountersView extends StatelessWidget {
  const _CountersView();

  @override
  Widget build(BuildContext context) {
    return Consumer<CountersModel>(
      builder: (context, model, _) {
        final items = model.items;
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.format_list_numbered,
                    size: 72,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).t('no_counters'),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // responsive grid: single column on narrow screens
        final width = MediaQuery.of(context).size.width;
        final crossAxisCount = width > 700 ? 3 : (width > 450 ? 2 : 1);

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.2,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => CounterCard(item: items[i]),
          ),
        );
      },
    );
  }
}
