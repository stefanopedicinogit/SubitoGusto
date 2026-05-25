import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appName.
  ///
  /// In it, this message translates to:
  /// **'SubitoGusto'**
  String get appName;

  /// No description provided for @commonOk.
  ///
  /// In it, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In it, this message translates to:
  /// **'Si è verificato un errore. Riprova.'**
  String get commonError;

  /// No description provided for @commonYes.
  ///
  /// In it, this message translates to:
  /// **'Sì'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In it, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo'**
  String get commonNew;

  /// No description provided for @commonAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi'**
  String get commonAdd;

  /// No description provided for @commonRemove.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get commonRemove;

  /// No description provided for @commonBack.
  ///
  /// In it, this message translates to:
  /// **'Indietro'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get commonNext;

  /// No description provided for @commonContinue.
  ///
  /// In it, this message translates to:
  /// **'Continua'**
  String get commonContinue;

  /// No description provided for @commonConfirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get commonConfirm;

  /// No description provided for @commonShow.
  ///
  /// In it, this message translates to:
  /// **'Mostra'**
  String get commonShow;

  /// No description provided for @commonSearch.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get commonSearch;

  /// No description provided for @commonHere.
  ///
  /// In it, this message translates to:
  /// **'Qui'**
  String get commonHere;

  /// No description provided for @commonAll.
  ///
  /// In it, this message translates to:
  /// **'Tutti'**
  String get commonAll;

  /// No description provided for @commonAny.
  ///
  /// In it, this message translates to:
  /// **'Qualsiasi'**
  String get commonAny;

  /// No description provided for @consumerLoginTitle.
  ///
  /// In it, this message translates to:
  /// **'Bentornato'**
  String get consumerLoginTitle;

  /// No description provided for @consumerLoginSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Accedi per ordinare'**
  String get consumerLoginSubtitle;

  /// No description provided for @consumerLoginEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get consumerLoginEmailLabel;

  /// No description provided for @consumerLoginPasswordLabel.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get consumerLoginPasswordLabel;

  /// No description provided for @consumerLoginSubmit.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get consumerLoginSubmit;

  /// No description provided for @consumerLoginNoAccount.
  ///
  /// In it, this message translates to:
  /// **'Non hai un account?'**
  String get consumerLoginNoAccount;

  /// No description provided for @consumerLoginSignUp.
  ///
  /// In it, this message translates to:
  /// **'Registrati'**
  String get consumerLoginSignUp;

  /// No description provided for @consumerLoginStaffPrompt.
  ///
  /// In it, this message translates to:
  /// **'Sei uno staff?'**
  String get consumerLoginStaffPrompt;

  /// No description provided for @consumerLoginStaffLink.
  ///
  /// In it, this message translates to:
  /// **'Accedi qui'**
  String get consumerLoginStaffLink;

  /// No description provided for @consumerLoginContinueWith.
  ///
  /// In it, this message translates to:
  /// **'oppure continua con'**
  String get consumerLoginContinueWith;

  /// No description provided for @consumerLoginGoogle.
  ///
  /// In it, this message translates to:
  /// **'Continua con Google'**
  String get consumerLoginGoogle;

  /// No description provided for @consumerLoginApple.
  ///
  /// In it, this message translates to:
  /// **'Continua con Apple'**
  String get consumerLoginApple;

  /// No description provided for @consumerRegisterTitle.
  ///
  /// In it, this message translates to:
  /// **'Crea il tuo account'**
  String get consumerRegisterTitle;

  /// No description provided for @consumerRegisterSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Registrati per ordinare in pochi click'**
  String get consumerRegisterSubtitle;

  /// No description provided for @consumerRegisterNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get consumerRegisterNameLabel;

  /// No description provided for @consumerRegisterEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get consumerRegisterEmailLabel;

  /// No description provided for @consumerRegisterPasswordLabel.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get consumerRegisterPasswordLabel;

  /// No description provided for @consumerRegisterPasswordHint.
  ///
  /// In it, this message translates to:
  /// **'Minimo 8 caratteri'**
  String get consumerRegisterPasswordHint;

  /// No description provided for @consumerRegisterSubmit.
  ///
  /// In it, this message translates to:
  /// **'Crea account'**
  String get consumerRegisterSubmit;

  /// No description provided for @consumerRegisterHaveAccount.
  ///
  /// In it, this message translates to:
  /// **'Hai già un account?'**
  String get consumerRegisterHaveAccount;

  /// No description provided for @consumerRegisterSignIn.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get consumerRegisterSignIn;

  /// No description provided for @consumerRegisterSuccess.
  ///
  /// In it, this message translates to:
  /// **'Registrazione completata! Effettua il login.'**
  String get consumerRegisterSuccess;

  /// No description provided for @consumerRegisterStaffPrompt.
  ///
  /// In it, this message translates to:
  /// **'Sei uno staff?'**
  String get consumerRegisterStaffPrompt;

  /// No description provided for @consumerRegisterStaffLink.
  ///
  /// In it, this message translates to:
  /// **'Vai al login staff'**
  String get consumerRegisterStaffLink;

  /// No description provided for @consumerRegisterTagline.
  ///
  /// In it, this message translates to:
  /// **'Ordina a domicilio\ndai migliori ristoranti'**
  String get consumerRegisterTagline;

  /// No description provided for @consumerRegisterConfirmPasswordLabel.
  ///
  /// In it, this message translates to:
  /// **'Conferma password'**
  String get consumerRegisterConfirmPasswordLabel;

  /// No description provided for @consumerRegisterPasswordMismatch.
  ///
  /// In it, this message translates to:
  /// **'Le password non corrispondono'**
  String get consumerRegisterPasswordMismatch;

  /// No description provided for @consumerRegisterOwnerPrompt.
  ///
  /// In it, this message translates to:
  /// **'Sei un ristoratore?'**
  String get consumerRegisterOwnerPrompt;

  /// No description provided for @consumerRegisterOwnerLink.
  ///
  /// In it, this message translates to:
  /// **'Accedi qui'**
  String get consumerRegisterOwnerLink;

  /// No description provided for @consumerRegisterErrorAlreadyRegistered.
  ///
  /// In it, this message translates to:
  /// **'Questa email è già registrata. Prova ad accedere.'**
  String get consumerRegisterErrorAlreadyRegistered;

  /// No description provided for @consumerRegisterErrorGeneric.
  ///
  /// In it, this message translates to:
  /// **'Errore durante la registrazione. Riprova.'**
  String get consumerRegisterErrorGeneric;

  /// No description provided for @validationRequired.
  ///
  /// In it, this message translates to:
  /// **'Campo obbligatorio'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In it, this message translates to:
  /// **'Email non valida'**
  String get validationEmail;

  /// No description provided for @validationPasswordMin.
  ///
  /// In it, this message translates to:
  /// **'La password deve avere almeno 8 caratteri'**
  String get validationPasswordMin;

  /// No description provided for @navMarketplace.
  ///
  /// In it, this message translates to:
  /// **'Ristoranti'**
  String get navMarketplace;

  /// No description provided for @navFavorites.
  ///
  /// In it, this message translates to:
  /// **'Preferiti'**
  String get navFavorites;

  /// No description provided for @navOrders.
  ///
  /// In it, this message translates to:
  /// **'Ordini'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get navProfile;

  /// No description provided for @marketplaceSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca ristoranti...'**
  String get marketplaceSearchHint;

  /// No description provided for @marketplaceEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun ristorante disponibile'**
  String get marketplaceEmpty;

  /// No description provided for @marketplaceEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'I ristoranti con consegna a domicilio appariranno qui'**
  String get marketplaceEmptyHint;

  /// No description provided for @marketplaceDeliveringTo.
  ///
  /// In it, this message translates to:
  /// **'Consegna a'**
  String get marketplaceDeliveringTo;

  /// No description provided for @marketplaceChangeAddress.
  ///
  /// In it, this message translates to:
  /// **'Cambia'**
  String get marketplaceChangeAddress;

  /// No description provided for @marketplaceFilters.
  ///
  /// In it, this message translates to:
  /// **'Filtri'**
  String get marketplaceFilters;

  /// No description provided for @marketplaceNoResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun risultato per \"{query}\"'**
  String marketplaceNoResults(String query);

  /// No description provided for @marketplaceNoneInZone.
  ///
  /// In it, this message translates to:
  /// **'Nessun ristorante consegna alla tua zona'**
  String get marketplaceNoneInZone;

  /// No description provided for @marketplaceOutsideRadius.
  ///
  /// In it, this message translates to:
  /// **'Ristoranti fuori dal raggio di consegna:'**
  String get marketplaceOutsideRadius;

  /// No description provided for @marketplaceMissingCoords.
  ///
  /// In it, this message translates to:
  /// **'Ristoranti non geolocalizzati (nascosti):'**
  String get marketplaceMissingCoords;

  /// No description provided for @marketplaceShowAll.
  ///
  /// In it, this message translates to:
  /// **'Mostra comunque tutti'**
  String get marketplaceShowAll;

  /// No description provided for @marketplaceGeolocationHint.
  ///
  /// In it, this message translates to:
  /// **'Se la distanza sembra sbagliata, il ristorante o il tuo indirizzo potrebbero essere stati geolocalizzati nel posto sbagliato.'**
  String get marketplaceGeolocationHint;

  /// No description provided for @marketplaceMinOrderShort.
  ///
  /// In it, this message translates to:
  /// **'Min. {amount}'**
  String marketplaceMinOrderShort(String amount);

  /// No description provided for @marketplaceFree.
  ///
  /// In it, this message translates to:
  /// **'Gratis'**
  String get marketplaceFree;

  /// No description provided for @marketplaceMinutes.
  ///
  /// In it, this message translates to:
  /// **'{minutes} min'**
  String marketplaceMinutes(int minutes);

  /// No description provided for @marketplaceRatingNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo'**
  String get marketplaceRatingNew;

  /// No description provided for @filterSheetTitle.
  ///
  /// In it, this message translates to:
  /// **'Filtri e ordinamento'**
  String get filterSheetTitle;

  /// No description provided for @filterSheetReset.
  ///
  /// In it, this message translates to:
  /// **'Reset'**
  String get filterSheetReset;

  /// No description provided for @filterSheetSortBy.
  ///
  /// In it, this message translates to:
  /// **'Ordina per'**
  String get filterSheetSortBy;

  /// No description provided for @filterSheetCuisineType.
  ///
  /// In it, this message translates to:
  /// **'Tipo di cucina'**
  String get filterSheetCuisineType;

  /// No description provided for @filterSheetDietary.
  ///
  /// In it, this message translates to:
  /// **'Preferenze alimentari'**
  String get filterSheetDietary;

  /// No description provided for @filterSheetMaxTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo massimo di consegna'**
  String get filterSheetMaxTime;

  /// No description provided for @filterSheetDelivery.
  ///
  /// In it, this message translates to:
  /// **'Consegna'**
  String get filterSheetDelivery;

  /// No description provided for @filterSheetFreeOnly.
  ///
  /// In it, this message translates to:
  /// **'Solo consegna gratuita'**
  String get filterSheetFreeOnly;

  /// No description provided for @filterSheetShowResults.
  ///
  /// In it, this message translates to:
  /// **'Mostra risultati'**
  String get filterSheetShowResults;

  /// No description provided for @filterSheetMaxMin.
  ///
  /// In it, this message translates to:
  /// **'≤ {minutes} min'**
  String filterSheetMaxMin(int minutes);

  /// No description provided for @sortDistance.
  ///
  /// In it, this message translates to:
  /// **'Distanza'**
  String get sortDistance;

  /// No description provided for @sortDeliveryTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo di consegna'**
  String get sortDeliveryTime;

  /// No description provided for @sortRating.
  ///
  /// In it, this message translates to:
  /// **'Valutazione'**
  String get sortRating;

  /// No description provided for @sortPrice.
  ///
  /// In it, this message translates to:
  /// **'Prezzo consegna'**
  String get sortPrice;

  /// No description provided for @cuisinePizza.
  ///
  /// In it, this message translates to:
  /// **'Pizza'**
  String get cuisinePizza;

  /// No description provided for @cuisinePasta.
  ///
  /// In it, this message translates to:
  /// **'Pasta'**
  String get cuisinePasta;

  /// No description provided for @cuisineSushi.
  ///
  /// In it, this message translates to:
  /// **'Sushi'**
  String get cuisineSushi;

  /// No description provided for @cuisineBurger.
  ///
  /// In it, this message translates to:
  /// **'Hamburger'**
  String get cuisineBurger;

  /// No description provided for @cuisineKebab.
  ///
  /// In it, this message translates to:
  /// **'Kebab'**
  String get cuisineKebab;

  /// No description provided for @cuisineChinese.
  ///
  /// In it, this message translates to:
  /// **'Cinese'**
  String get cuisineChinese;

  /// No description provided for @cuisineIndian.
  ///
  /// In it, this message translates to:
  /// **'Indiana'**
  String get cuisineIndian;

  /// No description provided for @cuisineMexican.
  ///
  /// In it, this message translates to:
  /// **'Messicana'**
  String get cuisineMexican;

  /// No description provided for @cuisineAsian.
  ///
  /// In it, this message translates to:
  /// **'Asiatica'**
  String get cuisineAsian;

  /// No description provided for @cuisineMediterranean.
  ///
  /// In it, this message translates to:
  /// **'Mediterranea'**
  String get cuisineMediterranean;

  /// No description provided for @cuisineAmerican.
  ///
  /// In it, this message translates to:
  /// **'Americana'**
  String get cuisineAmerican;

  /// No description provided for @cuisineDessert.
  ///
  /// In it, this message translates to:
  /// **'Dessert'**
  String get cuisineDessert;

  /// No description provided for @cuisineBreakfast.
  ///
  /// In it, this message translates to:
  /// **'Colazione'**
  String get cuisineBreakfast;

  /// No description provided for @cuisineOther.
  ///
  /// In it, this message translates to:
  /// **'Altro'**
  String get cuisineOther;

  /// No description provided for @dietaryVegan.
  ///
  /// In it, this message translates to:
  /// **'Vegano'**
  String get dietaryVegan;

  /// No description provided for @dietaryVegetarian.
  ///
  /// In it, this message translates to:
  /// **'Vegetariano'**
  String get dietaryVegetarian;

  /// No description provided for @dietaryGlutenFree.
  ///
  /// In it, this message translates to:
  /// **'Senza glutine'**
  String get dietaryGlutenFree;

  /// No description provided for @dietaryHalal.
  ///
  /// In it, this message translates to:
  /// **'Halal'**
  String get dietaryHalal;

  /// No description provided for @dietaryKosher.
  ///
  /// In it, this message translates to:
  /// **'Kosher'**
  String get dietaryKosher;

  /// No description provided for @dietaryLactoseFree.
  ///
  /// In it, this message translates to:
  /// **'Senza lattosio'**
  String get dietaryLactoseFree;

  /// No description provided for @restaurantNotFound.
  ///
  /// In it, this message translates to:
  /// **'Ristorante non trovato'**
  String get restaurantNotFound;

  /// No description provided for @restaurantVacationBadge.
  ///
  /// In it, this message translates to:
  /// **'In ferie'**
  String get restaurantVacationBadge;

  /// No description provided for @restaurantUnavailableBadge.
  ///
  /// In it, this message translates to:
  /// **'Non disponibile'**
  String get restaurantUnavailableBadge;

  /// No description provided for @restaurantStripeMissing.
  ///
  /// In it, this message translates to:
  /// **'Il ristorante non ha completato la configurazione dei pagamenti.'**
  String get restaurantStripeMissing;

  /// No description provided for @menuAddToCart.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi'**
  String get menuAddToCart;

  /// No description provided for @menuItemAdded.
  ///
  /// In it, this message translates to:
  /// **'{name} aggiunto'**
  String menuItemAdded(String name);

  /// No description provided for @cartTitle.
  ///
  /// In it, this message translates to:
  /// **'Il tuo ordine'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In it, this message translates to:
  /// **'Il carrello è vuoto'**
  String get cartEmpty;

  /// No description provided for @cartEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi piatti dal menu'**
  String get cartEmptyHint;

  /// No description provided for @cartClear.
  ///
  /// In it, this message translates to:
  /// **'Svuota'**
  String get cartClear;

  /// No description provided for @cartSubmit.
  ///
  /// In it, this message translates to:
  /// **'Invia ordine'**
  String get cartSubmit;

  /// No description provided for @cartCustomerNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Il tuo nome (opzionale)'**
  String get cartCustomerNameLabel;

  /// No description provided for @cartCustomerNameHint.
  ///
  /// In it, this message translates to:
  /// **'Per facilitare la consegna'**
  String get cartCustomerNameHint;

  /// No description provided for @cartOrderSubmittedTitle.
  ///
  /// In it, this message translates to:
  /// **'Ordine inviato!'**
  String get cartOrderSubmittedTitle;

  /// No description provided for @cartOrderSubmittedMessage.
  ///
  /// In it, this message translates to:
  /// **'Il tuo ordine #{orderNumber} è stato ricevuto.'**
  String cartOrderSubmittedMessage(String orderNumber);

  /// No description provided for @cartOrderSubmittedTotal.
  ///
  /// In it, this message translates to:
  /// **'Totale: {total}'**
  String cartOrderSubmittedTotal(String total);

  /// No description provided for @cartOrderSubmittedFooter.
  ///
  /// In it, this message translates to:
  /// **'Riceverai il tuo ordine a breve.'**
  String get cartOrderSubmittedFooter;

  /// No description provided for @cartOk.
  ///
  /// In it, this message translates to:
  /// **'OK'**
  String get cartOk;

  /// No description provided for @cartGoToCheckout.
  ///
  /// In it, this message translates to:
  /// **'Vai al pagamento - {total}'**
  String cartGoToCheckout(String total);

  /// No description provided for @cartMinOrderNotMet.
  ///
  /// In it, this message translates to:
  /// **'Ordine minimo {amount}'**
  String cartMinOrderNotMet(String amount);

  /// No description provided for @ordersTitle.
  ///
  /// In it, this message translates to:
  /// **'I miei ordini'**
  String get ordersTitle;

  /// No description provided for @ordersActive.
  ///
  /// In it, this message translates to:
  /// **'Ordini attivi'**
  String get ordersActive;

  /// No description provided for @ordersHistory.
  ///
  /// In it, this message translates to:
  /// **'Storico ordini'**
  String get ordersHistory;

  /// No description provided for @ordersEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun ordine'**
  String get ordersEmpty;

  /// No description provided for @ordersEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'I tuoi ordini appariranno qui'**
  String get ordersEmptyHint;

  /// No description provided for @ordersDetailTitle.
  ///
  /// In it, this message translates to:
  /// **'Dettaglio ordine'**
  String get ordersDetailTitle;

  /// No description provided for @ordersNumber.
  ///
  /// In it, this message translates to:
  /// **'Ordine #{number}'**
  String ordersNumber(String number);

  /// No description provided for @ordersNotFound.
  ///
  /// In it, this message translates to:
  /// **'Ordine non trovato'**
  String get ordersNotFound;

  /// No description provided for @ordersStatusSection.
  ///
  /// In it, this message translates to:
  /// **'Stato ordine'**
  String get ordersStatusSection;

  /// No description provided for @ordersItemsSection.
  ///
  /// In it, this message translates to:
  /// **'Articoli'**
  String get ordersItemsSection;

  /// No description provided for @ordersItemsLoadError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare gli articoli'**
  String get ordersItemsLoadError;

  /// No description provided for @ordersSummarySection.
  ///
  /// In it, this message translates to:
  /// **'Riepilogo'**
  String get ordersSummarySection;

  /// No description provided for @ordersAddressSection.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo di consegna'**
  String get ordersAddressSection;

  /// No description provided for @ordersNotesSection.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get ordersNotesSection;

  /// No description provided for @statusPending.
  ///
  /// In it, this message translates to:
  /// **'In attesa'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In it, this message translates to:
  /// **'Confermato'**
  String get statusConfirmed;

  /// No description provided for @statusPreparing.
  ///
  /// In it, this message translates to:
  /// **'In preparazione'**
  String get statusPreparing;

  /// No description provided for @statusReadyForDelivery.
  ///
  /// In it, this message translates to:
  /// **'Pronto'**
  String get statusReadyForDelivery;

  /// No description provided for @statusOutForDelivery.
  ///
  /// In it, this message translates to:
  /// **'In consegna'**
  String get statusOutForDelivery;

  /// No description provided for @statusDelivered.
  ///
  /// In it, this message translates to:
  /// **'Consegnato'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In it, this message translates to:
  /// **'Annullato'**
  String get statusCancelled;

  /// No description provided for @statusRefunded.
  ///
  /// In it, this message translates to:
  /// **'Rimborsato'**
  String get statusRefunded;

  /// No description provided for @checkoutTitle.
  ///
  /// In it, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutSummary.
  ///
  /// In it, this message translates to:
  /// **'Riepilogo ordine'**
  String get checkoutSummary;

  /// No description provided for @checkoutDeliveryAddress.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo di consegna'**
  String get checkoutDeliveryAddress;

  /// No description provided for @checkoutNoAddress.
  ///
  /// In it, this message translates to:
  /// **'Nessun indirizzo di consegna'**
  String get checkoutNoAddress;

  /// No description provided for @checkoutNoAddressHint.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un indirizzo per continuare.'**
  String get checkoutNoAddressHint;

  /// No description provided for @checkoutAddAddress.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi indirizzo'**
  String get checkoutAddAddress;

  /// No description provided for @checkoutOrderNotes.
  ///
  /// In it, this message translates to:
  /// **'Note per il ristorante'**
  String get checkoutOrderNotes;

  /// No description provided for @checkoutOrderNotesHint.
  ///
  /// In it, this message translates to:
  /// **'Es. Suonare al citofono, allergie...'**
  String get checkoutOrderNotesHint;

  /// No description provided for @checkoutPromoCodeTitle.
  ///
  /// In it, this message translates to:
  /// **'Codice promozionale'**
  String get checkoutPromoCodeTitle;

  /// No description provided for @checkoutPromoHint.
  ///
  /// In it, this message translates to:
  /// **'Es. PIZZA10'**
  String get checkoutPromoHint;

  /// No description provided for @checkoutPromoApply.
  ///
  /// In it, this message translates to:
  /// **'Applica'**
  String get checkoutPromoApply;

  /// No description provided for @checkoutPromoRemove.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get checkoutPromoRemove;

  /// No description provided for @checkoutPromoApplied.
  ///
  /// In it, this message translates to:
  /// **'Codice \"{code}\" applicato'**
  String checkoutPromoApplied(String code);

  /// No description provided for @checkoutPromoInvalid.
  ///
  /// In it, this message translates to:
  /// **'Codice non valido'**
  String get checkoutPromoInvalid;

  /// No description provided for @checkoutSubtotal.
  ///
  /// In it, this message translates to:
  /// **'Subtotale'**
  String get checkoutSubtotal;

  /// No description provided for @checkoutDelivery.
  ///
  /// In it, this message translates to:
  /// **'Consegna'**
  String get checkoutDelivery;

  /// No description provided for @checkoutDiscount.
  ///
  /// In it, this message translates to:
  /// **'Sconto'**
  String get checkoutDiscount;

  /// No description provided for @checkoutTotal.
  ///
  /// In it, this message translates to:
  /// **'Totale'**
  String get checkoutTotal;

  /// No description provided for @checkoutPay.
  ///
  /// In it, this message translates to:
  /// **'Paga {amount}'**
  String checkoutPay(String amount);

  /// No description provided for @checkoutProcessing.
  ///
  /// In it, this message translates to:
  /// **'Elaborazione...'**
  String get checkoutProcessing;

  /// No description provided for @checkoutCartEmpty.
  ///
  /// In it, this message translates to:
  /// **'Il carrello è vuoto'**
  String get checkoutCartEmpty;

  /// No description provided for @checkoutAddressRequired.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un indirizzo di consegna'**
  String get checkoutAddressRequired;

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In it, this message translates to:
  /// **'Ordine confermato!'**
  String get orderConfirmedTitle;

  /// No description provided for @orderConfirmedSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Il tuo ordine è stato ricevuto e sarà preparato a breve.'**
  String get orderConfirmedSubtitle;

  /// No description provided for @orderConfirmedOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine'**
  String get orderConfirmedOrder;

  /// No description provided for @orderConfirmedTotal.
  ///
  /// In it, this message translates to:
  /// **'Totale'**
  String get orderConfirmedTotal;

  /// No description provided for @orderConfirmedEta.
  ///
  /// In it, this message translates to:
  /// **'Tempo stimato'**
  String get orderConfirmedEta;

  /// No description provided for @orderConfirmedDelivery.
  ///
  /// In it, this message translates to:
  /// **'Consegna'**
  String get orderConfirmedDelivery;

  /// No description provided for @orderConfirmedStatus.
  ///
  /// In it, this message translates to:
  /// **'Stato'**
  String get orderConfirmedStatus;

  /// No description provided for @orderConfirmedSeeOrders.
  ///
  /// In it, this message translates to:
  /// **'Vedi i miei ordini'**
  String get orderConfirmedSeeOrders;

  /// No description provided for @orderConfirmedBackToMarketplace.
  ///
  /// In it, this message translates to:
  /// **'Torna al marketplace'**
  String get orderConfirmedBackToMarketplace;

  /// No description provided for @profileTitle.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get profileTitle;

  /// No description provided for @profileNotFound.
  ///
  /// In it, this message translates to:
  /// **'Profilo non trovato'**
  String get profileNotFound;

  /// No description provided for @profileEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica profilo'**
  String get profileEdit;

  /// No description provided for @profileAddresses.
  ///
  /// In it, this message translates to:
  /// **'Indirizzi di consegna'**
  String get profileAddresses;

  /// No description provided for @profileOrders.
  ///
  /// In it, this message translates to:
  /// **'Storico ordini'**
  String get profileOrders;

  /// No description provided for @profilePushNotifications.
  ///
  /// In it, this message translates to:
  /// **'Notifiche push'**
  String get profilePushNotifications;

  /// No description provided for @profilePushNotificationsSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Avvisi sullo stato dei tuoi ordini'**
  String get profilePushNotificationsSubtitle;

  /// No description provided for @profileLanguage.
  ///
  /// In it, this message translates to:
  /// **'Lingua / Language'**
  String get profileLanguage;

  /// No description provided for @profileSignOut.
  ///
  /// In it, this message translates to:
  /// **'Esci'**
  String get profileSignOut;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome visualizzato'**
  String get profileDisplayNameLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In it, this message translates to:
  /// **'Telefono'**
  String get profilePhoneLabel;

  /// No description provided for @profileCancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get profileCancel;

  /// No description provided for @addressesTitle.
  ///
  /// In it, this message translates to:
  /// **'Indirizzi di consegna'**
  String get addressesTitle;

  /// No description provided for @addressesEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun indirizzo salvato'**
  String get addressesEmpty;

  /// No description provided for @addressesAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi indirizzo'**
  String get addressesAdd;

  /// No description provided for @addressesEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica indirizzo'**
  String get addressesEdit;

  /// No description provided for @addressesDelete.
  ///
  /// In it, this message translates to:
  /// **'Elimina indirizzo'**
  String get addressesDelete;

  /// No description provided for @addressesDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Vuoi eliminare questo indirizzo?'**
  String get addressesDeleteConfirm;

  /// No description provided for @addressesLabel.
  ///
  /// In it, this message translates to:
  /// **'Etichetta'**
  String get addressesLabel;

  /// No description provided for @addressesStreet.
  ///
  /// In it, this message translates to:
  /// **'Via e numero civico'**
  String get addressesStreet;

  /// No description provided for @addressesCity.
  ///
  /// In it, this message translates to:
  /// **'Città'**
  String get addressesCity;

  /// No description provided for @addressesPostalCode.
  ///
  /// In it, this message translates to:
  /// **'CAP'**
  String get addressesPostalCode;

  /// No description provided for @addressesProvince.
  ///
  /// In it, this message translates to:
  /// **'Provincia'**
  String get addressesProvince;

  /// No description provided for @addressesNotes.
  ///
  /// In it, this message translates to:
  /// **'Note (opzionale)'**
  String get addressesNotes;

  /// No description provided for @addressesNotesHint.
  ///
  /// In it, this message translates to:
  /// **'Piano, scala, interno...'**
  String get addressesNotesHint;

  /// No description provided for @addressesSetDefault.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo predefinito'**
  String get addressesSetDefault;

  /// No description provided for @favoritesTitle.
  ///
  /// In it, this message translates to:
  /// **'Preferiti'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun preferito'**
  String get favoritesEmpty;

  /// No description provided for @favoritesEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'I ristoranti e i piatti che metti tra i preferiti appariranno qui'**
  String get favoritesEmptyHint;

  /// No description provided for @favoritesRestaurants.
  ///
  /// In it, this message translates to:
  /// **'Ristoranti'**
  String get favoritesRestaurants;

  /// No description provided for @favoritesItems.
  ///
  /// In it, this message translates to:
  /// **'Piatti'**
  String get favoritesItems;

  /// No description provided for @reviewPromptTitle.
  ///
  /// In it, this message translates to:
  /// **'Com\'è andata?'**
  String get reviewPromptTitle;

  /// No description provided for @reviewPromptCommentHint.
  ///
  /// In it, this message translates to:
  /// **'Lascia un commento (facoltativo)'**
  String get reviewPromptCommentHint;

  /// No description provided for @reviewPromptLater.
  ///
  /// In it, this message translates to:
  /// **'Più tardi'**
  String get reviewPromptLater;

  /// No description provided for @reviewPromptSubmit.
  ///
  /// In it, this message translates to:
  /// **'Invia'**
  String get reviewPromptSubmit;

  /// No description provided for @reviewPromptThanks.
  ///
  /// In it, this message translates to:
  /// **'Grazie per la tua recensione!'**
  String get reviewPromptThanks;

  /// No description provided for @reviewLeaveTitle.
  ///
  /// In it, this message translates to:
  /// **'Lascia una recensione'**
  String get reviewLeaveTitle;

  /// No description provided for @reviewLeaveSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Aiuta altri clienti raccontando la tua esperienza.'**
  String get reviewLeaveSubtitle;

  /// No description provided for @reviewLeaveButton.
  ///
  /// In it, this message translates to:
  /// **'Lascia recensione'**
  String get reviewLeaveButton;

  /// No description provided for @reviewMine.
  ///
  /// In it, this message translates to:
  /// **'La tua recensione'**
  String get reviewMine;

  /// No description provided for @reviewEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get reviewEdit;

  /// No description provided for @locationPromptTitle.
  ///
  /// In it, this message translates to:
  /// **'Dove ti trovi?'**
  String get locationPromptTitle;

  /// No description provided for @locationPromptSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un indirizzo per scoprire i ristoranti che consegnano nella tua zona.'**
  String get locationPromptSubtitle;

  /// No description provided for @locationPromptAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi indirizzo'**
  String get locationPromptAdd;

  /// No description provided for @locationPromptSkip.
  ///
  /// In it, this message translates to:
  /// **'Continua senza indirizzo'**
  String get locationPromptSkip;

  /// No description provided for @locationSavedAddresses.
  ///
  /// In it, this message translates to:
  /// **'I tuoi indirizzi salvati'**
  String get locationSavedAddresses;

  /// No description provided for @locationOrAddNew.
  ///
  /// In it, this message translates to:
  /// **'oppure aggiungi nuovo'**
  String get locationOrAddNew;

  /// No description provided for @locationOrEnter.
  ///
  /// In it, this message translates to:
  /// **'oppure inserisci'**
  String get locationOrEnter;

  /// No description provided for @locationLabelHint.
  ///
  /// In it, this message translates to:
  /// **'Etichetta (es. Casa, Ufficio)'**
  String get locationLabelHint;

  /// No description provided for @locationStreetRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la via'**
  String get locationStreetRequired;

  /// No description provided for @locationCityRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la città'**
  String get locationCityRequired;

  /// No description provided for @locationSessionExpired.
  ///
  /// In it, this message translates to:
  /// **'Sessione scaduta. Accedi di nuovo.'**
  String get locationSessionExpired;

  /// No description provided for @locationLabelDefault.
  ///
  /// In it, this message translates to:
  /// **'Casa'**
  String get locationLabelDefault;

  /// No description provided for @welcomeTitle.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto da'**
  String get welcomeTitle;

  /// No description provided for @welcomeStart.
  ///
  /// In it, this message translates to:
  /// **'Inizia a ordinare'**
  String get welcomeStart;

  /// No description provided for @welcomeInfo.
  ///
  /// In it, this message translates to:
  /// **'Scansiona il menu, ordina e paga dal tuo telefono'**
  String get welcomeInfo;

  /// No description provided for @welcomeTableOccupied.
  ///
  /// In it, this message translates to:
  /// **'Questo tavolo è già occupato'**
  String get welcomeTableOccupied;

  /// No description provided for @welcomeTableReserved.
  ///
  /// In it, this message translates to:
  /// **'Questo tavolo è prenotato'**
  String get welcomeTableReserved;

  /// No description provided for @welcomeAskStaff.
  ///
  /// In it, this message translates to:
  /// **'Richiedi assistenza al personale'**
  String get welcomeAskStaff;

  /// No description provided for @welcomeSeats.
  ///
  /// In it, this message translates to:
  /// **'{count} posti'**
  String welcomeSeats(int count);

  /// No description provided for @welcomeSignInCta.
  ///
  /// In it, this message translates to:
  /// **'Accedi per salvare la cronologia ordini'**
  String get welcomeSignInCta;

  /// No description provided for @welcomeOccupied.
  ///
  /// In it, this message translates to:
  /// **'OCCUPATO'**
  String get welcomeOccupied;

  /// No description provided for @welcomeReserved.
  ///
  /// In it, this message translates to:
  /// **'PRENOTATO'**
  String get welcomeReserved;

  /// No description provided for @staffLoginTitle.
  ///
  /// In it, this message translates to:
  /// **'Accesso staff'**
  String get staffLoginTitle;

  /// No description provided for @staffLoginSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Gestisci il tuo ristorante'**
  String get staffLoginSubtitle;

  /// No description provided for @staffLoginSubmit.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get staffLoginSubmit;

  /// No description provided for @staffLoginNoAccount.
  ///
  /// In it, this message translates to:
  /// **'Non hai un account?'**
  String get staffLoginNoAccount;

  /// No description provided for @staffLoginRegister.
  ///
  /// In it, this message translates to:
  /// **'Registra ristorante'**
  String get staffLoginRegister;

  /// No description provided for @staffLoginConsumerPrompt.
  ///
  /// In it, this message translates to:
  /// **'Sei un cliente?'**
  String get staffLoginConsumerPrompt;

  /// No description provided for @staffLoginConsumerLink.
  ///
  /// In it, this message translates to:
  /// **'Vai all\'app cliente'**
  String get staffLoginConsumerLink;

  /// No description provided for @staffNavDashboard.
  ///
  /// In it, this message translates to:
  /// **'Dashboard'**
  String get staffNavDashboard;

  /// No description provided for @staffNavOrders.
  ///
  /// In it, this message translates to:
  /// **'Ordini'**
  String get staffNavOrders;

  /// No description provided for @staffNavMenu.
  ///
  /// In it, this message translates to:
  /// **'Menu'**
  String get staffNavMenu;

  /// No description provided for @staffNavFixedMenu.
  ///
  /// In it, this message translates to:
  /// **'Menu Fissi'**
  String get staffNavFixedMenu;

  /// No description provided for @staffNavTables.
  ///
  /// In it, this message translates to:
  /// **'Tavoli'**
  String get staffNavTables;

  /// No description provided for @staffNavKitchen.
  ///
  /// In it, this message translates to:
  /// **'Cucina'**
  String get staffNavKitchen;

  /// No description provided for @staffNavUsers.
  ///
  /// In it, this message translates to:
  /// **'Utenti'**
  String get staffNavUsers;

  /// No description provided for @staffNavAnalytics.
  ///
  /// In it, this message translates to:
  /// **'Analytics'**
  String get staffNavAnalytics;

  /// No description provided for @staffNavSettings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get staffNavSettings;

  /// No description provided for @staffNavPromos.
  ///
  /// In it, this message translates to:
  /// **'Codici promo'**
  String get staffNavPromos;

  /// No description provided for @dashboardTitle.
  ///
  /// In it, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardOrdersToday.
  ///
  /// In it, this message translates to:
  /// **'Ordini di oggi'**
  String get dashboardOrdersToday;

  /// No description provided for @dashboardRevenueToday.
  ///
  /// In it, this message translates to:
  /// **'Incasso di oggi'**
  String get dashboardRevenueToday;

  /// No description provided for @dashboardActiveOrders.
  ///
  /// In it, this message translates to:
  /// **'Ordini attivi'**
  String get dashboardActiveOrders;

  /// No description provided for @dashboardOccupiedTables.
  ///
  /// In it, this message translates to:
  /// **'Tavoli occupati'**
  String get dashboardOccupiedTables;

  /// No description provided for @dashboardRecentOrders.
  ///
  /// In it, this message translates to:
  /// **'Ordini recenti'**
  String get dashboardRecentOrders;

  /// No description provided for @dashboardNoOrders.
  ///
  /// In it, this message translates to:
  /// **'Nessun ordine'**
  String get dashboardNoOrders;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In it, this message translates to:
  /// **'Vedi tutti'**
  String get dashboardSeeAll;

  /// No description provided for @ordersStaffTitle.
  ///
  /// In it, this message translates to:
  /// **'Ordini'**
  String get ordersStaffTitle;

  /// No description provided for @ordersStaffTabDineIn.
  ///
  /// In it, this message translates to:
  /// **'Al tavolo'**
  String get ordersStaffTabDineIn;

  /// No description provided for @ordersStaffTabDelivery.
  ///
  /// In it, this message translates to:
  /// **'Consegna'**
  String get ordersStaffTabDelivery;

  /// No description provided for @ordersStaffSearch.
  ///
  /// In it, this message translates to:
  /// **'Cerca ordini...'**
  String get ordersStaffSearch;

  /// No description provided for @ordersStaffFilterAll.
  ///
  /// In it, this message translates to:
  /// **'Tutti'**
  String get ordersStaffFilterAll;

  /// No description provided for @ordersStaffEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun ordine'**
  String get ordersStaffEmpty;

  /// No description provided for @ordersStaffEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'Gli ordini appariranno qui'**
  String get ordersStaffEmptyHint;

  /// No description provided for @ordersStaffNewOrder.
  ///
  /// In it, this message translates to:
  /// **'Nuovo ordine'**
  String get ordersStaffNewOrder;

  /// No description provided for @ordersStaffTotal.
  ///
  /// In it, this message translates to:
  /// **'Totale'**
  String get ordersStaffTotal;

  /// No description provided for @ordersStaffTable.
  ///
  /// In it, this message translates to:
  /// **'Tavolo {name}'**
  String ordersStaffTable(String name);

  /// No description provided for @menuMgmtTitle.
  ///
  /// In it, this message translates to:
  /// **'Gestione menu'**
  String get menuMgmtTitle;

  /// No description provided for @menuMgmtCategories.
  ///
  /// In it, this message translates to:
  /// **'Categorie'**
  String get menuMgmtCategories;

  /// No description provided for @menuMgmtItems.
  ///
  /// In it, this message translates to:
  /// **'Piatti'**
  String get menuMgmtItems;

  /// No description provided for @menuMgmtAllCategories.
  ///
  /// In it, this message translates to:
  /// **'Tutte le categorie'**
  String get menuMgmtAllCategories;

  /// No description provided for @menuMgmtSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca piatto...'**
  String get menuMgmtSearchHint;

  /// No description provided for @menuMgmtAddCategory.
  ///
  /// In it, this message translates to:
  /// **'Nuova categoria'**
  String get menuMgmtAddCategory;

  /// No description provided for @menuMgmtAddItem.
  ///
  /// In it, this message translates to:
  /// **'Nuovo piatto'**
  String get menuMgmtAddItem;

  /// No description provided for @menuMgmtEmptyCategories.
  ///
  /// In it, this message translates to:
  /// **'Nessuna categoria'**
  String get menuMgmtEmptyCategories;

  /// No description provided for @menuMgmtEmptyItems.
  ///
  /// In it, this message translates to:
  /// **'Nessun piatto'**
  String get menuMgmtEmptyItems;

  /// No description provided for @menuMgmtAvailable.
  ///
  /// In it, this message translates to:
  /// **'Disponibile'**
  String get menuMgmtAvailable;

  /// No description provided for @menuMgmtUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Non disponibile'**
  String get menuMgmtUnavailable;

  /// No description provided for @menuMgmtPriceLabel.
  ///
  /// In it, this message translates to:
  /// **'Prezzo'**
  String get menuMgmtPriceLabel;

  /// No description provided for @menuMgmtDescriptionLabel.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get menuMgmtDescriptionLabel;

  /// No description provided for @menuMgmtNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get menuMgmtNameLabel;

  /// No description provided for @menuMgmtImage.
  ///
  /// In it, this message translates to:
  /// **'Immagine'**
  String get menuMgmtImage;

  /// No description provided for @menuMgmtTagsLabel.
  ///
  /// In it, this message translates to:
  /// **'Tag'**
  String get menuMgmtTagsLabel;

  /// No description provided for @menuMgmtCategoryLabel.
  ///
  /// In it, this message translates to:
  /// **'Categoria'**
  String get menuMgmtCategoryLabel;

  /// No description provided for @tablesTitle.
  ///
  /// In it, this message translates to:
  /// **'Tavoli'**
  String get tablesTitle;

  /// No description provided for @tablesAddTable.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi tavolo'**
  String get tablesAddTable;

  /// No description provided for @tablesEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun tavolo'**
  String get tablesEmpty;

  /// No description provided for @tablesStatusFree.
  ///
  /// In it, this message translates to:
  /// **'Libero'**
  String get tablesStatusFree;

  /// No description provided for @tablesStatusOccupied.
  ///
  /// In it, this message translates to:
  /// **'Occupato'**
  String get tablesStatusOccupied;

  /// No description provided for @tablesStatusReserved.
  ///
  /// In it, this message translates to:
  /// **'Prenotato'**
  String get tablesStatusReserved;

  /// No description provided for @tablesCapacity.
  ///
  /// In it, this message translates to:
  /// **'Capienza'**
  String get tablesCapacity;

  /// No description provided for @tablesZone.
  ///
  /// In it, this message translates to:
  /// **'Zona'**
  String get tablesZone;

  /// No description provided for @tablesQrCode.
  ///
  /// In it, this message translates to:
  /// **'Codice QR'**
  String get tablesQrCode;

  /// No description provided for @tablesDownloadQr.
  ///
  /// In it, this message translates to:
  /// **'Scarica QR'**
  String get tablesDownloadQr;

  /// No description provided for @tablesPrintQr.
  ///
  /// In it, this message translates to:
  /// **'Stampa QR'**
  String get tablesPrintQr;

  /// No description provided for @usersTitle.
  ///
  /// In it, this message translates to:
  /// **'Utenti'**
  String get usersTitle;

  /// No description provided for @usersAddUser.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi utente'**
  String get usersAddUser;

  /// No description provided for @usersEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun utente'**
  String get usersEmpty;

  /// No description provided for @usersRoleWaiter.
  ///
  /// In it, this message translates to:
  /// **'Cameriere'**
  String get usersRoleWaiter;

  /// No description provided for @usersRoleKitchen.
  ///
  /// In it, this message translates to:
  /// **'Cucina'**
  String get usersRoleKitchen;

  /// No description provided for @usersRoleManager.
  ///
  /// In it, this message translates to:
  /// **'Manager'**
  String get usersRoleManager;

  /// No description provided for @usersRoleAdmin.
  ///
  /// In it, this message translates to:
  /// **'Admin'**
  String get usersRoleAdmin;

  /// No description provided for @analyticsTitle.
  ///
  /// In it, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsRevenue.
  ///
  /// In it, this message translates to:
  /// **'Incasso'**
  String get analyticsRevenue;

  /// No description provided for @analyticsOrders.
  ///
  /// In it, this message translates to:
  /// **'Ordini'**
  String get analyticsOrders;

  /// No description provided for @analyticsAvgOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine medio'**
  String get analyticsAvgOrder;

  /// No description provided for @analyticsBestSellers.
  ///
  /// In it, this message translates to:
  /// **'Più venduti'**
  String get analyticsBestSellers;

  /// No description provided for @analyticsPeriodToday.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get analyticsPeriodToday;

  /// No description provided for @analyticsPeriodWeek.
  ///
  /// In it, this message translates to:
  /// **'Settimana'**
  String get analyticsPeriodWeek;

  /// No description provided for @analyticsPeriodMonth.
  ///
  /// In it, this message translates to:
  /// **'Mese'**
  String get analyticsPeriodMonth;

  /// No description provided for @analyticsPeriodYear.
  ///
  /// In it, this message translates to:
  /// **'Anno'**
  String get analyticsPeriodYear;

  /// No description provided for @settingsTitle.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settingsTitle;

  /// No description provided for @settingsRestaurant.
  ///
  /// In it, this message translates to:
  /// **'Ristorante'**
  String get settingsRestaurant;

  /// No description provided for @settingsDelivery.
  ///
  /// In it, this message translates to:
  /// **'Consegne'**
  String get settingsDelivery;

  /// No description provided for @settingsCategoryAndTags.
  ///
  /// In it, this message translates to:
  /// **'Categoria e tag'**
  String get settingsCategoryAndTags;

  /// No description provided for @settingsPromoCodes.
  ///
  /// In it, this message translates to:
  /// **'Codici promozionali'**
  String get settingsPromoCodes;

  /// No description provided for @settingsPromoCodesAction.
  ///
  /// In it, this message translates to:
  /// **'Gestisci codici'**
  String get settingsPromoCodesAction;

  /// No description provided for @settingsPromoCodesSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Crea sconti percentuali o a importo fisso'**
  String get settingsPromoCodesSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In it, this message translates to:
  /// **'Aspetto'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeLight.
  ///
  /// In it, this message translates to:
  /// **'Tema chiaro'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In it, this message translates to:
  /// **'Tema scuro'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In it, this message translates to:
  /// **'Tema sistema'**
  String get settingsThemeSystem;

  /// No description provided for @settingsNotifications.
  ///
  /// In it, this message translates to:
  /// **'Notifiche'**
  String get settingsNotifications;

  /// No description provided for @settingsSoundAlerts.
  ///
  /// In it, this message translates to:
  /// **'Avvisi sonori'**
  String get settingsSoundAlerts;

  /// No description provided for @settingsOrderNotifications.
  ///
  /// In it, this message translates to:
  /// **'Notifiche nuovi ordini'**
  String get settingsOrderNotifications;

  /// No description provided for @settingsDeliveryEnabled.
  ///
  /// In it, this message translates to:
  /// **'Consegne attive'**
  String get settingsDeliveryEnabled;

  /// No description provided for @settingsDeliveryFee.
  ///
  /// In it, this message translates to:
  /// **'Costo consegna'**
  String get settingsDeliveryFee;

  /// No description provided for @settingsDeliveryRadius.
  ///
  /// In it, this message translates to:
  /// **'Raggio (km)'**
  String get settingsDeliveryRadius;

  /// No description provided for @settingsDeliveryMin.
  ///
  /// In it, this message translates to:
  /// **'Ordine minimo'**
  String get settingsDeliveryMin;

  /// No description provided for @settingsDeliveryEta.
  ///
  /// In it, this message translates to:
  /// **'Tempo stimato (min)'**
  String get settingsDeliveryEta;

  /// No description provided for @settingsVacationMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità vacanza'**
  String get settingsVacationMode;

  /// No description provided for @settingsVacationModeSub.
  ///
  /// In it, this message translates to:
  /// **'Sospendi temporaneamente gli ordini'**
  String get settingsVacationModeSub;

  /// No description provided for @settingsAddress.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo'**
  String get settingsAddress;

  /// No description provided for @settingsAddressNotSet.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo non impostato'**
  String get settingsAddressNotSet;

  /// No description provided for @settingsStripeConnect.
  ///
  /// In it, this message translates to:
  /// **'Stripe Connect'**
  String get settingsStripeConnect;

  /// No description provided for @settingsStripeConnected.
  ///
  /// In it, this message translates to:
  /// **'Stripe Connect configurato'**
  String get settingsStripeConnected;

  /// No description provided for @settingsStripeNotConnected.
  ///
  /// In it, this message translates to:
  /// **'Stripe Connect non configurato'**
  String get settingsStripeNotConnected;

  /// No description provided for @settingsStripeConnect_.
  ///
  /// In it, this message translates to:
  /// **'Connetti Stripe'**
  String get settingsStripeConnect_;

  /// No description provided for @settingsBrandColors.
  ///
  /// In it, this message translates to:
  /// **'Colori del brand'**
  String get settingsBrandColors;

  /// No description provided for @settingsPrimaryColor.
  ///
  /// In it, this message translates to:
  /// **'Colore primario'**
  String get settingsPrimaryColor;

  /// No description provided for @settingsSecondaryColor.
  ///
  /// In it, this message translates to:
  /// **'Colore secondario'**
  String get settingsSecondaryColor;

  /// No description provided for @settingsBackgroundColor.
  ///
  /// In it, this message translates to:
  /// **'Sfondo'**
  String get settingsBackgroundColor;

  /// No description provided for @settingsSignOut.
  ///
  /// In it, this message translates to:
  /// **'Esci'**
  String get settingsSignOut;

  /// No description provided for @promoCodesTitle.
  ///
  /// In it, this message translates to:
  /// **'Codici promozionali'**
  String get promoCodesTitle;

  /// No description provided for @promoCodesEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun codice promozionale'**
  String get promoCodesEmpty;

  /// No description provided for @promoCodesEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'Tocca \"Nuovo codice\" per crearne uno.'**
  String get promoCodesEmptyHint;

  /// No description provided for @promoCodesNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo codice'**
  String get promoCodesNew;

  /// No description provided for @promoCodesEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica \"{code}\"'**
  String promoCodesEdit(String code);

  /// No description provided for @promoCodesActive.
  ///
  /// In it, this message translates to:
  /// **'Attivo'**
  String get promoCodesActive;

  /// No description provided for @promoCodesInactive.
  ///
  /// In it, this message translates to:
  /// **'Disattivato'**
  String get promoCodesInactive;

  /// No description provided for @promoCodesExpired.
  ///
  /// In it, this message translates to:
  /// **'Scaduto'**
  String get promoCodesExpired;

  /// No description provided for @promoCodesExhausted.
  ///
  /// In it, this message translates to:
  /// **'Esaurito'**
  String get promoCodesExhausted;

  /// No description provided for @promoCodesCode.
  ///
  /// In it, this message translates to:
  /// **'Codice'**
  String get promoCodesCode;

  /// No description provided for @promoCodesDiscount.
  ///
  /// In it, this message translates to:
  /// **'Sconto'**
  String get promoCodesDiscount;

  /// No description provided for @promoCodesMinOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine minimo (€)'**
  String get promoCodesMinOrder;

  /// No description provided for @promoCodesMaxUses.
  ///
  /// In it, this message translates to:
  /// **'Usi max'**
  String get promoCodesMaxUses;

  /// No description provided for @promoCodesUnlimited.
  ///
  /// In it, this message translates to:
  /// **'illimitato'**
  String get promoCodesUnlimited;

  /// No description provided for @promoCodesPerCustomer.
  ///
  /// In it, this message translates to:
  /// **'Per cliente'**
  String get promoCodesPerCustomer;

  /// No description provided for @promoCodesValidUntil.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get promoCodesValidUntil;

  /// No description provided for @promoCodesNoExpiry.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza'**
  String get promoCodesNoExpiry;

  /// No description provided for @promoCodesRemoveExpiry.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi scadenza'**
  String get promoCodesRemoveExpiry;

  /// No description provided for @promoCodesDescription.
  ///
  /// In it, this message translates to:
  /// **'Descrizione (interna)'**
  String get promoCodesDescription;

  /// No description provided for @promoCodesActiveSub.
  ///
  /// In it, this message translates to:
  /// **'Se disattivato, i clienti non possono usarlo'**
  String get promoCodesActiveSub;

  /// No description provided for @promoCodesDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare codice?'**
  String get promoCodesDeleteConfirm;

  /// No description provided for @promoCodesUsesCount.
  ///
  /// In it, this message translates to:
  /// **'{count} usi'**
  String promoCodesUsesCount(int count);

  /// No description provided for @promoCodesUsesCountMax.
  ///
  /// In it, this message translates to:
  /// **'{count} / {max} usi'**
  String promoCodesUsesCountMax(int count, int max);

  /// No description provided for @kitchenTitle.
  ///
  /// In it, this message translates to:
  /// **'Cucina'**
  String get kitchenTitle;

  /// No description provided for @kitchenEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun ordine da preparare'**
  String get kitchenEmpty;

  /// No description provided for @kitchenMarkReady.
  ///
  /// In it, this message translates to:
  /// **'Pronto'**
  String get kitchenMarkReady;

  /// No description provided for @kitchenMarkPreparing.
  ///
  /// In it, this message translates to:
  /// **'In preparazione'**
  String get kitchenMarkPreparing;

  /// No description provided for @notifPanelTitle.
  ///
  /// In it, this message translates to:
  /// **'Notifiche'**
  String get notifPanelTitle;

  /// No description provided for @notifPanelEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna notifica'**
  String get notifPanelEmpty;

  /// No description provided for @notifPanelMarkAllRead.
  ///
  /// In it, this message translates to:
  /// **'Segna tutte come lette'**
  String get notifPanelMarkAllRead;

  /// No description provided for @notifPanelClear.
  ///
  /// In it, this message translates to:
  /// **'Cancella tutte'**
  String get notifPanelClear;

  /// No description provided for @registerTenantTitle.
  ///
  /// In it, this message translates to:
  /// **'Registra la tua\nAzienda'**
  String get registerTenantTitle;

  /// No description provided for @registerTenantSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Avvia il tuo business in pochi minuti'**
  String get registerTenantSubtitle;

  /// No description provided for @registerTenantBusinessName.
  ///
  /// In it, this message translates to:
  /// **'Nome Azienda *'**
  String get registerTenantBusinessName;

  /// No description provided for @registerTenantPhone.
  ///
  /// In it, this message translates to:
  /// **'Telefono'**
  String get registerTenantPhone;

  /// No description provided for @registerTenantAddress.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo'**
  String get registerTenantAddress;

  /// No description provided for @registerTenantBusinessEmail.
  ///
  /// In it, this message translates to:
  /// **'Email Azienda'**
  String get registerTenantBusinessEmail;

  /// No description provided for @registerTenantFirstName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get registerTenantFirstName;

  /// No description provided for @registerTenantLastName.
  ///
  /// In it, this message translates to:
  /// **'Cognome'**
  String get registerTenantLastName;

  /// No description provided for @registerTenantAccountEmail.
  ///
  /// In it, this message translates to:
  /// **'Email di accesso *'**
  String get registerTenantAccountEmail;

  /// No description provided for @registerTenantPassword.
  ///
  /// In it, this message translates to:
  /// **'Password *'**
  String get registerTenantPassword;

  /// No description provided for @registerTenantSubmit.
  ///
  /// In it, this message translates to:
  /// **'Registrati'**
  String get registerTenantSubmit;

  /// No description provided for @registerTenantContinue.
  ///
  /// In it, this message translates to:
  /// **'Continua'**
  String get registerTenantContinue;

  /// No description provided for @registerTenantHaveAccount.
  ///
  /// In it, this message translates to:
  /// **'Hai già un account?'**
  String get registerTenantHaveAccount;

  /// No description provided for @registerTenantSignIn.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get registerTenantSignIn;

  /// No description provided for @registerTenantSuccess.
  ///
  /// In it, this message translates to:
  /// **'Registrazione completata! Effettua il login.'**
  String get registerTenantSuccess;

  /// No description provided for @registerTenantTagline.
  ///
  /// In it, this message translates to:
  /// **'Inizia a gestire la tua attività\nin pochi minuti'**
  String get registerTenantTagline;

  /// No description provided for @registerTenantCreateAccount.
  ///
  /// In it, this message translates to:
  /// **'Crea il tuo account'**
  String get registerTenantCreateAccount;

  /// No description provided for @registerTenantFormSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Compila i dati per registrare la tua azienda'**
  String get registerTenantFormSubtitle;

  /// No description provided for @registerTenantStep1Title.
  ///
  /// In it, this message translates to:
  /// **'Dati Azienda'**
  String get registerTenantStep1Title;

  /// No description provided for @registerTenantStep1Subtitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni della tua attività'**
  String get registerTenantStep1Subtitle;

  /// No description provided for @registerTenantStep2Title.
  ///
  /// In it, this message translates to:
  /// **'Account Amministratore'**
  String get registerTenantStep2Title;

  /// No description provided for @registerTenantStep2Subtitle.
  ///
  /// In it, this message translates to:
  /// **'Le tue credenziali di accesso'**
  String get registerTenantStep2Subtitle;

  /// No description provided for @registerTenantAccountEmailHint.
  ///
  /// In it, this message translates to:
  /// **'La userai per accedere'**
  String get registerTenantAccountEmailHint;

  /// No description provided for @registerTenantPasswordHint.
  ///
  /// In it, this message translates to:
  /// **'Minimo 6 caratteri'**
  String get registerTenantPasswordHint;

  /// No description provided for @registerTenantConsumerPrompt.
  ///
  /// In it, this message translates to:
  /// **'Sei un cliente?'**
  String get registerTenantConsumerPrompt;

  /// No description provided for @registerTenantConsumerLink.
  ///
  /// In it, this message translates to:
  /// **'Accedi qui'**
  String get registerTenantConsumerLink;

  /// No description provided for @registerTenantNameRequired.
  ///
  /// In it, this message translates to:
  /// **'Il nome è obbligatorio'**
  String get registerTenantNameRequired;

  /// No description provided for @registerTenantEmailRequired.
  ///
  /// In it, this message translates to:
  /// **'L\'email è obbligatoria'**
  String get registerTenantEmailRequired;

  /// No description provided for @registerTenantEmailInvalid.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un\'email valida'**
  String get registerTenantEmailInvalid;

  /// No description provided for @registerTenantPasswordRequired.
  ///
  /// In it, this message translates to:
  /// **'La password è obbligatoria'**
  String get registerTenantPasswordRequired;

  /// No description provided for @registerTenantPasswordShort.
  ///
  /// In it, this message translates to:
  /// **'La password deve essere di almeno 6 caratteri'**
  String get registerTenantPasswordShort;

  /// No description provided for @ordersStaffPaymentPaid.
  ///
  /// In it, this message translates to:
  /// **'Pagato'**
  String get ordersStaffPaymentPaid;

  /// No description provided for @ordersStaffPaymentPending.
  ///
  /// In it, this message translates to:
  /// **'Da pagare'**
  String get ordersStaffPaymentPending;

  /// No description provided for @ordersStaffPaymentFailed.
  ///
  /// In it, this message translates to:
  /// **'Pagamento fallito'**
  String get ordersStaffPaymentFailed;

  /// No description provided for @ordersStaffPaymentRefunded.
  ///
  /// In it, this message translates to:
  /// **'Rimborsato'**
  String get ordersStaffPaymentRefunded;

  /// No description provided for @ordersStaffCustomer.
  ///
  /// In it, this message translates to:
  /// **'Cliente'**
  String get ordersStaffCustomer;

  /// No description provided for @ordersStaffNotes.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get ordersStaffNotes;

  /// No description provided for @ordersStaffNoNotes.
  ///
  /// In it, this message translates to:
  /// **'Nessuna nota'**
  String get ordersStaffNoNotes;

  /// No description provided for @ordersStaffItems.
  ///
  /// In it, this message translates to:
  /// **'Articoli'**
  String get ordersStaffItems;

  /// No description provided for @ordersStaffActions.
  ///
  /// In it, this message translates to:
  /// **'Azioni'**
  String get ordersStaffActions;

  /// No description provided for @ordersStaffConfirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get ordersStaffConfirm;

  /// No description provided for @ordersStaffStartPreparing.
  ///
  /// In it, this message translates to:
  /// **'Inizia preparazione'**
  String get ordersStaffStartPreparing;

  /// No description provided for @ordersStaffMarkReady.
  ///
  /// In it, this message translates to:
  /// **'Segna come pronto'**
  String get ordersStaffMarkReady;

  /// No description provided for @ordersStaffMarkOutForDelivery.
  ///
  /// In it, this message translates to:
  /// **'In consegna'**
  String get ordersStaffMarkOutForDelivery;

  /// No description provided for @ordersStaffMarkDelivered.
  ///
  /// In it, this message translates to:
  /// **'Consegnato'**
  String get ordersStaffMarkDelivered;

  /// No description provided for @ordersStaffCancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla ordine'**
  String get ordersStaffCancel;

  /// No description provided for @ordersStaffRefund.
  ///
  /// In it, this message translates to:
  /// **'Rimborsa'**
  String get ordersStaffRefund;

  /// No description provided for @ordersStaffPrintReceipt.
  ///
  /// In it, this message translates to:
  /// **'Stampa scontrino'**
  String get ordersStaffPrintReceipt;

  /// No description provided for @ordersStaffCloseTable.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tavolo'**
  String get ordersStaffCloseTable;

  /// No description provided for @manualOrderTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo ordine manuale'**
  String get manualOrderTitle;

  /// No description provided for @manualOrderButton.
  ///
  /// In it, this message translates to:
  /// **'Nuovo ordine'**
  String get manualOrderButton;

  /// No description provided for @manualOrderCustomer.
  ///
  /// In it, this message translates to:
  /// **'Nome cliente'**
  String get manualOrderCustomer;

  /// No description provided for @manualOrderTable.
  ///
  /// In it, this message translates to:
  /// **'Tavolo'**
  String get manualOrderTable;

  /// No description provided for @manualOrderSelectTable.
  ///
  /// In it, this message translates to:
  /// **'Seleziona tavolo'**
  String get manualOrderSelectTable;

  /// No description provided for @manualOrderItems.
  ///
  /// In it, this message translates to:
  /// **'Articoli'**
  String get manualOrderItems;

  /// No description provided for @manualOrderAddItem.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi articolo'**
  String get manualOrderAddItem;

  /// No description provided for @manualOrderNotes.
  ///
  /// In it, this message translates to:
  /// **'Note (opzionale)'**
  String get manualOrderNotes;

  /// No description provided for @manualOrderSubmit.
  ///
  /// In it, this message translates to:
  /// **'Crea ordine'**
  String get manualOrderSubmit;

  /// No description provided for @manualOrderItemRequired.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi almeno un articolo'**
  String get manualOrderItemRequired;

  /// No description provided for @menuMgmtAvailableHint.
  ///
  /// In it, this message translates to:
  /// **'Visibile ai clienti'**
  String get menuMgmtAvailableHint;

  /// No description provided for @menuMgmtUnavailableHint.
  ///
  /// In it, this message translates to:
  /// **'Nascosto ai clienti'**
  String get menuMgmtUnavailableHint;

  /// No description provided for @menuMgmtDeleteCategoryConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la categoria?'**
  String get menuMgmtDeleteCategoryConfirm;

  /// No description provided for @menuMgmtDeleteItemConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il piatto?'**
  String get menuMgmtDeleteItemConfirm;

  /// No description provided for @menuMgmtItemAdded.
  ///
  /// In it, this message translates to:
  /// **'Piatto aggiunto'**
  String get menuMgmtItemAdded;

  /// No description provided for @menuMgmtItemUpdated.
  ///
  /// In it, this message translates to:
  /// **'Piatto aggiornato'**
  String get menuMgmtItemUpdated;

  /// No description provided for @menuMgmtItemDeleted.
  ///
  /// In it, this message translates to:
  /// **'Piatto eliminato'**
  String get menuMgmtItemDeleted;

  /// No description provided for @menuMgmtCategoryAdded.
  ///
  /// In it, this message translates to:
  /// **'Categoria aggiunta'**
  String get menuMgmtCategoryAdded;

  /// No description provided for @menuMgmtCategoryUpdated.
  ///
  /// In it, this message translates to:
  /// **'Categoria aggiornata'**
  String get menuMgmtCategoryUpdated;

  /// No description provided for @menuMgmtCategoryDeleted.
  ///
  /// In it, this message translates to:
  /// **'Categoria eliminata'**
  String get menuMgmtCategoryDeleted;

  /// No description provided for @menuMgmtPriceRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un prezzo'**
  String get menuMgmtPriceRequired;

  /// No description provided for @menuMgmtNameRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un nome'**
  String get menuMgmtNameRequired;

  /// No description provided for @menuMgmtUploadImage.
  ///
  /// In it, this message translates to:
  /// **'Carica immagine'**
  String get menuMgmtUploadImage;

  /// No description provided for @menuMgmtChangeImage.
  ///
  /// In it, this message translates to:
  /// **'Cambia immagine'**
  String get menuMgmtChangeImage;

  /// No description provided for @menuMgmtRemoveImage.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi immagine'**
  String get menuMgmtRemoveImage;

  /// No description provided for @tablesAddName.
  ///
  /// In it, this message translates to:
  /// **'Nome / Numero'**
  String get tablesAddName;

  /// No description provided for @tablesEditTable.
  ///
  /// In it, this message translates to:
  /// **'Modifica tavolo'**
  String get tablesEditTable;

  /// No description provided for @tablesDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare questo tavolo?'**
  String get tablesDeleteConfirm;

  /// No description provided for @tablesShowQr.
  ///
  /// In it, this message translates to:
  /// **'Mostra QR'**
  String get tablesShowQr;

  /// No description provided for @tablesScanInstructions.
  ///
  /// In it, this message translates to:
  /// **'Scansiona per ordinare'**
  String get tablesScanInstructions;

  /// No description provided for @dashboardWelcome.
  ///
  /// In it, this message translates to:
  /// **'Bentornato'**
  String get dashboardWelcome;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Ecco un\'anteprima della tua attività'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardKpis.
  ///
  /// In it, this message translates to:
  /// **'Statistiche'**
  String get dashboardKpis;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In it, this message translates to:
  /// **'Azioni rapide'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardOrderNumber.
  ///
  /// In it, this message translates to:
  /// **'Ordine'**
  String get dashboardOrderNumber;

  /// No description provided for @dashboardCustomer.
  ///
  /// In it, this message translates to:
  /// **'Cliente'**
  String get dashboardCustomer;

  /// No description provided for @dashboardAmount.
  ///
  /// In it, this message translates to:
  /// **'Importo'**
  String get dashboardAmount;

  /// No description provided for @dashboardTime.
  ///
  /// In it, this message translates to:
  /// **'Ora'**
  String get dashboardTime;

  /// No description provided for @dashboardTestCustomerView.
  ///
  /// In it, this message translates to:
  /// **'Test vista cliente'**
  String get dashboardTestCustomerView;

  /// No description provided for @dashboardTestCustomerViewSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Simula la scansione QR di un tavolo'**
  String get dashboardTestCustomerViewSubtitle;

  /// No description provided for @dashboardTestCustomerViewSubtitleShort.
  ///
  /// In it, this message translates to:
  /// **'Simula scansione QR'**
  String get dashboardTestCustomerViewSubtitleShort;

  /// No description provided for @dashboardSelectTable.
  ///
  /// In it, this message translates to:
  /// **'Seleziona tavolo'**
  String get dashboardSelectTable;

  /// No description provided for @dashboardSelectTableHeader.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un tavolo'**
  String get dashboardSelectTableHeader;

  /// No description provided for @kitchenPending.
  ///
  /// In it, this message translates to:
  /// **'In attesa'**
  String get kitchenPending;

  /// No description provided for @kitchenInProgress.
  ///
  /// In it, this message translates to:
  /// **'In preparazione'**
  String get kitchenInProgress;

  /// No description provided for @kitchenReady.
  ///
  /// In it, this message translates to:
  /// **'Pronto'**
  String get kitchenReady;

  /// No description provided for @kitchenItem.
  ///
  /// In it, this message translates to:
  /// **'Articolo'**
  String get kitchenItem;

  /// No description provided for @kitchenTable.
  ///
  /// In it, this message translates to:
  /// **'Tavolo'**
  String get kitchenTable;

  /// No description provided for @kitchenOrderNumber.
  ///
  /// In it, this message translates to:
  /// **'Ordine'**
  String get kitchenOrderNumber;

  /// No description provided for @kitchenSince.
  ///
  /// In it, this message translates to:
  /// **'Da'**
  String get kitchenSince;

  /// No description provided for @errorGeneric.
  ///
  /// In it, this message translates to:
  /// **'Si è verificato un errore. Riprova.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In it, this message translates to:
  /// **'Nessuna connessione internet.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In it, this message translates to:
  /// **'La richiesta ha impiegato troppo tempo. Riprova.'**
  String get errorTimeout;

  /// No description provided for @errorAuth.
  ///
  /// In it, this message translates to:
  /// **'Errore di autenticazione'**
  String get errorAuth;

  /// No description provided for @errorAuthInvalidCredentials.
  ///
  /// In it, this message translates to:
  /// **'Email o password non corretti.'**
  String get errorAuthInvalidCredentials;

  /// No description provided for @errorAuthEmailNotConfirmed.
  ///
  /// In it, this message translates to:
  /// **'Devi confermare la tua email prima di accedere.'**
  String get errorAuthEmailNotConfirmed;

  /// No description provided for @errorAuthAlreadyRegistered.
  ///
  /// In it, this message translates to:
  /// **'Esiste già un account con questa email.'**
  String get errorAuthAlreadyRegistered;

  /// No description provided for @errorAuthPasswordShort.
  ///
  /// In it, this message translates to:
  /// **'La password è troppo corta.'**
  String get errorAuthPasswordShort;

  /// No description provided for @errorAuthUserNotFound.
  ///
  /// In it, this message translates to:
  /// **'Nessun account trovato con questa email.'**
  String get errorAuthUserNotFound;

  /// No description provided for @errorAuthRateLimit.
  ///
  /// In it, this message translates to:
  /// **'Troppi tentativi. Riprova fra qualche minuto.'**
  String get errorAuthRateLimit;

  /// No description provided for @errorAuthGeneric.
  ///
  /// In it, this message translates to:
  /// **'Errore di autenticazione. Riprova.'**
  String get errorAuthGeneric;

  /// No description provided for @errorDbDuplicate.
  ///
  /// In it, this message translates to:
  /// **'Esiste già un elemento con questi dati.'**
  String get errorDbDuplicate;

  /// No description provided for @errorDbForeignKey.
  ///
  /// In it, this message translates to:
  /// **'Operazione non consentita: elemento collegato ad altri dati.'**
  String get errorDbForeignKey;

  /// No description provided for @errorDbNotNull.
  ///
  /// In it, this message translates to:
  /// **'Manca un campo obbligatorio.'**
  String get errorDbNotNull;

  /// No description provided for @errorDbPermission.
  ///
  /// In it, this message translates to:
  /// **'Non hai i permessi per questa operazione.'**
  String get errorDbPermission;

  /// No description provided for @errorDbNotFound.
  ///
  /// In it, this message translates to:
  /// **'Elemento non trovato.'**
  String get errorDbNotFound;

  /// No description provided for @errorDbGeneric.
  ///
  /// In it, this message translates to:
  /// **'Errore del server. Riprova fra poco.'**
  String get errorDbGeneric;

  /// No description provided for @errorStorageTooLarge.
  ///
  /// In it, this message translates to:
  /// **'File troppo grande.'**
  String get errorStorageTooLarge;

  /// No description provided for @errorStorageNotFound.
  ///
  /// In it, this message translates to:
  /// **'File non trovato.'**
  String get errorStorageNotFound;

  /// No description provided for @errorStorageNotAllowed.
  ///
  /// In it, this message translates to:
  /// **'Non puoi caricare questo file.'**
  String get errorStorageNotAllowed;

  /// No description provided for @errorStorageGeneric.
  ///
  /// In it, this message translates to:
  /// **'Errore caricamento file. Riprova.'**
  String get errorStorageGeneric;

  /// No description provided for @errorNotFound.
  ///
  /// In it, this message translates to:
  /// **'Non trovato'**
  String get errorNotFound;

  /// No description provided for @errorPermission.
  ///
  /// In it, this message translates to:
  /// **'Permesso negato'**
  String get errorPermission;

  /// No description provided for @settingsRestaurantName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get settingsRestaurantName;

  /// No description provided for @settingsLogo.
  ///
  /// In it, this message translates to:
  /// **'Logo'**
  String get settingsLogo;

  /// No description provided for @settingsCoverImage.
  ///
  /// In it, this message translates to:
  /// **'Immagine di copertina'**
  String get settingsCoverImage;

  /// No description provided for @settingsPhone.
  ///
  /// In it, this message translates to:
  /// **'Telefono'**
  String get settingsPhone;

  /// No description provided for @settingsEmail.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get settingsEmail;

  /// No description provided for @settingsHours.
  ///
  /// In it, this message translates to:
  /// **'Orari di apertura'**
  String get settingsHours;

  /// No description provided for @settingsAccount.
  ///
  /// In it, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsRole.
  ///
  /// In it, this message translates to:
  /// **'Ruolo'**
  String get settingsRole;

  /// No description provided for @usersHeader.
  ///
  /// In it, this message translates to:
  /// **'Utente'**
  String get usersHeader;

  /// No description provided for @usersEmail.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get usersEmail;

  /// No description provided for @usersRole.
  ///
  /// In it, this message translates to:
  /// **'Ruolo'**
  String get usersRole;

  /// No description provided for @usersStatus.
  ///
  /// In it, this message translates to:
  /// **'Stato'**
  String get usersStatus;

  /// No description provided for @usersLastLogin.
  ///
  /// In it, this message translates to:
  /// **'Ultimo accesso'**
  String get usersLastLogin;

  /// No description provided for @usersActions.
  ///
  /// In it, this message translates to:
  /// **'Azioni'**
  String get usersActions;

  /// No description provided for @usersNever.
  ///
  /// In it, this message translates to:
  /// **'Mai'**
  String get usersNever;

  /// No description provided for @usersAdd.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Utente'**
  String get usersAdd;

  /// No description provided for @usersDeactivate.
  ///
  /// In it, this message translates to:
  /// **'Disattiva'**
  String get usersDeactivate;

  /// No description provided for @usersActivate.
  ///
  /// In it, this message translates to:
  /// **'Attiva'**
  String get usersActivate;

  /// No description provided for @usersDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{name}\"?'**
  String usersDeleteConfirm(String name);

  /// No description provided for @usersDeletedToast.
  ///
  /// In it, this message translates to:
  /// **'Utente eliminato'**
  String get usersDeletedToast;

  /// No description provided for @kitchenDisplayTitle.
  ///
  /// In it, this message translates to:
  /// **'Display Cucina'**
  String get kitchenDisplayTitle;

  /// No description provided for @fixedMenuTitle.
  ///
  /// In it, this message translates to:
  /// **'Menu Fissi'**
  String get fixedMenuTitle;

  /// No description provided for @fixedMenuSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Gestisci i menu a prezzo fisso del ristorante'**
  String get fixedMenuSubtitle;

  /// No description provided for @fixedMenuAdd.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Menu Fisso'**
  String get fixedMenuAdd;

  /// No description provided for @fixedMenuEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun menu fisso'**
  String get fixedMenuEmpty;

  /// No description provided for @manualOrderSelectItems.
  ///
  /// In it, this message translates to:
  /// **'Seleziona articoli'**
  String get manualOrderSelectItems;

  /// No description provided for @manualOrderSubtotal.
  ///
  /// In it, this message translates to:
  /// **'Subtotale'**
  String get manualOrderSubtotal;

  /// No description provided for @manualOrderEmptyCart.
  ///
  /// In it, this message translates to:
  /// **'Nessun articolo selezionato'**
  String get manualOrderEmptyCart;

  /// No description provided for @orderDetailTitle.
  ///
  /// In it, this message translates to:
  /// **'Dettaglio Ordine'**
  String get orderDetailTitle;

  /// No description provided for @orderDetailItems.
  ///
  /// In it, this message translates to:
  /// **'Articoli'**
  String get orderDetailItems;

  /// No description provided for @orderDetailNotes.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get orderDetailNotes;

  /// No description provided for @orderDetailTotal.
  ///
  /// In it, this message translates to:
  /// **'Totale'**
  String get orderDetailTotal;

  /// No description provided for @orderDetailUpdateStatus.
  ///
  /// In it, this message translates to:
  /// **'Cambia stato'**
  String get orderDetailUpdateStatus;

  /// No description provided for @customerMenuChoose.
  ///
  /// In it, this message translates to:
  /// **'Scegli i tuoi piatti preferiti'**
  String get customerMenuChoose;

  /// No description provided for @customerMenuNoMenu.
  ///
  /// In it, this message translates to:
  /// **'Menu non disponibile'**
  String get customerMenuNoMenu;

  /// No description provided for @customerMenuNoItems.
  ///
  /// In it, this message translates to:
  /// **'Nessun piatto in questa categoria'**
  String get customerMenuNoItems;

  /// No description provided for @customerMenuNoFixed.
  ///
  /// In it, this message translates to:
  /// **'Nessun menu fisso disponibile'**
  String get customerMenuNoFixed;

  /// No description provided for @customerMenuFixedTab.
  ///
  /// In it, this message translates to:
  /// **'Menu Fissi'**
  String get customerMenuFixedTab;

  /// No description provided for @menuItemDialogNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Piatto'**
  String get menuItemDialogNew;

  /// No description provided for @menuItemDialogEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica Piatto'**
  String get menuItemDialogEdit;

  /// No description provided for @menuItemDialogName.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get menuItemDialogName;

  /// No description provided for @menuItemDialogCategory.
  ///
  /// In it, this message translates to:
  /// **'Categoria *'**
  String get menuItemDialogCategory;

  /// No description provided for @menuItemDialogDescription.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get menuItemDialogDescription;

  /// No description provided for @menuItemDialogDescriptionHint.
  ///
  /// In it, this message translates to:
  /// **'Descrizione del piatto...'**
  String get menuItemDialogDescriptionHint;

  /// No description provided for @menuItemDialogPrice.
  ///
  /// In it, this message translates to:
  /// **'Prezzo *'**
  String get menuItemDialogPrice;

  /// No description provided for @menuItemDialogPriceRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il prezzo'**
  String get menuItemDialogPriceRequired;

  /// No description provided for @menuItemDialogPriceInvalid.
  ///
  /// In it, this message translates to:
  /// **'Prezzo non valido'**
  String get menuItemDialogPriceInvalid;

  /// No description provided for @menuItemDialogPrepTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo prep. (min)'**
  String get menuItemDialogPrepTime;

  /// No description provided for @menuItemDialogCalories.
  ///
  /// In it, this message translates to:
  /// **'Calorie'**
  String get menuItemDialogCalories;

  /// No description provided for @menuItemDialogImage.
  ///
  /// In it, this message translates to:
  /// **'Immagine'**
  String get menuItemDialogImage;

  /// No description provided for @menuItemDialogUploadPhoto.
  ///
  /// In it, this message translates to:
  /// **'Carica foto'**
  String get menuItemDialogUploadPhoto;

  /// No description provided for @menuItemDialogChangePhoto.
  ///
  /// In it, this message translates to:
  /// **'Cambia foto'**
  String get menuItemDialogChangePhoto;

  /// No description provided for @menuItemDialogRemove.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get menuItemDialogRemove;

  /// No description provided for @menuItemDialogOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine'**
  String get menuItemDialogOrder;

  /// No description provided for @menuItemDialogTags.
  ///
  /// In it, this message translates to:
  /// **'Tag'**
  String get menuItemDialogTags;

  /// No description provided for @menuItemDialogAllergens.
  ///
  /// In it, this message translates to:
  /// **'Allergeni'**
  String get menuItemDialogAllergens;

  /// No description provided for @menuItemDialogAvailable.
  ///
  /// In it, this message translates to:
  /// **'Disponibile'**
  String get menuItemDialogAvailable;

  /// No description provided for @menuItemDialogActive.
  ///
  /// In it, this message translates to:
  /// **'Attivo'**
  String get menuItemDialogActive;

  /// No description provided for @menuItemDialogDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il piatto?'**
  String get menuItemDialogDeleteConfirm;

  /// No description provided for @menuItemDialogCreated.
  ///
  /// In it, this message translates to:
  /// **'Piatto creato'**
  String get menuItemDialogCreated;

  /// No description provided for @menuItemDialogUpdated.
  ///
  /// In it, this message translates to:
  /// **'Piatto aggiornato'**
  String get menuItemDialogUpdated;

  /// No description provided for @menuItemDialogDeleted.
  ///
  /// In it, this message translates to:
  /// **'Piatto eliminato'**
  String get menuItemDialogDeleted;

  /// No description provided for @menuItemDialogSelectCategoryFirst.
  ///
  /// In it, this message translates to:
  /// **'Seleziona una categoria'**
  String get menuItemDialogSelectCategoryFirst;

  /// No description provided for @categoryDialogNew.
  ///
  /// In it, this message translates to:
  /// **'Nuova categoria'**
  String get categoryDialogNew;

  /// No description provided for @categoryDialogEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica categoria'**
  String get categoryDialogEdit;

  /// No description provided for @categoryDialogName.
  ///
  /// In it, this message translates to:
  /// **'Nome categoria'**
  String get categoryDialogName;

  /// No description provided for @categoryDialogDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la categoria?'**
  String get categoryDialogDeleteConfirm;

  /// No description provided for @analyticsPeriod.
  ///
  /// In it, this message translates to:
  /// **'Periodo:'**
  String get analyticsPeriod;

  /// No description provided for @analyticsRefresh.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna dati'**
  String get analyticsRefresh;

  /// No description provided for @analyticsCompletedOrders.
  ///
  /// In it, this message translates to:
  /// **'Ordini Completati'**
  String get analyticsCompletedOrders;

  /// No description provided for @analyticsAvgTicket.
  ///
  /// In it, this message translates to:
  /// **'Scontrino Medio'**
  String get analyticsAvgTicket;

  /// No description provided for @analyticsItemsSold.
  ///
  /// In it, this message translates to:
  /// **'Piatti Venduti'**
  String get analyticsItemsSold;

  /// No description provided for @analyticsRevenueTrend.
  ///
  /// In it, this message translates to:
  /// **'Andamento Ricavi'**
  String get analyticsRevenueTrend;

  /// No description provided for @analyticsOrdersByStatus.
  ///
  /// In it, this message translates to:
  /// **'Ordini per Stato'**
  String get analyticsOrdersByStatus;

  /// No description provided for @analyticsTopItems.
  ///
  /// In it, this message translates to:
  /// **'Piatti Più Venduti'**
  String get analyticsTopItems;

  /// No description provided for @analyticsPeakHours.
  ///
  /// In it, this message translates to:
  /// **'Ore di Punta'**
  String get analyticsPeakHours;

  /// No description provided for @analyticsByCategory.
  ///
  /// In it, this message translates to:
  /// **'Per Categoria'**
  String get analyticsByCategory;

  /// No description provided for @tableDialogNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Tavolo'**
  String get tableDialogNew;

  /// No description provided for @tableDialogEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica Tavolo'**
  String get tableDialogEdit;

  /// No description provided for @tableDialogName.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get tableDialogName;

  /// No description provided for @tableDialogSeats.
  ///
  /// In it, this message translates to:
  /// **'Posti *'**
  String get tableDialogSeats;

  /// No description provided for @tableDialogSeatsRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci i posti'**
  String get tableDialogSeatsRequired;

  /// No description provided for @tableDialogInvalidNumber.
  ///
  /// In it, this message translates to:
  /// **'Valore non valido'**
  String get tableDialogInvalidNumber;

  /// No description provided for @tableDialogZone.
  ///
  /// In it, this message translates to:
  /// **'Zona'**
  String get tableDialogZone;

  /// No description provided for @tableDialogState.
  ///
  /// In it, this message translates to:
  /// **'Stato'**
  String get tableDialogState;

  /// No description provided for @tableDialogActive.
  ///
  /// In it, this message translates to:
  /// **'Attivo'**
  String get tableDialogActive;

  /// No description provided for @tableDialogActiveSub.
  ///
  /// In it, this message translates to:
  /// **'Visibile e utilizzabile'**
  String get tableDialogActiveSub;

  /// No description provided for @tableDialogQrCode.
  ///
  /// In it, this message translates to:
  /// **'Codice QR'**
  String get tableDialogQrCode;

  /// No description provided for @tableDialogCreated.
  ///
  /// In it, this message translates to:
  /// **'Tavolo creato'**
  String get tableDialogCreated;

  /// No description provided for @tableDialogUpdated.
  ///
  /// In it, this message translates to:
  /// **'Tavolo aggiornato'**
  String get tableDialogUpdated;

  /// No description provided for @tableDialogDeleted.
  ///
  /// In it, this message translates to:
  /// **'Tavolo eliminato'**
  String get tableDialogDeleted;

  /// No description provided for @tableDialogCreate.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get tableDialogCreate;

  /// No description provided for @categoryDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica Categoria'**
  String get categoryDialogEditTitle;

  /// No description provided for @categoryDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova Categoria'**
  String get categoryDialogNewTitle;

  /// No description provided for @categoryDialogNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get categoryDialogNameLabel;

  /// No description provided for @categoryDialogDescription.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get categoryDialogDescription;

  /// No description provided for @categoryDialogDescriptionHint.
  ///
  /// In it, this message translates to:
  /// **'Descrizione opzionale...'**
  String get categoryDialogDescriptionHint;

  /// No description provided for @categoryDialogOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine'**
  String get categoryDialogOrder;

  /// No description provided for @categoryDialogActive.
  ///
  /// In it, this message translates to:
  /// **'Attiva'**
  String get categoryDialogActive;

  /// No description provided for @categoryDialogActiveSub.
  ///
  /// In it, this message translates to:
  /// **'Visibile nel menu'**
  String get categoryDialogActiveSub;

  /// No description provided for @categoryDialogCreated.
  ///
  /// In it, this message translates to:
  /// **'Categoria creata'**
  String get categoryDialogCreated;

  /// No description provided for @categoryDialogUpdated.
  ///
  /// In it, this message translates to:
  /// **'Categoria aggiornata'**
  String get categoryDialogUpdated;

  /// No description provided for @categoryDialogDeleted.
  ///
  /// In it, this message translates to:
  /// **'Categoria eliminata'**
  String get categoryDialogDeleted;

  /// No description provided for @categoryDialogDeleteWarn.
  ///
  /// In it, this message translates to:
  /// **'Attenzione: tutti i piatti in questa categoria dovranno essere riassegnati.'**
  String get categoryDialogDeleteWarn;

  /// No description provided for @userDialogNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Utente'**
  String get userDialogNew;

  /// No description provided for @userDialogEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica Utente'**
  String get userDialogEdit;

  /// No description provided for @userDialogFirstName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get userDialogFirstName;

  /// No description provided for @userDialogLastName.
  ///
  /// In it, this message translates to:
  /// **'Cognome'**
  String get userDialogLastName;

  /// No description provided for @userDialogEmail.
  ///
  /// In it, this message translates to:
  /// **'Email *'**
  String get userDialogEmail;

  /// No description provided for @userDialogEmailInvalid.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un\'email valida'**
  String get userDialogEmailInvalid;

  /// No description provided for @userDialogPassword.
  ///
  /// In it, this message translates to:
  /// **'Password *'**
  String get userDialogPassword;

  /// No description provided for @userDialogPasswordHint.
  ///
  /// In it, this message translates to:
  /// **'Minimo 6 caratteri'**
  String get userDialogPasswordHint;

  /// No description provided for @userDialogRole.
  ///
  /// In it, this message translates to:
  /// **'Ruolo *'**
  String get userDialogRole;

  /// No description provided for @userDialogActive.
  ///
  /// In it, this message translates to:
  /// **'Utente attivo'**
  String get userDialogActive;

  /// No description provided for @userDialogActiveSubtitle.
  ///
  /// In it, this message translates to:
  /// **'L\'utente può accedere al sistema'**
  String get userDialogActiveSubtitle;

  /// No description provided for @userDialogInactiveSubtitle.
  ///
  /// In it, this message translates to:
  /// **'L\'utente non può accedere'**
  String get userDialogInactiveSubtitle;

  /// No description provided for @userDialogCreate.
  ///
  /// In it, this message translates to:
  /// **'Crea Utente'**
  String get userDialogCreate;

  /// No description provided for @userDialogCreated.
  ///
  /// In it, this message translates to:
  /// **'Utente creato con successo'**
  String get userDialogCreated;

  /// No description provided for @userDialogUpdated.
  ///
  /// In it, this message translates to:
  /// **'Utente aggiornato'**
  String get userDialogUpdated;

  /// No description provided for @userDialogEmailExists.
  ///
  /// In it, this message translates to:
  /// **'Questa email è già registrata'**
  String get userDialogEmailExists;

  /// No description provided for @userDialogRoleAdmin.
  ///
  /// In it, this message translates to:
  /// **'Amministratore'**
  String get userDialogRoleAdmin;

  /// No description provided for @userDialogRoleManager.
  ///
  /// In it, this message translates to:
  /// **'Manager'**
  String get userDialogRoleManager;

  /// No description provided for @userDialogRoleWaiter.
  ///
  /// In it, this message translates to:
  /// **'Cameriere'**
  String get userDialogRoleWaiter;

  /// No description provided for @userDialogRoleKitchen.
  ///
  /// In it, this message translates to:
  /// **'Cucina'**
  String get userDialogRoleKitchen;

  /// No description provided for @userDialogRoleAdminDesc.
  ///
  /// In it, this message translates to:
  /// **'Accesso completo: gestione menu, tavoli, ordini, utenti e impostazioni.'**
  String get userDialogRoleAdminDesc;

  /// No description provided for @userDialogRoleManagerDesc.
  ///
  /// In it, this message translates to:
  /// **'Gestione menu, tavoli e ordini. Non può gestire utenti e impostazioni.'**
  String get userDialogRoleManagerDesc;

  /// No description provided for @userDialogRoleWaiterDesc.
  ///
  /// In it, this message translates to:
  /// **'Può visualizzare e gestire solo gli ordini. Ideale per camerieri.'**
  String get userDialogRoleWaiterDesc;

  /// No description provided for @userDialogRoleKitchenDesc.
  ///
  /// In it, this message translates to:
  /// **'Visualizza solo gli ordini da preparare. Ideale per il personale di cucina.'**
  String get userDialogRoleKitchenDesc;

  /// No description provided for @dayMon.
  ///
  /// In it, this message translates to:
  /// **'Lun'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In it, this message translates to:
  /// **'Mar'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In it, this message translates to:
  /// **'Mer'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In it, this message translates to:
  /// **'Gio'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In it, this message translates to:
  /// **'Ven'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In it, this message translates to:
  /// **'Sab'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In it, this message translates to:
  /// **'Dom'**
  String get daySun;

  /// No description provided for @fixedMenuDialogNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Menu Fisso'**
  String get fixedMenuDialogNew;

  /// No description provided for @fixedMenuDialogEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica Menu'**
  String get fixedMenuDialogEdit;

  /// No description provided for @fixedMenuDialogName.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get fixedMenuDialogName;

  /// No description provided for @fixedMenuDialogNameRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il nome'**
  String get fixedMenuDialogNameRequired;

  /// No description provided for @fixedMenuDialogDescription.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get fixedMenuDialogDescription;

  /// No description provided for @fixedMenuDialogDescriptionHint.
  ///
  /// In it, this message translates to:
  /// **'Descrizione opzionale del menu'**
  String get fixedMenuDialogDescriptionHint;

  /// No description provided for @fixedMenuDialogPrice.
  ///
  /// In it, this message translates to:
  /// **'Prezzo *'**
  String get fixedMenuDialogPrice;

  /// No description provided for @fixedMenuDialogPriceRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il prezzo'**
  String get fixedMenuDialogPriceRequired;

  /// No description provided for @fixedMenuDialogPriceInvalid.
  ///
  /// In it, this message translates to:
  /// **'Prezzo non valido'**
  String get fixedMenuDialogPriceInvalid;

  /// No description provided for @fixedMenuDialogAvailability.
  ///
  /// In it, this message translates to:
  /// **'Disponibilità'**
  String get fixedMenuDialogAvailability;

  /// No description provided for @fixedMenuDialogAlways.
  ///
  /// In it, this message translates to:
  /// **'Sempre'**
  String get fixedMenuDialogAlways;

  /// No description provided for @fixedMenuDialogLunch.
  ///
  /// In it, this message translates to:
  /// **'Pranzo'**
  String get fixedMenuDialogLunch;

  /// No description provided for @fixedMenuDialogDinner.
  ///
  /// In it, this message translates to:
  /// **'Cena'**
  String get fixedMenuDialogDinner;

  /// No description provided for @fixedMenuDialogDays.
  ///
  /// In it, this message translates to:
  /// **'Giorni (lascia vuoto per tutti)'**
  String get fixedMenuDialogDays;

  /// No description provided for @fixedMenuDialogActive.
  ///
  /// In it, this message translates to:
  /// **'Menu Attivo'**
  String get fixedMenuDialogActive;

  /// No description provided for @fixedMenuDialogActiveSub.
  ///
  /// In it, this message translates to:
  /// **'Visibile ai clienti'**
  String get fixedMenuDialogActiveSub;

  /// No description provided for @fixedMenuDialogCreated.
  ///
  /// In it, this message translates to:
  /// **'Menu creato'**
  String get fixedMenuDialogCreated;

  /// No description provided for @fixedMenuDialogUpdated.
  ///
  /// In it, this message translates to:
  /// **'Menu aggiornato'**
  String get fixedMenuDialogUpdated;

  /// No description provided for @fixedMenuDialogDeleted.
  ///
  /// In it, this message translates to:
  /// **'Menu eliminato'**
  String get fixedMenuDialogDeleted;

  /// No description provided for @fixedMenuDialogDeleteWarn.
  ///
  /// In it, this message translates to:
  /// **'Questa azione eliminerà anche tutte le portate e scelte associate.'**
  String get fixedMenuDialogDeleteWarn;

  /// No description provided for @fixedMenuDialogDeleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Elimina Menu'**
  String get fixedMenuDialogDeleteTitle;

  /// No description provided for @fixedMenuDialogDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare \"{name}\"?'**
  String fixedMenuDialogDeleteConfirm(String name);

  /// No description provided for @fixedMenuDialogImageUrl.
  ///
  /// In it, this message translates to:
  /// **'URL Immagine'**
  String get fixedMenuDialogImageUrl;

  /// No description provided for @fixedMenuCoursesTitle.
  ///
  /// In it, this message translates to:
  /// **'Gestisci portate e scelte'**
  String get fixedMenuCoursesTitle;

  /// No description provided for @fixedMenuCoursesAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Portata'**
  String get fixedMenuCoursesAdd;

  /// No description provided for @fixedMenuCoursesEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna portata'**
  String get fixedMenuCoursesEmpty;

  /// No description provided for @fixedMenuCoursesEmptyHint.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi portate come Primo, Secondo, Dolce...'**
  String get fixedMenuCoursesEmptyHint;

  /// No description provided for @fixedMenuCoursesDeleteConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{name}\" e tutte le sue scelte?'**
  String fixedMenuCoursesDeleteConfirm(String name);

  /// No description provided for @fixedMenuCoursesRequired.
  ///
  /// In it, this message translates to:
  /// **'Obbligatorio'**
  String get fixedMenuCoursesRequired;

  /// No description provided for @fixedMenuCoursesDeleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Elimina Portata'**
  String get fixedMenuCoursesDeleteTitle;

  /// No description provided for @fixedMenuCoursesChoicesAvailable.
  ///
  /// In it, this message translates to:
  /// **'{count} scelte disponibili'**
  String fixedMenuCoursesChoicesAvailable(int count);

  /// No description provided for @fixedMenuCoursesEditCourse.
  ///
  /// In it, this message translates to:
  /// **'Modifica Portata'**
  String get fixedMenuCoursesEditCourse;

  /// No description provided for @fixedMenuCoursesNewCourse.
  ///
  /// In it, this message translates to:
  /// **'Nuova Portata'**
  String get fixedMenuCoursesNewCourse;

  /// No description provided for @fixedMenuCoursesNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get fixedMenuCoursesNameLabel;

  /// No description provided for @fixedMenuCoursesNameHint.
  ///
  /// In it, this message translates to:
  /// **'es. Primo, Secondo, Dolce'**
  String get fixedMenuCoursesNameHint;

  /// No description provided for @fixedMenuCoursesDescription.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get fixedMenuCoursesDescription;

  /// No description provided for @fixedMenuCoursesDescriptionHint.
  ///
  /// In it, this message translates to:
  /// **'Descrizione opzionale'**
  String get fixedMenuCoursesDescriptionHint;

  /// No description provided for @fixedMenuCoursesRequiredToggle.
  ///
  /// In it, this message translates to:
  /// **'Selezione obbligatoria'**
  String get fixedMenuCoursesRequiredToggle;

  /// No description provided for @fixedMenuCoursesRequiredToggleSub.
  ///
  /// In it, this message translates to:
  /// **'Il cliente deve scegliere'**
  String get fixedMenuCoursesRequiredToggleSub;

  /// No description provided for @fixedMenuChoicesAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Scelta'**
  String get fixedMenuChoicesAdd;

  /// No description provided for @fixedMenuChoicesEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scelta. Aggiungi piatti dal menu.'**
  String get fixedMenuChoicesEmpty;

  /// No description provided for @fixedMenuChoicesRemove.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get fixedMenuChoicesRemove;

  /// No description provided for @fixedMenuChoicesSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca piatto...'**
  String get fixedMenuChoicesSearchHint;

  /// No description provided for @fixedMenuChoicesNoItemsAvailable.
  ///
  /// In it, this message translates to:
  /// **'Nessun piatto disponibile'**
  String get fixedMenuChoicesNoItemsAvailable;

  /// No description provided for @fixedMenuChoicesSupplement.
  ///
  /// In it, this message translates to:
  /// **'Supplemento'**
  String get fixedMenuChoicesSupplement;

  /// No description provided for @fixedMenuChoicesDefault.
  ///
  /// In it, this message translates to:
  /// **'Predefinito'**
  String get fixedMenuChoicesDefault;

  /// No description provided for @fixedMenuChoicesAddBtn.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi'**
  String get fixedMenuChoicesAddBtn;

  /// No description provided for @tooltipEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get tooltipEdit;

  /// No description provided for @tooltipDelete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get tooltipDelete;

  /// No description provided for @fixedMenuCardChooseCourses.
  ///
  /// In it, this message translates to:
  /// **'Scegli le portate'**
  String get fixedMenuCardChooseCourses;

  /// No description provided for @fixedMenuSelectionMenuNotFound.
  ///
  /// In it, this message translates to:
  /// **'Menu non trovato'**
  String get fixedMenuSelectionMenuNotFound;

  /// No description provided for @fixedMenuSelectionSelectAllRequired.
  ///
  /// In it, this message translates to:
  /// **'Seleziona tutte le portate obbligatorie'**
  String get fixedMenuSelectionSelectAllRequired;

  /// No description provided for @fixedMenuSelectionAddToCart.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi al carrello - €{price}'**
  String fixedMenuSelectionAddToCart(String price);

  /// No description provided for @fixedMenuSelectionOptional.
  ///
  /// In it, this message translates to:
  /// **'Opzionale'**
  String get fixedMenuSelectionOptional;

  /// No description provided for @fixedMenuSelectionNoChoices.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scelta disponibile per questa portata'**
  String get fixedMenuSelectionNoChoices;

  /// No description provided for @fixedMenuSelectionRecommended.
  ///
  /// In it, this message translates to:
  /// **'Scelta consigliata'**
  String get fixedMenuSelectionRecommended;

  /// No description provided for @fixedMenuSelectionAddedToCart.
  ///
  /// In it, this message translates to:
  /// **'{name} aggiunto al carrello'**
  String fixedMenuSelectionAddedToCart(String name);

  /// No description provided for @editAddressTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica indirizzo'**
  String get editAddressTitle;

  /// No description provided for @editAddressUseMyLocation.
  ///
  /// In it, this message translates to:
  /// **'Usa la mia posizione'**
  String get editAddressUseMyLocation;

  /// No description provided for @editAddressLocating.
  ///
  /// In it, this message translates to:
  /// **'Localizzazione...'**
  String get editAddressLocating;

  /// No description provided for @editAddressPermissionDenied.
  ///
  /// In it, this message translates to:
  /// **'Permesso negato. Inserisci manualmente l\'indirizzo.'**
  String get editAddressPermissionDenied;

  /// No description provided for @editAddressUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Posizione non disponibile: {message}'**
  String editAddressUnavailable(String message);

  /// No description provided for @editAddressReverseFail.
  ///
  /// In it, this message translates to:
  /// **'Impossibile leggere l\'indirizzo. Riprova o inseriscilo manualmente.'**
  String get editAddressReverseFail;

  /// No description provided for @editAddressRequired.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un indirizzo'**
  String get editAddressRequired;

  /// No description provided for @editAddressUpdatedGeo.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo aggiornato e geolocalizzato'**
  String get editAddressUpdatedGeo;

  /// No description provided for @editAddressSavedNoGeo.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo salvato (geolocalizzazione non riuscita)'**
  String get editAddressSavedNoGeo;

  /// No description provided for @editAddressLabel.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo completo'**
  String get editAddressLabel;

  /// No description provided for @editAddressHint.
  ///
  /// In it, this message translates to:
  /// **'Via Roma 5, 20121 Milano'**
  String get editAddressHint;

  /// No description provided for @editAddressFormatHelp.
  ///
  /// In it, this message translates to:
  /// **'Formato: via + numero, CAP + città. Le coordinate vengono calcolate al salvataggio.'**
  String get editAddressFormatHelp;

  /// No description provided for @settingsNotConfigured.
  ///
  /// In it, this message translates to:
  /// **'Non configurato'**
  String get settingsNotConfigured;

  /// No description provided for @settingsLoadingError.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento'**
  String get settingsLoadingError;

  /// No description provided for @settingsNotificationsOrders.
  ///
  /// In it, this message translates to:
  /// **'Notifiche ordini'**
  String get settingsNotificationsOrders;

  /// No description provided for @settingsNotificationsOrdersSub.
  ///
  /// In it, this message translates to:
  /// **'Ricevi notifiche per nuovi ordini'**
  String get settingsNotificationsOrdersSub;

  /// No description provided for @settingsSoundAlertsTitle.
  ///
  /// In it, this message translates to:
  /// **'Suoni di avviso'**
  String get settingsSoundAlertsTitle;

  /// No description provided for @settingsSoundAlertsSub.
  ///
  /// In it, this message translates to:
  /// **'Riproduci un suono per le notifiche'**
  String get settingsSoundAlertsSub;

  /// No description provided for @settingsVibrationTitle.
  ///
  /// In it, this message translates to:
  /// **'Vibrazione'**
  String get settingsVibrationTitle;

  /// No description provided for @settingsVibrationSub.
  ///
  /// In it, this message translates to:
  /// **'Vibra per le notifiche (mobile)'**
  String get settingsVibrationSub;

  /// No description provided for @settingsVibrationSubShort.
  ///
  /// In it, this message translates to:
  /// **'Vibra per le notifiche'**
  String get settingsVibrationSubShort;

  /// No description provided for @settingsOrdersManagement.
  ///
  /// In it, this message translates to:
  /// **'Gestione Ordini'**
  String get settingsOrdersManagement;

  /// No description provided for @settingsAutoConfirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma automatica'**
  String get settingsAutoConfirm;

  /// No description provided for @settingsAutoConfirmSub.
  ///
  /// In it, this message translates to:
  /// **'Conferma automaticamente i nuovi ordini'**
  String get settingsAutoConfirmSub;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In it, this message translates to:
  /// **'Conferma Logout'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutConfirm.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler uscire?'**
  String get settingsSignOutConfirm;

  /// No description provided for @settingsNotificationSound.
  ///
  /// In it, this message translates to:
  /// **'Suono notifica'**
  String get settingsNotificationSound;

  /// No description provided for @settingsPasswordMinChars.
  ///
  /// In it, this message translates to:
  /// **'Minimo 6 caratteri'**
  String get settingsPasswordMinChars;

  /// No description provided for @settingsPasswordUpdated.
  ///
  /// In it, this message translates to:
  /// **'Password aggiornata con successo'**
  String get settingsPasswordUpdated;

  /// No description provided for @settingsNewPassword.
  ///
  /// In it, this message translates to:
  /// **'Nuova password'**
  String get settingsNewPassword;

  /// No description provided for @settingsConfirmPassword.
  ///
  /// In it, this message translates to:
  /// **'Conferma password'**
  String get settingsConfirmPassword;

  /// No description provided for @settingsPasswordMismatch.
  ///
  /// In it, this message translates to:
  /// **'Le password non coincidono'**
  String get settingsPasswordMismatch;

  /// No description provided for @settingsColorsSaved.
  ///
  /// In it, this message translates to:
  /// **'Colori salvati con successo'**
  String get settingsColorsSaved;

  /// No description provided for @settingsSaveError.
  ///
  /// In it, this message translates to:
  /// **'Errore nel salvataggio: {message}'**
  String settingsSaveError(String message);

  /// No description provided for @settingsPrimaryColorHint.
  ///
  /// In it, this message translates to:
  /// **'Il colore principale del brand'**
  String get settingsPrimaryColorHint;

  /// No description provided for @settingsSecondaryColorHint.
  ///
  /// In it, this message translates to:
  /// **'Colore per accenti e dettagli'**
  String get settingsSecondaryColorHint;

  /// No description provided for @settingsBackgroundColorHint.
  ///
  /// In it, this message translates to:
  /// **'Sfondo delle pagine (tema chiaro)'**
  String get settingsBackgroundColorHint;

  /// No description provided for @settingsAccent.
  ///
  /// In it, this message translates to:
  /// **'Accento'**
  String get settingsAccent;

  /// No description provided for @settingsSaveColors.
  ///
  /// In it, this message translates to:
  /// **'Salva Colori'**
  String get settingsSaveColors;

  /// No description provided for @settingsStripeOnboardingTitle.
  ///
  /// In it, this message translates to:
  /// **'Configura Stripe'**
  String get settingsStripeOnboardingTitle;

  /// No description provided for @settingsStripeOnboardingBody.
  ///
  /// In it, this message translates to:
  /// **'Apri questo link per completare la configurazione:\n\n{url}'**
  String settingsStripeOnboardingBody(String url);

  /// No description provided for @settingsDeliverySaved.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni consegna salvate'**
  String get settingsDeliverySaved;

  /// No description provided for @settingsEnableDelivery.
  ///
  /// In it, this message translates to:
  /// **'Abilita consegne'**
  String get settingsEnableDelivery;

  /// No description provided for @settingsEnableDeliverySub.
  ///
  /// In it, this message translates to:
  /// **'Il ristorante apparirà nel marketplace per le consegne a domicilio'**
  String get settingsEnableDeliverySub;

  /// No description provided for @settingsEnableDeliverySubShort.
  ///
  /// In it, this message translates to:
  /// **'Appari nel marketplace'**
  String get settingsEnableDeliverySubShort;

  /// No description provided for @settingsVacation.
  ///
  /// In it, this message translates to:
  /// **'In vacanza'**
  String get settingsVacation;

  /// No description provided for @settingsVacationSub.
  ///
  /// In it, this message translates to:
  /// **'Sospende temporaneamente la ricezione di ordini'**
  String get settingsVacationSub;

  /// No description provided for @settingsVacationSubShort.
  ///
  /// In it, this message translates to:
  /// **'Sospende gli ordini'**
  String get settingsVacationSubShort;

  /// No description provided for @settingsDeliveryCost.
  ///
  /// In it, this message translates to:
  /// **'Costo consegna'**
  String get settingsDeliveryCost;

  /// No description provided for @settingsDeliveryMinOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine minimo'**
  String get settingsDeliveryMinOrder;

  /// No description provided for @settingsDeliveryRadiusLabel.
  ///
  /// In it, this message translates to:
  /// **'Raggio consegna'**
  String get settingsDeliveryRadiusLabel;

  /// No description provided for @settingsDeliveryEtaLabel.
  ///
  /// In it, this message translates to:
  /// **'Tempo stimato'**
  String get settingsDeliveryEtaLabel;

  /// No description provided for @settingsStripeNotConfigured.
  ///
  /// In it, this message translates to:
  /// **'Stripe non configurato'**
  String get settingsStripeNotConfigured;

  /// No description provided for @settingsStripeNotConnectedSub.
  ///
  /// In it, this message translates to:
  /// **' — necessario per ricevere pagamenti'**
  String get settingsStripeNotConnectedSub;

  /// No description provided for @settingsStripeConfigure.
  ///
  /// In it, this message translates to:
  /// **'Configura'**
  String get settingsStripeConfigure;

  /// No description provided for @settingsGeoFail.
  ///
  /// In it, this message translates to:
  /// **'Geocodifica fallita. Verifica che l\'indirizzo sia corretto e completo.'**
  String get settingsGeoFail;

  /// No description provided for @settingsGeoFailShort.
  ///
  /// In it, this message translates to:
  /// **'Geocodifica fallita. Verifica l\'indirizzo.'**
  String get settingsGeoFailShort;

  /// No description provided for @settingsGeoSuccess.
  ///
  /// In it, this message translates to:
  /// **'Geolocalizzazione completata'**
  String get settingsGeoSuccess;

  /// No description provided for @settingsNotGeolocated.
  ///
  /// In it, this message translates to:
  /// **'Ristorante non geolocalizzato'**
  String get settingsNotGeolocated;

  /// No description provided for @settingsNotGeolocatedShort.
  ///
  /// In it, this message translates to:
  /// **'Non geolocalizzato'**
  String get settingsNotGeolocatedShort;

  /// No description provided for @settingsSetAddress.
  ///
  /// In it, this message translates to:
  /// **'Imposta indirizzo'**
  String get settingsSetAddress;

  /// No description provided for @settingsGeoMissingHint.
  ///
  /// In it, this message translates to:
  /// **'Senza coordinate il ristorante non comparirà nel marketplace dei clienti. Riprova la geocodifica o modifica l\'indirizzo.'**
  String get settingsGeoMissingHint;

  /// No description provided for @settingsGeoAddressFirst.
  ///
  /// In it, this message translates to:
  /// **'Imposta prima l\'indirizzo del ristorante: serve per calcolare le distanze nel marketplace.'**
  String get settingsGeoAddressFirst;

  /// No description provided for @settingsChangePassword.
  ///
  /// In it, this message translates to:
  /// **'Cambia password'**
  String get settingsChangePassword;

  /// No description provided for @settingsManageCodes.
  ///
  /// In it, this message translates to:
  /// **'Gestisci codici'**
  String get settingsManageCodes;

  /// No description provided for @settingsVersion.
  ///
  /// In it, this message translates to:
  /// **'Versione {value}'**
  String settingsVersion(String value);

  /// No description provided for @settingsRestaurantInfo.
  ///
  /// In it, this message translates to:
  /// **'Informazioni Ristorante'**
  String get settingsRestaurantInfo;

  /// No description provided for @settingsTheme.
  ///
  /// In it, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLightShort.
  ///
  /// In it, this message translates to:
  /// **'Chiaro'**
  String get settingsThemeLightShort;

  /// No description provided for @settingsThemeDarkShort.
  ///
  /// In it, this message translates to:
  /// **'Scuro'**
  String get settingsThemeDarkShort;

  /// No description provided for @settingsThemeSystemShort.
  ///
  /// In it, this message translates to:
  /// **'Sistema'**
  String get settingsThemeSystemShort;

  /// No description provided for @settingsCuisineType.
  ///
  /// In it, this message translates to:
  /// **'Tipo di cucina'**
  String get settingsCuisineType;

  /// No description provided for @settingsDietaryTags.
  ///
  /// In it, this message translates to:
  /// **'Tag alimentari'**
  String get settingsDietaryTags;

  /// No description provided for @settingsDietaryTagsHint.
  ///
  /// In it, this message translates to:
  /// **'Mostrati come filtri nel marketplace.'**
  String get settingsDietaryTagsHint;

  /// No description provided for @settingsSaved.
  ///
  /// In it, this message translates to:
  /// **'Salvato'**
  String get settingsSaved;

  /// No description provided for @settingsSaving.
  ///
  /// In it, this message translates to:
  /// **'Salvataggio...'**
  String get settingsSaving;

  /// No description provided for @settingsNoTenantError.
  ///
  /// In it, this message translates to:
  /// **'Errore: nessun ristorante associato'**
  String get settingsNoTenantError;

  /// No description provided for @settingsRetryGeocoding.
  ///
  /// In it, this message translates to:
  /// **'Riprova geocodifica'**
  String get settingsRetryGeocoding;

  /// No description provided for @settingsSoundClassic.
  ///
  /// In it, this message translates to:
  /// **'Classico'**
  String get settingsSoundClassic;

  /// No description provided for @settingsSoundBell.
  ///
  /// In it, this message translates to:
  /// **'Campanello'**
  String get settingsSoundBell;

  /// No description provided for @settingsSoundChime.
  ///
  /// In it, this message translates to:
  /// **'Chime'**
  String get settingsSoundChime;

  /// No description provided for @analyticsTotalRevenue.
  ///
  /// In it, this message translates to:
  /// **'Ricavi Totali'**
  String get analyticsTotalRevenue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
