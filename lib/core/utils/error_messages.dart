import 'dart:async';
import 'dart:io' show SocketException;

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/generated/app_localizations.dart';

/// Maps backend / network errors to user-facing copy.
///
/// Pass a [BuildContext] to get the message in the user's current locale
/// (Italian / English). Without a context the function falls back to Italian
/// so existing call sites — and edge functions / background jobs that don't
/// have a context — keep working.
String humanizeError(Object error, [BuildContext? context]) {
  final l = context != null ? AppLocalizations.of(context) : null;

  if (error is AuthException) return _authMessage(error, l);
  if (error is PostgrestException) return _postgrestMessage(error, l);
  if (error is StorageException) return _storageMessage(error, l);
  if (error is SocketException) {
    return l?.errorNetwork ?? 'Nessuna connessione internet.';
  }
  if (error is TimeoutException) {
    return l?.errorTimeout ?? 'La richiesta ha impiegato troppo tempo. Riprova.';
  }

  final raw = error.toString().toLowerCase();
  if (raw.contains('socketexception') ||
      raw.contains('failed host lookup') ||
      raw.contains('network is unreachable') ||
      raw.contains('connection refused') ||
      raw.contains('connection closed')) {
    return l?.errorNetwork ?? 'Nessuna connessione internet.';
  }
  if (raw.contains('timeout')) {
    return l?.errorTimeout ?? 'La richiesta ha impiegato troppo tempo. Riprova.';
  }

  return l?.errorGeneric ?? 'Si è verificato un errore. Riprova.';
}

String _authMessage(AuthException e, AppLocalizations? l) {
  final msg = e.message.toLowerCase();
  if (msg.contains('invalid login credentials') ||
      msg.contains('invalid_credentials')) {
    return l?.errorAuthInvalidCredentials ?? 'Email o password non corretti.';
  }
  if (msg.contains('email not confirmed')) {
    return l?.errorAuthEmailNotConfirmed ??
        'Devi confermare la tua email prima di accedere.';
  }
  if (msg.contains('user already registered') ||
      msg.contains('already registered')) {
    return l?.errorAuthAlreadyRegistered ??
        'Esiste già un account con questa email.';
  }
  if (msg.contains('password should be at least')) {
    return l?.errorAuthPasswordShort ?? 'La password è troppo corta.';
  }
  if (msg.contains('user not found')) {
    return l?.errorAuthUserNotFound ??
        'Nessun account trovato con questa email.';
  }
  if (msg.contains('rate limit') || msg.contains('too many requests')) {
    return l?.errorAuthRateLimit ??
        'Troppi tentativi. Riprova fra qualche minuto.';
  }
  return l?.errorAuthGeneric ?? 'Errore di autenticazione. Riprova.';
}

String _postgrestMessage(PostgrestException e, AppLocalizations? l) {
  switch (e.code) {
    case '23505':
      return l?.errorDbDuplicate ?? 'Esiste già un elemento con questi dati.';
    case '23503':
      return l?.errorDbForeignKey ??
          'Operazione non consentita: elemento collegato ad altri dati.';
    case '23502':
      return l?.errorDbNotNull ?? 'Manca un campo obbligatorio.';
    case '42501':
    case 'PGRST116':
      return l?.errorDbPermission ?? 'Non hai i permessi per questa operazione.';
    case 'PGRST301':
      return l?.errorDbNotFound ?? 'Elemento non trovato.';
  }
  final msg = e.message.toLowerCase();
  if (msg.contains('permission denied') ||
      msg.contains('not allowed') ||
      msg.contains('row-level security')) {
    return l?.errorDbPermission ?? 'Non hai i permessi per questa operazione.';
  }
  if (msg.contains('not found') || msg.contains('no rows')) {
    return l?.errorDbNotFound ?? 'Elemento non trovato.';
  }
  if (msg.contains('duplicate')) {
    return l?.errorDbDuplicate ?? 'Esiste già un elemento con questi dati.';
  }
  return l?.errorDbGeneric ?? 'Errore del server. Riprova fra poco.';
}

String _storageMessage(StorageException e, AppLocalizations? l) {
  final msg = e.message.toLowerCase();
  if (msg.contains('payload too large') || msg.contains('too large')) {
    return l?.errorStorageTooLarge ?? 'File troppo grande.';
  }
  if (msg.contains('not found')) {
    return l?.errorStorageNotFound ?? 'File non trovato.';
  }
  if (msg.contains('not allowed') || msg.contains('unauthorized')) {
    return l?.errorStorageNotAllowed ?? 'Non puoi caricare questo file.';
  }
  return l?.errorStorageGeneric ?? 'Errore caricamento file. Riprova.';
}
