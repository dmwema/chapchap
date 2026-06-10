import 'dart:developer' as developer;

import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/motif_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _logTag = 'RepeatTransfer';

enum RepeatTransferFailure {
  missingBeneficiary,
  beneficiaryNotFound,
  beneficiaryArchived,
  destinationUnavailable,
  dataLoadFailed,
}

class RepeatTransferPrefill {
  final BeneficiaireModel beneficiaire;
  final Destination destination;
  final PaysDestinationModel paysDestination;
  final ModeRetrait? modeRetrait;
  final MotifModel? motif;
  final double? amount;
  final List<dynamic> beneficiaires;
  final List<MotifModel> motifs;

  const RepeatTransferPrefill({
    required this.beneficiaire,
    required this.destination,
    required this.paysDestination,
    required this.beneficiaires,
    required this.motifs,
    this.modeRetrait,
    this.motif,
    this.amount,
  });
}

class RepeatTransferResult {
  final RepeatTransferPrefill? prefill;
  final RepeatTransferFailure? failure;

  const RepeatTransferResult._({this.prefill, this.failure});

  factory RepeatTransferResult.success(RepeatTransferPrefill prefill) {
    return RepeatTransferResult._(prefill: prefill);
  }

  factory RepeatTransferResult.failure(RepeatTransferFailure failure) {
    return RepeatTransferResult._(failure: failure);
  }

  bool get isSuccess => prefill != null;
}

class RepeatTransferHelper {
  static void _log(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _logTag,
      error: error,
      stackTrace: stackTrace,
    );
    debugPrint('[$_logTag] $message${error != null ? ' | error: $error' : ''}');
  }

  static double? parseAmount(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return double.tryParse(raw.replaceAll(',', '.').replaceAll(' ', ''));
  }

  static double? amountFromDemande(DemandeModel demande) {
    return parseAmount(demande.montanceSrce) ?? parseAmount(demande.montantSansFrais);
  }

  static BeneficiaireModel? _findBeneficiary(List<dynamic>? data, int? id) {
    if (data == null || id == null) return null;
    for (final item in data) {
      if (item == null) continue;
      final beneficiary = BeneficiaireModel.fromJson(Map<String, dynamic>.from(item));
      if (beneficiary.idBeneficiaire == id) {
        return beneficiary;
      }
    }
    return null;
  }

  static Destination? _findDestination(PaysDestinationModel? paysDestination, String? codePaysDest) {
    if (paysDestination?.destination == null || codePaysDest == null) return null;
    for (final destination in paysDestination!.destination!) {
      if (destination.codePaysDest == codePaysDest) {
        return destination;
      }
    }
    return null;
  }

  static ModeRetrait? _findModeRetrait(Destination destination, int? idModeRetrait) {
    if (idModeRetrait == null || destination.modeRetrait == null) return null;
    for (final mode in destination.modeRetrait!) {
      if (mode.idModeRetrait == idModeRetrait) {
        return mode;
      }
    }
    return null;
  }

  static MotifModel? _findMotif(List<MotifModel> motifs, int? idMotif) {
    if (idMotif == null) return null;
    for (final motif in motifs) {
      if (motif.idMotif == idMotif) {
        return motif;
      }
    }
    return null;
  }

  static String failureMessage(BuildContext context, RepeatTransferFailure failure) {
    final l10n = AppLocalizations.of(context)!;
    switch (failure) {
      case RepeatTransferFailure.missingBeneficiary:
        return l10n.translate('repeat_transfer_missing_beneficiary');
      case RepeatTransferFailure.beneficiaryNotFound:
        return l10n.translate('repeat_transfer_beneficiary_not_found');
      case RepeatTransferFailure.beneficiaryArchived:
        return l10n.translate('repeat_transfer_beneficiary_archived');
      case RepeatTransferFailure.destinationUnavailable:
        return l10n.translate('repeat_transfer_destination_unavailable');
      case RepeatTransferFailure.dataLoadFailed:
        return l10n.translate('repeat_transfer_data_load_failed');
    }
  }

  static Future<RepeatTransferResult> resolve({
    required BuildContext context,
    required DemandeModel demande,
  }) async {
    _log('resolve() start | demande=${demande.idDemande}');

    try {
      final historyBeneficiary = demande.beneficiaire;
      if (historyBeneficiary?.idBeneficiaire == null) {
        _log('resolve() stop | missing beneficiary on demande');
        return RepeatTransferResult.failure(RepeatTransferFailure.missingBeneficiary);
      }

      final viewModel = DemandesViewModel();
      final beneficiaryId = historyBeneficiary!.idBeneficiaire!;
      _log('resolve() beneficiaryId=$beneficiaryId destination=${demande.codePaysDest}');

      _log('resolve() step 1/4: myDestinationsApi');
      final paysDestination = await viewModel.myDestinationsApi([], context);
      _log('resolve() step 1/4 done | paysDestination=${paysDestination != null} mounted=${context.mounted}');
      if (!context.mounted) {
        return RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
      }
      if (paysDestination == null) {
        _log('resolve() stop | myDestinationsApi returned null');
        return RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
      }

      _log('resolve() step 2/4: beneficiaires');
      await viewModel.beneficiaires([], context);
      _log('resolve() step 2/4 done | count=${viewModel.beneficiairesList.data?.length ?? 0} mounted=${context.mounted}');
      if (!context.mounted) {
        return RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
      }

      final beneficiary = _findBeneficiary(
        viewModel.beneficiairesList.data,
        beneficiaryId,
      );

      if (beneficiary == null) {
        _log('resolve() beneficiary not in active list, checking archives');
        _log('resolve() step 3/4: beneficiairesArchive');
        await viewModel.beneficiairesArchive([], context);
        _log('resolve() step 3/4 done | archiveCount=${viewModel.beneficiairesList.data?.length ?? 0} mounted=${context.mounted}');
        if (!context.mounted) {
          return RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
        }

        final archivedBeneficiary = _findBeneficiary(
          viewModel.beneficiairesList.data,
          beneficiaryId,
        );
        if (archivedBeneficiary != null) {
          _log('resolve() stop | beneficiary archived id=$beneficiaryId');
          return RepeatTransferResult.failure(RepeatTransferFailure.beneficiaryArchived);
        }
        _log('resolve() stop | beneficiary not found id=$beneficiaryId');
        return RepeatTransferResult.failure(RepeatTransferFailure.beneficiaryNotFound);
      }

      final destination = _findDestination(paysDestination, demande.codePaysDest);
      if (destination == null) {
        _log('resolve() stop | destination unavailable code=${demande.codePaysDest}');
        return RepeatTransferResult.failure(RepeatTransferFailure.destinationUnavailable);
      }

      _log('resolve() step 4/4: motifs');
      final motifs = await viewModel.motifs([], context);
      _log('resolve() step 4/4 done | motifs=${motifs.length} mounted=${context.mounted}');
      if (!context.mounted) {
        return RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
      }

      final modeRetrait = _findModeRetrait(
        destination,
        demande.modeRetrait?.idModeRetrait,
      );
      final motif = _findMotif(motifs, demande.motif?.idMotif);
      final amount = amountFromDemande(demande);

      _log(
        'resolve() success | modeRetrait=${modeRetrait?.idModeRetrait} '
        'motif=${motif?.idMotif} amount=$amount',
      );

      return RepeatTransferResult.success(
        RepeatTransferPrefill(
          beneficiaire: beneficiary,
          destination: destination,
          paysDestination: paysDestination,
          beneficiaires: List<dynamic>.from(viewModel.beneficiairesList.data ?? []),
          motifs: motifs,
          modeRetrait: modeRetrait,
          motif: motif,
          amount: amount,
        ),
      );
    } catch (error, stackTrace) {
      _log('resolve() exception', error: error, stackTrace: stackTrace);
      return RepeatTransferResult.failure(RepeatTransferFailure.dataLoadFailed);
    }
  }

  static void showLoadingDialog(BuildContext context) {
    _log('showLoadingDialog()');
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (dialogContext) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(radius: 14),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.translate('repeat_transfer_loading')),
            ],
          ),
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    _log('hideLoadingDialog() mounted=${context.mounted} canPop=${Navigator.of(context, rootNavigator: true).canPop()}');
    if (!context.mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
      _log('hideLoadingDialog() pop done');
    } else {
      _log('hideLoadingDialog() nothing to pop');
    }
  }

  static void openSendViewForMissingBeneficiary({
    required BuildContext context,
    required DemandeModel demande,
    required RepeatTransferFailure failure,
  }) {
    Utils.flushBarErrorMessage(failureMessage(context, failure), context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendView(
          destination: demande.codePaysDest,
          amount: amountFromDemande(demande),
        ),
      ),
    );
  }

  static void showFailureDialog(BuildContext context, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('repeat_transfer_unavailable_title')),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }
}
