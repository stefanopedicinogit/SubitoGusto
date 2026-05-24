import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';
import '../../data/models/promo_code.dart';
import '../../data/providers/supabase_provider.dart';
import '../../l10n/generated/app_localizations.dart';

// ============================================================================
// Provider: codes for the current tenant
// ============================================================================

/// Realtime stream of the current tenant's promo codes. Auto-updates when
/// `uses_count` is bumped by the create-payment-intent edge function, when a
/// staff member edits a code, or when one is deleted. RLS limits visibility
/// to the staff's own tenant.
final tenantPromoCodesProvider = StreamProvider<List<PromoCode>>((ref) {
  final tenantId = ref.watch(currentTenantIdProvider);
  if (tenantId == null) return Stream.value(const []);
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('promo_codes')
      .stream(primaryKey: ['id'])
      .eq('tenant_id', tenantId)
      .map((data) {
    final list = data.map((j) => PromoCode.fromJson(j)).toList();
    // Stream doesn't preserve ORDER BY — sort client-side.
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  });
});

// ============================================================================
// Page
// ============================================================================

/// Staff page to create / edit / deactivate promo codes for the current tenant.
class PromoCodesPage extends ConsumerWidget {
  const PromoCodesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codesAsync = ref.watch(tenantPromoCodesProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.promoCodesTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditor(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(l.promoCodesNew),
      ),
      body: codesAsync.when(
        data: (codes) {
          if (codes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 64,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.promoCodesEmpty,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.promoCodesEmptyHint,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: codes.length,
            itemBuilder: (context, i) =>
                _PromoRow(code: codes[i], onTap: () => _showEditor(context, ref, codes[i])),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(humanizeError(e, context))),
      ),
    );
  }

  void _showEditor(BuildContext context, WidgetRef ref, PromoCode? code) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _PromoEditor(existing: code),
      ),
    );
  }
}

// ============================================================================
// Row in the list
// ============================================================================

class _PromoRow extends StatelessWidget {
  final PromoCode code;
  final VoidCallback onTap;

  const _PromoRow({required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final status = !code.active
        ? (l.promoCodesInactive, AppColors.textSecondary)
        : code.isExpired
            ? (l.promoCodesExpired, AppColors.error)
            : code.isExhausted
                ? (l.promoCodesExhausted, AppColors.error)
                : (l.promoCodesActive, AppColors.success);

    final usesLabel = code.maxUses == null
        ? l.promoCodesUsesCount(code.usesCount)
        : l.promoCodesUsesCountMax(code.usesCount, code.maxUses!);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      code.code,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.$2.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.$1,
                      style: TextStyle(
                        color: status.$2,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${code.formatValue()} di sconto · Min. € ${code.minOrder.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                usesLabel,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Editor sheet — create new or edit existing
// ============================================================================

class _PromoEditor extends ConsumerStatefulWidget {
  final PromoCode? existing;

  const _PromoEditor({this.existing});

  @override
  ConsumerState<_PromoEditor> createState() => _PromoEditorState();
}

class _PromoEditorState extends ConsumerState<_PromoEditor> {
  late final TextEditingController _codeController;
  late final TextEditingController _valueController;
  late final TextEditingController _minOrderController;
  late final TextEditingController _maxUsesController;
  late final TextEditingController _perCustomerController;
  late final TextEditingController _descriptionController;
  late String _type;
  late bool _active;
  DateTime? _validUntil;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _codeController = TextEditingController(text: e?.code ?? '');
    _valueController =
        TextEditingController(text: e?.value.toStringAsFixed(2) ?? '');
    _minOrderController =
        TextEditingController(text: e?.minOrder.toStringAsFixed(2) ?? '0.00');
    _maxUsesController =
        TextEditingController(text: e?.maxUses?.toString() ?? '');
    _perCustomerController =
        TextEditingController(text: (e?.perCustomerLimit ?? 1).toString());
    _descriptionController =
        TextEditingController(text: e?.description ?? '');
    _type = e?.type ?? 'percent';
    _active = e?.active ?? true;
    _validUntil = e?.validUntil;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _valueController.dispose();
    _minOrderController.dispose();
    _maxUsesController.dispose();
    _perCustomerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final tenantId = ref.read(currentTenantIdProvider);
    if (tenantId == null) return;

    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _error = 'Inserisci un codice');
      return;
    }
    final value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      setState(() => _error = 'Valore non valido');
      return;
    }
    if (_type == 'percent' && value > 100) {
      setState(() => _error = 'La percentuale non può superare 100');
      return;
    }
    final minOrder =
        double.tryParse(_minOrderController.text.replaceAll(',', '.')) ?? 0;
    final maxUses = int.tryParse(_maxUsesController.text);
    final perCustomer = int.tryParse(_perCustomerController.text) ?? 1;

    // Capture handles before async.
    final sheetNavigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final client = Supabase.instance.client;
      // The date picker returns midnight at the *start* of the picked day in
      // local time. The user means "expires at the END of that day", so store
      // 23:59:59 local-then-convert-to-UTC. Otherwise picking today would mark
      // the code expired the instant the day began.
      final endOfDay = _validUntil == null
          ? null
          : DateTime(
              _validUntil!.year,
              _validUntil!.month,
              _validUntil!.day,
              23,
              59,
              59,
            ).toUtc().toIso8601String();

      final payload = {
        'tenant_id': tenantId,
        'code': code,
        'type': _type,
        'value': value,
        'min_order': minOrder,
        'max_uses': maxUses,
        'per_customer_limit': perCustomer,
        'active': _active,
        'valid_until': endOfDay,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      };
      final result = widget.existing != null
          ? await client
              .from('promo_codes')
              .update(payload)
              .eq('id', widget.existing!.id)
              .select()
          : await client.from('promo_codes').insert(payload).select();

      if ((result as List).isEmpty) {
        throw Exception(
            'Operazione non autorizzata. Verifica di essere loggato come staff del ristorante.');
      }

      ref.invalidate(tenantPromoCodesProvider);
      if (mounted) {
        sheetNavigator.pop();
      }
    } catch (e) {
      final msg = humanizeError(e, context);
      if (mounted) {
        setState(() => _error = msg);
      } else {
        messenger.showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (widget.existing == null) return;

    // Capture handles BEFORE any async gap so we never read the State's
    // BuildContext after the editor sheet may have closed.
    final sheetNavigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(AppLocalizations.of(dialogCtx).promoCodesDeleteConfirm),
        content: Text('"${widget.existing!.code}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(AppLocalizations.of(dialogCtx).commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(dialogCtx).commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      // .select() forces the delete to return the affected rows, so an
      // RLS-denied delete (which Supabase otherwise swallows silently with 0
      // rows affected) becomes detectable.
      final deleted = await Supabase.instance.client
          .from('promo_codes')
          .delete()
          .eq('id', widget.existing!.id)
          .select();
      if ((deleted as List).isEmpty) {
        throw Exception(
            'Eliminazione non autorizzata. Verifica di essere loggato come staff del ristorante.');
      }
      ref.invalidate(tenantPromoCodesProvider);
      if (mounted) {
        sheetNavigator.pop();
      }
    } catch (e) {
      final msg = humanizeError(e, context);
      if (mounted) {
        setState(() => _error = msg);
      } else {
        // Editor sheet is gone — fall back to a global SnackBar so the user
        // still sees the failure.
        messenger.showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              widget.existing == null
                  ? l.promoCodesNew
                  : l.promoCodesEdit(widget.existing!.code),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),

            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l.promoCodesCode,
                hintText: 'PIZZA10',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'percent', label: Text('%')),
                      ButtonSegment(value: 'fixed', label: Text('€')),
                    ],
                    selected: {_type},
                    onSelectionChanged: (s) =>
                        setState(() => _type = s.first),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: _type == 'percent'
                          ? '${l.promoCodesDiscount} (%)'
                          : '${l.promoCodesDiscount} (€)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _minOrderController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l.promoCodesMinOrder,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _maxUsesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l.promoCodesMaxUses,
                      hintText: l.promoCodesUnlimited,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _perCustomerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l.promoCodesPerCustomer,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _validUntil ??
                      DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) setState(() => _validUntil = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l.promoCodesValidUntil,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  _validUntil == null
                      ? l.promoCodesNoExpiry
                      : '${_validUntil!.day}/${_validUntil!.month}/${_validUntil!.year}',
                ),
              ),
            ),
            if (_validUntil != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _validUntil = null),
                  child: Text(l.promoCodesRemoveExpiry),
                ),
              ),
            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l.promoCodesDescription,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.promoCodesActive),
              subtitle: Text(l.promoCodesActiveSub),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),

            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_error!,
                  style:
                      const TextStyle(color: AppColors.error, fontSize: 13)),
            ],
            const SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                if (widget.existing != null) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                      label: Text(l.commonDelete,
                          style: const TextStyle(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(l.commonSave),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        );
      },
    );
  }
}
