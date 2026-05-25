// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'SubitoGusto';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonLoading => 'Caricamento...';

  @override
  String get commonError => 'Si è verificato un errore. Riprova.';

  @override
  String get commonYes => 'Sì';

  @override
  String get commonNo => 'No';

  @override
  String get commonNew => 'Nuovo';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonRemove => 'Rimuovi';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonNext => 'Avanti';

  @override
  String get commonContinue => 'Continua';

  @override
  String get commonConfirm => 'Conferma';

  @override
  String get commonShow => 'Mostra';

  @override
  String get commonSearch => 'Cerca';

  @override
  String get commonHere => 'Qui';

  @override
  String get commonAll => 'Tutti';

  @override
  String get commonAny => 'Qualsiasi';

  @override
  String get consumerLoginTitle => 'Bentornato';

  @override
  String get consumerLoginSubtitle => 'Accedi per ordinare';

  @override
  String get consumerLoginEmailLabel => 'Email';

  @override
  String get consumerLoginPasswordLabel => 'Password';

  @override
  String get consumerLoginSubmit => 'Accedi';

  @override
  String get consumerLoginNoAccount => 'Non hai un account?';

  @override
  String get consumerLoginSignUp => 'Registrati';

  @override
  String get consumerLoginStaffPrompt => 'Sei uno staff?';

  @override
  String get consumerLoginStaffLink => 'Accedi qui';

  @override
  String get consumerLoginContinueWith => 'oppure continua con';

  @override
  String get consumerLoginGoogle => 'Continua con Google';

  @override
  String get consumerLoginApple => 'Continua con Apple';

  @override
  String get consumerRegisterTitle => 'Crea il tuo account';

  @override
  String get consumerRegisterSubtitle =>
      'Registrati per ordinare in pochi click';

  @override
  String get consumerRegisterNameLabel => 'Nome';

  @override
  String get consumerRegisterEmailLabel => 'Email';

  @override
  String get consumerRegisterPasswordLabel => 'Password';

  @override
  String get consumerRegisterPasswordHint => 'Minimo 8 caratteri';

  @override
  String get consumerRegisterSubmit => 'Crea account';

  @override
  String get consumerRegisterHaveAccount => 'Hai già un account?';

  @override
  String get consumerRegisterSignIn => 'Accedi';

  @override
  String get consumerRegisterSuccess =>
      'Registrazione completata! Effettua il login.';

  @override
  String get consumerRegisterStaffPrompt => 'Sei uno staff?';

  @override
  String get consumerRegisterStaffLink => 'Vai al login staff';

  @override
  String get consumerRegisterTagline =>
      'Ordina a domicilio\ndai migliori ristoranti';

  @override
  String get consumerRegisterConfirmPasswordLabel => 'Conferma password';

  @override
  String get consumerRegisterPasswordMismatch =>
      'Le password non corrispondono';

  @override
  String get consumerRegisterOwnerPrompt => 'Sei un ristoratore?';

  @override
  String get consumerRegisterOwnerLink => 'Accedi qui';

  @override
  String get consumerRegisterErrorAlreadyRegistered =>
      'Questa email è già registrata. Prova ad accedere.';

  @override
  String get consumerRegisterErrorGeneric =>
      'Errore durante la registrazione. Riprova.';

  @override
  String get validationRequired => 'Campo obbligatorio';

  @override
  String get validationEmail => 'Email non valida';

  @override
  String get validationPasswordMin =>
      'La password deve avere almeno 8 caratteri';

  @override
  String get navMarketplace => 'Ristoranti';

  @override
  String get navFavorites => 'Preferiti';

  @override
  String get navOrders => 'Ordini';

  @override
  String get navProfile => 'Profilo';

  @override
  String get marketplaceSearchHint => 'Cerca ristoranti...';

  @override
  String get marketplaceEmpty => 'Nessun ristorante disponibile';

  @override
  String get marketplaceEmptyHint =>
      'I ristoranti con consegna a domicilio appariranno qui';

  @override
  String get marketplaceDeliveringTo => 'Consegna a';

  @override
  String get marketplaceChangeAddress => 'Cambia';

  @override
  String get marketplaceFilters => 'Filtri';

  @override
  String marketplaceNoResults(String query) {
    return 'Nessun risultato per \"$query\"';
  }

  @override
  String get marketplaceNoneInZone =>
      'Nessun ristorante consegna alla tua zona';

  @override
  String get marketplaceOutsideRadius =>
      'Ristoranti fuori dal raggio di consegna:';

  @override
  String get marketplaceMissingCoords =>
      'Ristoranti non geolocalizzati (nascosti):';

  @override
  String get marketplaceShowAll => 'Mostra comunque tutti';

  @override
  String get marketplaceGeolocationHint =>
      'Se la distanza sembra sbagliata, il ristorante o il tuo indirizzo potrebbero essere stati geolocalizzati nel posto sbagliato.';

  @override
  String marketplaceMinOrderShort(String amount) {
    return 'Min. $amount';
  }

  @override
  String get marketplaceFree => 'Gratis';

  @override
  String marketplaceMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get marketplaceRatingNew => 'Nuovo';

  @override
  String get filterSheetTitle => 'Filtri e ordinamento';

  @override
  String get filterSheetReset => 'Reset';

  @override
  String get filterSheetSortBy => 'Ordina per';

  @override
  String get filterSheetCuisineType => 'Tipo di cucina';

  @override
  String get filterSheetDietary => 'Preferenze alimentari';

  @override
  String get filterSheetMaxTime => 'Tempo massimo di consegna';

  @override
  String get filterSheetDelivery => 'Consegna';

  @override
  String get filterSheetFreeOnly => 'Solo consegna gratuita';

  @override
  String get filterSheetShowResults => 'Mostra risultati';

  @override
  String filterSheetMaxMin(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get sortDistance => 'Distanza';

  @override
  String get sortDeliveryTime => 'Tempo di consegna';

  @override
  String get sortRating => 'Valutazione';

  @override
  String get sortPrice => 'Prezzo consegna';

  @override
  String get cuisinePizza => 'Pizza';

  @override
  String get cuisinePasta => 'Pasta';

  @override
  String get cuisineSushi => 'Sushi';

  @override
  String get cuisineBurger => 'Hamburger';

  @override
  String get cuisineKebab => 'Kebab';

  @override
  String get cuisineChinese => 'Cinese';

  @override
  String get cuisineIndian => 'Indiana';

  @override
  String get cuisineMexican => 'Messicana';

  @override
  String get cuisineAsian => 'Asiatica';

  @override
  String get cuisineMediterranean => 'Mediterranea';

  @override
  String get cuisineAmerican => 'Americana';

  @override
  String get cuisineDessert => 'Dessert';

  @override
  String get cuisineBreakfast => 'Colazione';

  @override
  String get cuisineOther => 'Altro';

  @override
  String get dietaryVegan => 'Vegano';

  @override
  String get dietaryVegetarian => 'Vegetariano';

  @override
  String get dietaryGlutenFree => 'Senza glutine';

  @override
  String get dietaryHalal => 'Halal';

  @override
  String get dietaryKosher => 'Kosher';

  @override
  String get dietaryLactoseFree => 'Senza lattosio';

  @override
  String get restaurantNotFound => 'Ristorante non trovato';

  @override
  String get restaurantVacationBadge => 'In ferie';

  @override
  String get restaurantUnavailableBadge => 'Non disponibile';

  @override
  String get restaurantStripeMissing =>
      'Il ristorante non ha completato la configurazione dei pagamenti.';

  @override
  String get menuAddToCart => 'Aggiungi';

  @override
  String menuItemAdded(String name) {
    return '$name aggiunto';
  }

  @override
  String get cartTitle => 'Il tuo ordine';

  @override
  String get cartEmpty => 'Il carrello è vuoto';

  @override
  String get cartEmptyHint => 'Aggiungi piatti dal menu';

  @override
  String get cartClear => 'Svuota';

  @override
  String get cartSubmit => 'Invia ordine';

  @override
  String get cartCustomerNameLabel => 'Il tuo nome (opzionale)';

  @override
  String get cartCustomerNameHint => 'Per facilitare la consegna';

  @override
  String get cartOrderSubmittedTitle => 'Ordine inviato!';

  @override
  String cartOrderSubmittedMessage(String orderNumber) {
    return 'Il tuo ordine #$orderNumber è stato ricevuto.';
  }

  @override
  String cartOrderSubmittedTotal(String total) {
    return 'Totale: $total';
  }

  @override
  String get cartOrderSubmittedFooter => 'Riceverai il tuo ordine a breve.';

  @override
  String get cartOk => 'OK';

  @override
  String cartGoToCheckout(String total) {
    return 'Vai al pagamento - $total';
  }

  @override
  String cartMinOrderNotMet(String amount) {
    return 'Ordine minimo $amount';
  }

  @override
  String get ordersTitle => 'I miei ordini';

  @override
  String get ordersActive => 'Ordini attivi';

  @override
  String get ordersHistory => 'Storico ordini';

  @override
  String get ordersEmpty => 'Nessun ordine';

  @override
  String get ordersEmptyHint => 'I tuoi ordini appariranno qui';

  @override
  String get ordersDetailTitle => 'Dettaglio ordine';

  @override
  String ordersNumber(String number) {
    return 'Ordine #$number';
  }

  @override
  String get ordersNotFound => 'Ordine non trovato';

  @override
  String get ordersStatusSection => 'Stato ordine';

  @override
  String get ordersItemsSection => 'Articoli';

  @override
  String get ordersItemsLoadError => 'Impossibile caricare gli articoli';

  @override
  String get ordersSummarySection => 'Riepilogo';

  @override
  String get ordersAddressSection => 'Indirizzo di consegna';

  @override
  String get ordersNotesSection => 'Note';

  @override
  String get statusPending => 'In attesa';

  @override
  String get statusConfirmed => 'Confermato';

  @override
  String get statusPreparing => 'In preparazione';

  @override
  String get statusReadyForDelivery => 'Pronto';

  @override
  String get statusOutForDelivery => 'In consegna';

  @override
  String get statusDelivered => 'Consegnato';

  @override
  String get statusCancelled => 'Annullato';

  @override
  String get statusRefunded => 'Rimborsato';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutSummary => 'Riepilogo ordine';

  @override
  String get checkoutDeliveryAddress => 'Indirizzo di consegna';

  @override
  String get checkoutNoAddress => 'Nessun indirizzo di consegna';

  @override
  String get checkoutNoAddressHint => 'Aggiungi un indirizzo per continuare.';

  @override
  String get checkoutAddAddress => 'Aggiungi indirizzo';

  @override
  String get checkoutOrderNotes => 'Note per il ristorante';

  @override
  String get checkoutOrderNotesHint => 'Es. Suonare al citofono, allergie...';

  @override
  String get checkoutPromoCodeTitle => 'Codice promozionale';

  @override
  String get checkoutPromoHint => 'Es. PIZZA10';

  @override
  String get checkoutPromoApply => 'Applica';

  @override
  String get checkoutPromoRemove => 'Rimuovi';

  @override
  String checkoutPromoApplied(String code) {
    return 'Codice \"$code\" applicato';
  }

  @override
  String get checkoutPromoInvalid => 'Codice non valido';

  @override
  String get checkoutSubtotal => 'Subtotale';

  @override
  String get checkoutDelivery => 'Consegna';

  @override
  String get checkoutDiscount => 'Sconto';

  @override
  String get checkoutTotal => 'Totale';

  @override
  String checkoutPay(String amount) {
    return 'Paga $amount';
  }

  @override
  String get checkoutProcessing => 'Elaborazione...';

  @override
  String get checkoutCartEmpty => 'Il carrello è vuoto';

  @override
  String get checkoutAddressRequired => 'Aggiungi un indirizzo di consegna';

  @override
  String get orderConfirmedTitle => 'Ordine confermato!';

  @override
  String get orderConfirmedSubtitle =>
      'Il tuo ordine è stato ricevuto e sarà preparato a breve.';

  @override
  String get orderConfirmedOrder => 'Ordine';

  @override
  String get orderConfirmedTotal => 'Totale';

  @override
  String get orderConfirmedEta => 'Tempo stimato';

  @override
  String get orderConfirmedDelivery => 'Consegna';

  @override
  String get orderConfirmedStatus => 'Stato';

  @override
  String get orderConfirmedSeeOrders => 'Vedi i miei ordini';

  @override
  String get orderConfirmedBackToMarketplace => 'Torna al marketplace';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileNotFound => 'Profilo non trovato';

  @override
  String get profileEdit => 'Modifica profilo';

  @override
  String get profileAddresses => 'Indirizzi di consegna';

  @override
  String get profileOrders => 'Storico ordini';

  @override
  String get profilePushNotifications => 'Notifiche push';

  @override
  String get profilePushNotificationsSubtitle =>
      'Avvisi sullo stato dei tuoi ordini';

  @override
  String get profileLanguage => 'Lingua / Language';

  @override
  String get profileSignOut => 'Esci';

  @override
  String get profileDisplayNameLabel => 'Nome visualizzato';

  @override
  String get profilePhoneLabel => 'Telefono';

  @override
  String get profileCancel => 'Annulla';

  @override
  String get addressesTitle => 'Indirizzi di consegna';

  @override
  String get addressesEmpty => 'Nessun indirizzo salvato';

  @override
  String get addressesAdd => 'Aggiungi indirizzo';

  @override
  String get addressesEdit => 'Modifica indirizzo';

  @override
  String get addressesDelete => 'Elimina indirizzo';

  @override
  String get addressesDeleteConfirm => 'Vuoi eliminare questo indirizzo?';

  @override
  String get addressesLabel => 'Etichetta';

  @override
  String get addressesStreet => 'Via e numero civico';

  @override
  String get addressesCity => 'Città';

  @override
  String get addressesPostalCode => 'CAP';

  @override
  String get addressesProvince => 'Provincia';

  @override
  String get addressesNotes => 'Note (opzionale)';

  @override
  String get addressesNotesHint => 'Piano, scala, interno...';

  @override
  String get addressesSetDefault => 'Indirizzo predefinito';

  @override
  String get favoritesTitle => 'Preferiti';

  @override
  String get favoritesEmpty => 'Nessun preferito';

  @override
  String get favoritesEmptyHint =>
      'I ristoranti e i piatti che metti tra i preferiti appariranno qui';

  @override
  String get favoritesRestaurants => 'Ristoranti';

  @override
  String get favoritesItems => 'Piatti';

  @override
  String get reviewPromptTitle => 'Com\'è andata?';

  @override
  String get reviewPromptCommentHint => 'Lascia un commento (facoltativo)';

  @override
  String get reviewPromptLater => 'Più tardi';

  @override
  String get reviewPromptSubmit => 'Invia';

  @override
  String get reviewPromptThanks => 'Grazie per la tua recensione!';

  @override
  String get reviewLeaveTitle => 'Lascia una recensione';

  @override
  String get reviewLeaveSubtitle =>
      'Aiuta altri clienti raccontando la tua esperienza.';

  @override
  String get reviewLeaveButton => 'Lascia recensione';

  @override
  String get reviewMine => 'La tua recensione';

  @override
  String get reviewEdit => 'Modifica';

  @override
  String get locationPromptTitle => 'Dove ti trovi?';

  @override
  String get locationPromptSubtitle =>
      'Aggiungi un indirizzo per scoprire i ristoranti che consegnano nella tua zona.';

  @override
  String get locationPromptAdd => 'Aggiungi indirizzo';

  @override
  String get locationPromptSkip => 'Continua senza indirizzo';

  @override
  String get locationSavedAddresses => 'I tuoi indirizzi salvati';

  @override
  String get locationOrAddNew => 'oppure aggiungi nuovo';

  @override
  String get locationOrEnter => 'oppure inserisci';

  @override
  String get locationLabelHint => 'Etichetta (es. Casa, Ufficio)';

  @override
  String get locationStreetRequired => 'Inserisci la via';

  @override
  String get locationCityRequired => 'Inserisci la città';

  @override
  String get locationSessionExpired => 'Sessione scaduta. Accedi di nuovo.';

  @override
  String get locationLabelDefault => 'Casa';

  @override
  String get welcomeTitle => 'Benvenuto da';

  @override
  String get welcomeStart => 'Inizia a ordinare';

  @override
  String get welcomeInfo => 'Scansiona il menu, ordina e paga dal tuo telefono';

  @override
  String get welcomeTableOccupied => 'Questo tavolo è già occupato';

  @override
  String get welcomeTableReserved => 'Questo tavolo è prenotato';

  @override
  String get welcomeAskStaff => 'Richiedi assistenza al personale';

  @override
  String welcomeSeats(int count) {
    return '$count posti';
  }

  @override
  String get welcomeSignInCta => 'Accedi per salvare la cronologia ordini';

  @override
  String get welcomeOccupied => 'OCCUPATO';

  @override
  String get welcomeReserved => 'PRENOTATO';

  @override
  String get staffLoginTitle => 'Accesso staff';

  @override
  String get staffLoginSubtitle => 'Gestisci il tuo ristorante';

  @override
  String get staffLoginSubmit => 'Accedi';

  @override
  String get staffLoginNoAccount => 'Non hai un account?';

  @override
  String get staffLoginRegister => 'Registra ristorante';

  @override
  String get staffLoginConsumerPrompt => 'Sei un cliente?';

  @override
  String get staffLoginConsumerLink => 'Vai all\'app cliente';

  @override
  String get staffNavDashboard => 'Dashboard';

  @override
  String get staffNavOrders => 'Ordini';

  @override
  String get staffNavMenu => 'Menu';

  @override
  String get staffNavFixedMenu => 'Menu Fissi';

  @override
  String get staffNavTables => 'Tavoli';

  @override
  String get staffNavKitchen => 'Cucina';

  @override
  String get staffNavUsers => 'Utenti';

  @override
  String get staffNavAnalytics => 'Analytics';

  @override
  String get staffNavSettings => 'Impostazioni';

  @override
  String get staffNavPromos => 'Codici promo';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardOrdersToday => 'Ordini di oggi';

  @override
  String get dashboardRevenueToday => 'Incasso di oggi';

  @override
  String get dashboardActiveOrders => 'Ordini attivi';

  @override
  String get dashboardOccupiedTables => 'Tavoli occupati';

  @override
  String get dashboardRecentOrders => 'Ordini recenti';

  @override
  String get dashboardNoOrders => 'Nessun ordine';

  @override
  String get dashboardSeeAll => 'Vedi tutti';

  @override
  String get ordersStaffTitle => 'Ordini';

  @override
  String get ordersStaffTabDineIn => 'Al tavolo';

  @override
  String get ordersStaffTabDelivery => 'Consegna';

  @override
  String get ordersStaffSearch => 'Cerca ordini...';

  @override
  String get ordersStaffFilterAll => 'Tutti';

  @override
  String get ordersStaffEmpty => 'Nessun ordine';

  @override
  String get ordersStaffEmptyHint => 'Gli ordini appariranno qui';

  @override
  String get ordersStaffNewOrder => 'Nuovo ordine';

  @override
  String get ordersStaffTotal => 'Totale';

  @override
  String ordersStaffTable(String name) {
    return 'Tavolo $name';
  }

  @override
  String get menuMgmtTitle => 'Gestione menu';

  @override
  String get menuMgmtCategories => 'Categorie';

  @override
  String get menuMgmtItems => 'Piatti';

  @override
  String get menuMgmtAllCategories => 'Tutte le categorie';

  @override
  String get menuMgmtSearchHint => 'Cerca piatto...';

  @override
  String get menuMgmtAddCategory => 'Nuova categoria';

  @override
  String get menuMgmtAddItem => 'Nuovo piatto';

  @override
  String get menuMgmtEmptyCategories => 'Nessuna categoria';

  @override
  String get menuMgmtEmptyItems => 'Nessun piatto';

  @override
  String get menuMgmtAvailable => 'Disponibile';

  @override
  String get menuMgmtUnavailable => 'Non disponibile';

  @override
  String get menuMgmtPriceLabel => 'Prezzo';

  @override
  String get menuMgmtDescriptionLabel => 'Descrizione';

  @override
  String get menuMgmtNameLabel => 'Nome';

  @override
  String get menuMgmtImage => 'Immagine';

  @override
  String get menuMgmtTagsLabel => 'Tag';

  @override
  String get menuMgmtCategoryLabel => 'Categoria';

  @override
  String get tablesTitle => 'Tavoli';

  @override
  String get tablesAddTable => 'Aggiungi tavolo';

  @override
  String get tablesEmpty => 'Nessun tavolo';

  @override
  String get tablesStatusFree => 'Libero';

  @override
  String get tablesStatusOccupied => 'Occupato';

  @override
  String get tablesStatusReserved => 'Prenotato';

  @override
  String get tablesCapacity => 'Capienza';

  @override
  String get tablesZone => 'Zona';

  @override
  String get tablesQrCode => 'Codice QR';

  @override
  String get tablesDownloadQr => 'Scarica QR';

  @override
  String get tablesPrintQr => 'Stampa QR';

  @override
  String get usersTitle => 'Utenti';

  @override
  String get usersAddUser => 'Aggiungi utente';

  @override
  String get usersEmpty => 'Nessun utente';

  @override
  String get usersRoleWaiter => 'Cameriere';

  @override
  String get usersRoleKitchen => 'Cucina';

  @override
  String get usersRoleManager => 'Manager';

  @override
  String get usersRoleAdmin => 'Admin';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsRevenue => 'Incasso';

  @override
  String get analyticsOrders => 'Ordini';

  @override
  String get analyticsAvgOrder => 'Ordine medio';

  @override
  String get analyticsBestSellers => 'Più venduti';

  @override
  String get analyticsPeriodToday => 'Oggi';

  @override
  String get analyticsPeriodWeek => 'Settimana';

  @override
  String get analyticsPeriodMonth => 'Mese';

  @override
  String get analyticsPeriodYear => 'Anno';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsRestaurant => 'Ristorante';

  @override
  String get settingsDelivery => 'Consegne';

  @override
  String get settingsCategoryAndTags => 'Categoria e tag';

  @override
  String get settingsPromoCodes => 'Codici promozionali';

  @override
  String get settingsPromoCodesAction => 'Gestisci codici';

  @override
  String get settingsPromoCodesSubtitle =>
      'Crea sconti percentuali o a importo fisso';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsThemeLight => 'Tema chiaro';

  @override
  String get settingsThemeDark => 'Tema scuro';

  @override
  String get settingsThemeSystem => 'Tema sistema';

  @override
  String get settingsNotifications => 'Notifiche';

  @override
  String get settingsSoundAlerts => 'Avvisi sonori';

  @override
  String get settingsOrderNotifications => 'Notifiche nuovi ordini';

  @override
  String get settingsDeliveryEnabled => 'Consegne attive';

  @override
  String get settingsDeliveryFee => 'Costo consegna';

  @override
  String get settingsDeliveryRadius => 'Raggio (km)';

  @override
  String get settingsDeliveryMin => 'Ordine minimo';

  @override
  String get settingsDeliveryEta => 'Tempo stimato (min)';

  @override
  String get settingsVacationMode => 'Modalità vacanza';

  @override
  String get settingsVacationModeSub => 'Sospendi temporaneamente gli ordini';

  @override
  String get settingsAddress => 'Indirizzo';

  @override
  String get settingsAddressNotSet => 'Indirizzo non impostato';

  @override
  String get settingsStripeConnect => 'Stripe Connect';

  @override
  String get settingsStripeConnected => 'Stripe Connect configurato';

  @override
  String get settingsStripeNotConnected => 'Stripe Connect non configurato';

  @override
  String get settingsStripeConnect_ => 'Connetti Stripe';

  @override
  String get settingsBrandColors => 'Colori del brand';

  @override
  String get settingsPrimaryColor => 'Colore primario';

  @override
  String get settingsSecondaryColor => 'Colore secondario';

  @override
  String get settingsBackgroundColor => 'Sfondo';

  @override
  String get settingsSignOut => 'Esci';

  @override
  String get promoCodesTitle => 'Codici promozionali';

  @override
  String get promoCodesEmpty => 'Nessun codice promozionale';

  @override
  String get promoCodesEmptyHint => 'Tocca \"Nuovo codice\" per crearne uno.';

  @override
  String get promoCodesNew => 'Nuovo codice';

  @override
  String promoCodesEdit(String code) {
    return 'Modifica \"$code\"';
  }

  @override
  String get promoCodesActive => 'Attivo';

  @override
  String get promoCodesInactive => 'Disattivato';

  @override
  String get promoCodesExpired => 'Scaduto';

  @override
  String get promoCodesExhausted => 'Esaurito';

  @override
  String get promoCodesCode => 'Codice';

  @override
  String get promoCodesDiscount => 'Sconto';

  @override
  String get promoCodesMinOrder => 'Ordine minimo (€)';

  @override
  String get promoCodesMaxUses => 'Usi max';

  @override
  String get promoCodesUnlimited => 'illimitato';

  @override
  String get promoCodesPerCustomer => 'Per cliente';

  @override
  String get promoCodesValidUntil => 'Scadenza';

  @override
  String get promoCodesNoExpiry => 'Nessuna scadenza';

  @override
  String get promoCodesRemoveExpiry => 'Rimuovi scadenza';

  @override
  String get promoCodesDescription => 'Descrizione (interna)';

  @override
  String get promoCodesActiveSub =>
      'Se disattivato, i clienti non possono usarlo';

  @override
  String get promoCodesDeleteConfirm => 'Eliminare codice?';

  @override
  String promoCodesUsesCount(int count) {
    return '$count usi';
  }

  @override
  String promoCodesUsesCountMax(int count, int max) {
    return '$count / $max usi';
  }

  @override
  String get kitchenTitle => 'Cucina';

  @override
  String get kitchenEmpty => 'Nessun ordine da preparare';

  @override
  String get kitchenMarkReady => 'Pronto';

  @override
  String get kitchenMarkPreparing => 'In preparazione';

  @override
  String get notifPanelTitle => 'Notifiche';

  @override
  String get notifPanelEmpty => 'Nessuna notifica';

  @override
  String get notifPanelMarkAllRead => 'Segna tutte come lette';

  @override
  String get notifPanelClear => 'Cancella tutte';

  @override
  String get registerTenantTitle => 'Registra la tua\nAzienda';

  @override
  String get registerTenantSubtitle => 'Avvia il tuo business in pochi minuti';

  @override
  String get registerTenantBusinessName => 'Nome Azienda *';

  @override
  String get registerTenantPhone => 'Telefono';

  @override
  String get registerTenantAddress => 'Indirizzo';

  @override
  String get registerTenantBusinessEmail => 'Email Azienda';

  @override
  String get registerTenantFirstName => 'Nome';

  @override
  String get registerTenantLastName => 'Cognome';

  @override
  String get registerTenantAccountEmail => 'Email di accesso *';

  @override
  String get registerTenantPassword => 'Password *';

  @override
  String get registerTenantSubmit => 'Registrati';

  @override
  String get registerTenantContinue => 'Continua';

  @override
  String get registerTenantHaveAccount => 'Hai già un account?';

  @override
  String get registerTenantSignIn => 'Accedi';

  @override
  String get registerTenantSuccess =>
      'Registrazione completata! Effettua il login.';

  @override
  String get registerTenantTagline =>
      'Inizia a gestire la tua attività\nin pochi minuti';

  @override
  String get registerTenantCreateAccount => 'Crea il tuo account';

  @override
  String get registerTenantFormSubtitle =>
      'Compila i dati per registrare la tua azienda';

  @override
  String get registerTenantStep1Title => 'Dati Azienda';

  @override
  String get registerTenantStep1Subtitle => 'Informazioni della tua attività';

  @override
  String get registerTenantStep2Title => 'Account Amministratore';

  @override
  String get registerTenantStep2Subtitle => 'Le tue credenziali di accesso';

  @override
  String get registerTenantAccountEmailHint => 'La userai per accedere';

  @override
  String get registerTenantPasswordHint => 'Minimo 6 caratteri';

  @override
  String get registerTenantConsumerPrompt => 'Sei un cliente?';

  @override
  String get registerTenantConsumerLink => 'Accedi qui';

  @override
  String get registerTenantNameRequired => 'Il nome è obbligatorio';

  @override
  String get registerTenantEmailRequired => 'L\'email è obbligatoria';

  @override
  String get registerTenantEmailInvalid => 'Inserisci un\'email valida';

  @override
  String get registerTenantPasswordRequired => 'La password è obbligatoria';

  @override
  String get registerTenantPasswordShort =>
      'La password deve essere di almeno 6 caratteri';

  @override
  String get ordersStaffPaymentPaid => 'Pagato';

  @override
  String get ordersStaffPaymentPending => 'Da pagare';

  @override
  String get ordersStaffPaymentFailed => 'Pagamento fallito';

  @override
  String get ordersStaffPaymentRefunded => 'Rimborsato';

  @override
  String get ordersStaffCustomer => 'Cliente';

  @override
  String get ordersStaffNotes => 'Note';

  @override
  String get ordersStaffNoNotes => 'Nessuna nota';

  @override
  String get ordersStaffItems => 'Articoli';

  @override
  String get ordersStaffActions => 'Azioni';

  @override
  String get ordersStaffConfirm => 'Conferma';

  @override
  String get ordersStaffStartPreparing => 'Inizia preparazione';

  @override
  String get ordersStaffMarkReady => 'Segna come pronto';

  @override
  String get ordersStaffMarkOutForDelivery => 'In consegna';

  @override
  String get ordersStaffMarkDelivered => 'Consegnato';

  @override
  String get ordersStaffCancel => 'Annulla ordine';

  @override
  String get ordersStaffRefund => 'Rimborsa';

  @override
  String get ordersStaffPrintReceipt => 'Stampa scontrino';

  @override
  String get ordersStaffCloseTable => 'Chiudi tavolo';

  @override
  String get manualOrderTitle => 'Nuovo ordine manuale';

  @override
  String get manualOrderButton => 'Nuovo ordine';

  @override
  String get manualOrderCustomer => 'Nome cliente';

  @override
  String get manualOrderTable => 'Tavolo';

  @override
  String get manualOrderSelectTable => 'Seleziona tavolo';

  @override
  String get manualOrderItems => 'Articoli';

  @override
  String get manualOrderAddItem => 'Aggiungi articolo';

  @override
  String get manualOrderNotes => 'Note (opzionale)';

  @override
  String get manualOrderSubmit => 'Crea ordine';

  @override
  String get manualOrderItemRequired => 'Aggiungi almeno un articolo';

  @override
  String get menuMgmtAvailableHint => 'Visibile ai clienti';

  @override
  String get menuMgmtUnavailableHint => 'Nascosto ai clienti';

  @override
  String get menuMgmtDeleteCategoryConfirm => 'Eliminare la categoria?';

  @override
  String get menuMgmtDeleteItemConfirm => 'Eliminare il piatto?';

  @override
  String get menuMgmtItemAdded => 'Piatto aggiunto';

  @override
  String get menuMgmtItemUpdated => 'Piatto aggiornato';

  @override
  String get menuMgmtItemDeleted => 'Piatto eliminato';

  @override
  String get menuMgmtCategoryAdded => 'Categoria aggiunta';

  @override
  String get menuMgmtCategoryUpdated => 'Categoria aggiornata';

  @override
  String get menuMgmtCategoryDeleted => 'Categoria eliminata';

  @override
  String get menuMgmtPriceRequired => 'Inserisci un prezzo';

  @override
  String get menuMgmtNameRequired => 'Inserisci un nome';

  @override
  String get menuMgmtUploadImage => 'Carica immagine';

  @override
  String get menuMgmtChangeImage => 'Cambia immagine';

  @override
  String get menuMgmtRemoveImage => 'Rimuovi immagine';

  @override
  String get tablesAddName => 'Nome / Numero';

  @override
  String get tablesEditTable => 'Modifica tavolo';

  @override
  String get tablesDeleteConfirm => 'Eliminare questo tavolo?';

  @override
  String get tablesShowQr => 'Mostra QR';

  @override
  String get tablesScanInstructions => 'Scansiona per ordinare';

  @override
  String get dashboardWelcome => 'Bentornato';

  @override
  String get dashboardSubtitle => 'Ecco un\'anteprima della tua attività';

  @override
  String get dashboardKpis => 'Statistiche';

  @override
  String get dashboardQuickActions => 'Azioni rapide';

  @override
  String get dashboardOrderNumber => 'Ordine';

  @override
  String get dashboardCustomer => 'Cliente';

  @override
  String get dashboardAmount => 'Importo';

  @override
  String get dashboardTime => 'Ora';

  @override
  String get dashboardTestCustomerView => 'Test vista cliente';

  @override
  String get dashboardTestCustomerViewSubtitle =>
      'Simula la scansione QR di un tavolo';

  @override
  String get dashboardTestCustomerViewSubtitleShort => 'Simula scansione QR';

  @override
  String get dashboardSelectTable => 'Seleziona tavolo';

  @override
  String get dashboardSelectTableHeader => 'Seleziona un tavolo';

  @override
  String get kitchenPending => 'In attesa';

  @override
  String get kitchenInProgress => 'In preparazione';

  @override
  String get kitchenReady => 'Pronto';

  @override
  String get kitchenItem => 'Articolo';

  @override
  String get kitchenTable => 'Tavolo';

  @override
  String get kitchenOrderNumber => 'Ordine';

  @override
  String get kitchenSince => 'Da';

  @override
  String get errorGeneric => 'Si è verificato un errore. Riprova.';

  @override
  String get errorNetwork => 'Nessuna connessione internet.';

  @override
  String get errorTimeout => 'La richiesta ha impiegato troppo tempo. Riprova.';

  @override
  String get errorAuth => 'Errore di autenticazione';

  @override
  String get errorAuthInvalidCredentials => 'Email o password non corretti.';

  @override
  String get errorAuthEmailNotConfirmed =>
      'Devi confermare la tua email prima di accedere.';

  @override
  String get errorAuthAlreadyRegistered =>
      'Esiste già un account con questa email.';

  @override
  String get errorAuthPasswordShort => 'La password è troppo corta.';

  @override
  String get errorAuthUserNotFound =>
      'Nessun account trovato con questa email.';

  @override
  String get errorAuthRateLimit =>
      'Troppi tentativi. Riprova fra qualche minuto.';

  @override
  String get errorAuthGeneric => 'Errore di autenticazione. Riprova.';

  @override
  String get errorDbDuplicate => 'Esiste già un elemento con questi dati.';

  @override
  String get errorDbForeignKey =>
      'Operazione non consentita: elemento collegato ad altri dati.';

  @override
  String get errorDbNotNull => 'Manca un campo obbligatorio.';

  @override
  String get errorDbPermission => 'Non hai i permessi per questa operazione.';

  @override
  String get errorDbNotFound => 'Elemento non trovato.';

  @override
  String get errorDbGeneric => 'Errore del server. Riprova fra poco.';

  @override
  String get errorStorageTooLarge => 'File troppo grande.';

  @override
  String get errorStorageNotFound => 'File non trovato.';

  @override
  String get errorStorageNotAllowed => 'Non puoi caricare questo file.';

  @override
  String get errorStorageGeneric => 'Errore caricamento file. Riprova.';

  @override
  String get errorNotFound => 'Non trovato';

  @override
  String get errorPermission => 'Permesso negato';

  @override
  String get settingsRestaurantName => 'Nome';

  @override
  String get settingsLogo => 'Logo';

  @override
  String get settingsCoverImage => 'Immagine di copertina';

  @override
  String get settingsPhone => 'Telefono';

  @override
  String get settingsEmail => 'Email';

  @override
  String get settingsHours => 'Orari di apertura';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsRole => 'Ruolo';

  @override
  String get usersHeader => 'Utente';

  @override
  String get usersEmail => 'Email';

  @override
  String get usersRole => 'Ruolo';

  @override
  String get usersStatus => 'Stato';

  @override
  String get usersLastLogin => 'Ultimo accesso';

  @override
  String get usersActions => 'Azioni';

  @override
  String get usersNever => 'Mai';

  @override
  String get usersAdd => 'Nuovo Utente';

  @override
  String get usersDeactivate => 'Disattiva';

  @override
  String get usersActivate => 'Attiva';

  @override
  String usersDeleteConfirm(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get usersDeletedToast => 'Utente eliminato';

  @override
  String get kitchenDisplayTitle => 'Display Cucina';

  @override
  String get fixedMenuTitle => 'Menu Fissi';

  @override
  String get fixedMenuSubtitle =>
      'Gestisci i menu a prezzo fisso del ristorante';

  @override
  String get fixedMenuAdd => 'Nuovo Menu Fisso';

  @override
  String get fixedMenuEmpty => 'Nessun menu fisso';

  @override
  String get manualOrderSelectItems => 'Seleziona articoli';

  @override
  String get manualOrderSubtotal => 'Subtotale';

  @override
  String get manualOrderEmptyCart => 'Nessun articolo selezionato';

  @override
  String get orderDetailTitle => 'Dettaglio Ordine';

  @override
  String get orderDetailItems => 'Articoli';

  @override
  String get orderDetailNotes => 'Note';

  @override
  String get orderDetailTotal => 'Totale';

  @override
  String get orderDetailUpdateStatus => 'Cambia stato';

  @override
  String get customerMenuChoose => 'Scegli i tuoi piatti preferiti';

  @override
  String get customerMenuNoMenu => 'Menu non disponibile';

  @override
  String get customerMenuNoItems => 'Nessun piatto in questa categoria';

  @override
  String get customerMenuNoFixed => 'Nessun menu fisso disponibile';

  @override
  String get customerMenuFixedTab => 'Menu Fissi';

  @override
  String get menuItemDialogNew => 'Nuovo Piatto';

  @override
  String get menuItemDialogEdit => 'Modifica Piatto';

  @override
  String get menuItemDialogName => 'Nome *';

  @override
  String get menuItemDialogCategory => 'Categoria *';

  @override
  String get menuItemDialogDescription => 'Descrizione';

  @override
  String get menuItemDialogDescriptionHint => 'Descrizione del piatto...';

  @override
  String get menuItemDialogPrice => 'Prezzo *';

  @override
  String get menuItemDialogPriceRequired => 'Inserisci il prezzo';

  @override
  String get menuItemDialogPriceInvalid => 'Prezzo non valido';

  @override
  String get menuItemDialogPrepTime => 'Tempo prep. (min)';

  @override
  String get menuItemDialogCalories => 'Calorie';

  @override
  String get menuItemDialogImage => 'Immagine';

  @override
  String get menuItemDialogUploadPhoto => 'Carica foto';

  @override
  String get menuItemDialogChangePhoto => 'Cambia foto';

  @override
  String get menuItemDialogRemove => 'Rimuovi';

  @override
  String get menuItemDialogOrder => 'Ordine';

  @override
  String get menuItemDialogTags => 'Tag';

  @override
  String get menuItemDialogAllergens => 'Allergeni';

  @override
  String get menuItemDialogAvailable => 'Disponibile';

  @override
  String get menuItemDialogActive => 'Attivo';

  @override
  String get menuItemDialogDeleteConfirm => 'Eliminare il piatto?';

  @override
  String get menuItemDialogCreated => 'Piatto creato';

  @override
  String get menuItemDialogUpdated => 'Piatto aggiornato';

  @override
  String get menuItemDialogDeleted => 'Piatto eliminato';

  @override
  String get menuItemDialogSelectCategoryFirst => 'Seleziona una categoria';

  @override
  String get categoryDialogNew => 'Nuova categoria';

  @override
  String get categoryDialogEdit => 'Modifica categoria';

  @override
  String get categoryDialogName => 'Nome categoria';

  @override
  String get categoryDialogDeleteConfirm => 'Eliminare la categoria?';

  @override
  String get analyticsPeriod => 'Periodo:';

  @override
  String get analyticsRefresh => 'Aggiorna dati';

  @override
  String get analyticsCompletedOrders => 'Ordini Completati';

  @override
  String get analyticsAvgTicket => 'Scontrino Medio';

  @override
  String get analyticsItemsSold => 'Piatti Venduti';

  @override
  String get analyticsRevenueTrend => 'Andamento Ricavi';

  @override
  String get analyticsOrdersByStatus => 'Ordini per Stato';

  @override
  String get analyticsTopItems => 'Piatti Più Venduti';

  @override
  String get analyticsPeakHours => 'Ore di Punta';

  @override
  String get analyticsByCategory => 'Per Categoria';

  @override
  String get tableDialogNew => 'Nuovo Tavolo';

  @override
  String get tableDialogEdit => 'Modifica Tavolo';

  @override
  String get tableDialogName => 'Nome *';

  @override
  String get tableDialogSeats => 'Posti *';

  @override
  String get tableDialogSeatsRequired => 'Inserisci i posti';

  @override
  String get tableDialogInvalidNumber => 'Valore non valido';

  @override
  String get tableDialogZone => 'Zona';

  @override
  String get tableDialogState => 'Stato';

  @override
  String get tableDialogActive => 'Attivo';

  @override
  String get tableDialogActiveSub => 'Visibile e utilizzabile';

  @override
  String get tableDialogQrCode => 'Codice QR';

  @override
  String get tableDialogCreated => 'Tavolo creato';

  @override
  String get tableDialogUpdated => 'Tavolo aggiornato';

  @override
  String get tableDialogDeleted => 'Tavolo eliminato';

  @override
  String get tableDialogCreate => 'Crea';

  @override
  String get categoryDialogEditTitle => 'Modifica Categoria';

  @override
  String get categoryDialogNewTitle => 'Nuova Categoria';

  @override
  String get categoryDialogNameLabel => 'Nome *';

  @override
  String get categoryDialogDescription => 'Descrizione';

  @override
  String get categoryDialogDescriptionHint => 'Descrizione opzionale...';

  @override
  String get categoryDialogOrder => 'Ordine';

  @override
  String get categoryDialogActive => 'Attiva';

  @override
  String get categoryDialogActiveSub => 'Visibile nel menu';

  @override
  String get categoryDialogCreated => 'Categoria creata';

  @override
  String get categoryDialogUpdated => 'Categoria aggiornata';

  @override
  String get categoryDialogDeleted => 'Categoria eliminata';

  @override
  String get categoryDialogDeleteWarn =>
      'Attenzione: tutti i piatti in questa categoria dovranno essere riassegnati.';

  @override
  String get userDialogNew => 'Nuovo Utente';

  @override
  String get userDialogEdit => 'Modifica Utente';

  @override
  String get userDialogFirstName => 'Nome';

  @override
  String get userDialogLastName => 'Cognome';

  @override
  String get userDialogEmail => 'Email *';

  @override
  String get userDialogEmailInvalid => 'Inserisci un\'email valida';

  @override
  String get userDialogPassword => 'Password *';

  @override
  String get userDialogPasswordHint => 'Minimo 6 caratteri';

  @override
  String get userDialogRole => 'Ruolo *';

  @override
  String get userDialogActive => 'Utente attivo';

  @override
  String get userDialogActiveSubtitle => 'L\'utente può accedere al sistema';

  @override
  String get userDialogInactiveSubtitle => 'L\'utente non può accedere';

  @override
  String get userDialogCreate => 'Crea Utente';

  @override
  String get userDialogCreated => 'Utente creato con successo';

  @override
  String get userDialogUpdated => 'Utente aggiornato';

  @override
  String get userDialogEmailExists => 'Questa email è già registrata';

  @override
  String get userDialogRoleAdmin => 'Amministratore';

  @override
  String get userDialogRoleManager => 'Manager';

  @override
  String get userDialogRoleWaiter => 'Cameriere';

  @override
  String get userDialogRoleKitchen => 'Cucina';

  @override
  String get userDialogRoleAdminDesc =>
      'Accesso completo: gestione menu, tavoli, ordini, utenti e impostazioni.';

  @override
  String get userDialogRoleManagerDesc =>
      'Gestione menu, tavoli e ordini. Non può gestire utenti e impostazioni.';

  @override
  String get userDialogRoleWaiterDesc =>
      'Può visualizzare e gestire solo gli ordini. Ideale per camerieri.';

  @override
  String get userDialogRoleKitchenDesc =>
      'Visualizza solo gli ordini da preparare. Ideale per il personale di cucina.';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mer';

  @override
  String get dayThu => 'Gio';

  @override
  String get dayFri => 'Ven';

  @override
  String get daySat => 'Sab';

  @override
  String get daySun => 'Dom';

  @override
  String get fixedMenuDialogNew => 'Nuovo Menu Fisso';

  @override
  String get fixedMenuDialogEdit => 'Modifica Menu';

  @override
  String get fixedMenuDialogName => 'Nome *';

  @override
  String get fixedMenuDialogNameRequired => 'Inserisci il nome';

  @override
  String get fixedMenuDialogDescription => 'Descrizione';

  @override
  String get fixedMenuDialogDescriptionHint => 'Descrizione opzionale del menu';

  @override
  String get fixedMenuDialogPrice => 'Prezzo *';

  @override
  String get fixedMenuDialogPriceRequired => 'Inserisci il prezzo';

  @override
  String get fixedMenuDialogPriceInvalid => 'Prezzo non valido';

  @override
  String get fixedMenuDialogAvailability => 'Disponibilità';

  @override
  String get fixedMenuDialogAlways => 'Sempre';

  @override
  String get fixedMenuDialogLunch => 'Pranzo';

  @override
  String get fixedMenuDialogDinner => 'Cena';

  @override
  String get fixedMenuDialogDays => 'Giorni (lascia vuoto per tutti)';

  @override
  String get fixedMenuDialogActive => 'Menu Attivo';

  @override
  String get fixedMenuDialogActiveSub => 'Visibile ai clienti';

  @override
  String get fixedMenuDialogCreated => 'Menu creato';

  @override
  String get fixedMenuDialogUpdated => 'Menu aggiornato';

  @override
  String get fixedMenuDialogDeleted => 'Menu eliminato';

  @override
  String get fixedMenuDialogDeleteWarn =>
      'Questa azione eliminerà anche tutte le portate e scelte associate.';

  @override
  String get fixedMenuDialogDeleteTitle => 'Elimina Menu';

  @override
  String fixedMenuDialogDeleteConfirm(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"?';
  }

  @override
  String get fixedMenuDialogImageUrl => 'URL Immagine';

  @override
  String get fixedMenuCoursesTitle => 'Gestisci portate e scelte';

  @override
  String get fixedMenuCoursesAdd => 'Aggiungi Portata';

  @override
  String get fixedMenuCoursesEmpty => 'Nessuna portata';

  @override
  String get fixedMenuCoursesEmptyHint =>
      'Aggiungi portate come Primo, Secondo, Dolce...';

  @override
  String fixedMenuCoursesDeleteConfirm(String name) {
    return 'Eliminare \"$name\" e tutte le sue scelte?';
  }

  @override
  String get fixedMenuCoursesRequired => 'Obbligatorio';

  @override
  String get fixedMenuCoursesDeleteTitle => 'Elimina Portata';

  @override
  String fixedMenuCoursesChoicesAvailable(int count) {
    return '$count scelte disponibili';
  }

  @override
  String get fixedMenuCoursesEditCourse => 'Modifica Portata';

  @override
  String get fixedMenuCoursesNewCourse => 'Nuova Portata';

  @override
  String get fixedMenuCoursesNameLabel => 'Nome *';

  @override
  String get fixedMenuCoursesNameHint => 'es. Primo, Secondo, Dolce';

  @override
  String get fixedMenuCoursesDescription => 'Descrizione';

  @override
  String get fixedMenuCoursesDescriptionHint => 'Descrizione opzionale';

  @override
  String get fixedMenuCoursesRequiredToggle => 'Selezione obbligatoria';

  @override
  String get fixedMenuCoursesRequiredToggleSub => 'Il cliente deve scegliere';

  @override
  String get fixedMenuChoicesAdd => 'Aggiungi Scelta';

  @override
  String get fixedMenuChoicesEmpty =>
      'Nessuna scelta. Aggiungi piatti dal menu.';

  @override
  String get fixedMenuChoicesRemove => 'Rimuovi';

  @override
  String get fixedMenuChoicesSearchHint => 'Cerca piatto...';

  @override
  String get fixedMenuChoicesNoItemsAvailable => 'Nessun piatto disponibile';

  @override
  String get fixedMenuChoicesSupplement => 'Supplemento';

  @override
  String get fixedMenuChoicesDefault => 'Predefinito';

  @override
  String get fixedMenuChoicesAddBtn => 'Aggiungi';

  @override
  String get tooltipEdit => 'Modifica';

  @override
  String get tooltipDelete => 'Elimina';

  @override
  String get fixedMenuCardChooseCourses => 'Scegli le portate';

  @override
  String get fixedMenuSelectionMenuNotFound => 'Menu non trovato';

  @override
  String get fixedMenuSelectionSelectAllRequired =>
      'Seleziona tutte le portate obbligatorie';

  @override
  String fixedMenuSelectionAddToCart(String price) {
    return 'Aggiungi al carrello - €$price';
  }

  @override
  String get fixedMenuSelectionOptional => 'Opzionale';

  @override
  String get fixedMenuSelectionNoChoices =>
      'Nessuna scelta disponibile per questa portata';

  @override
  String get fixedMenuSelectionRecommended => 'Scelta consigliata';

  @override
  String fixedMenuSelectionAddedToCart(String name) {
    return '$name aggiunto al carrello';
  }

  @override
  String get editAddressTitle => 'Modifica indirizzo';

  @override
  String get editAddressUseMyLocation => 'Usa la mia posizione';

  @override
  String get editAddressLocating => 'Localizzazione...';

  @override
  String get editAddressPermissionDenied =>
      'Permesso negato. Inserisci manualmente l\'indirizzo.';

  @override
  String editAddressUnavailable(String message) {
    return 'Posizione non disponibile: $message';
  }

  @override
  String get editAddressReverseFail =>
      'Impossibile leggere l\'indirizzo. Riprova o inseriscilo manualmente.';

  @override
  String get editAddressRequired => 'Inserisci un indirizzo';

  @override
  String get editAddressUpdatedGeo => 'Indirizzo aggiornato e geolocalizzato';

  @override
  String get editAddressSavedNoGeo =>
      'Indirizzo salvato (geolocalizzazione non riuscita)';

  @override
  String get editAddressLabel => 'Indirizzo completo';

  @override
  String get editAddressHint => 'Via Roma 5, 20121 Milano';

  @override
  String get editAddressFormatHelp =>
      'Formato: via + numero, CAP + città. Le coordinate vengono calcolate al salvataggio.';

  @override
  String get settingsNotConfigured => 'Non configurato';

  @override
  String get settingsLoadingError => 'Errore nel caricamento';

  @override
  String get settingsNotificationsOrders => 'Notifiche ordini';

  @override
  String get settingsNotificationsOrdersSub =>
      'Ricevi notifiche per nuovi ordini';

  @override
  String get settingsSoundAlertsTitle => 'Suoni di avviso';

  @override
  String get settingsSoundAlertsSub => 'Riproduci un suono per le notifiche';

  @override
  String get settingsVibrationTitle => 'Vibrazione';

  @override
  String get settingsVibrationSub => 'Vibra per le notifiche (mobile)';

  @override
  String get settingsVibrationSubShort => 'Vibra per le notifiche';

  @override
  String get settingsOrdersManagement => 'Gestione Ordini';

  @override
  String get settingsAutoConfirm => 'Conferma automatica';

  @override
  String get settingsAutoConfirmSub =>
      'Conferma automaticamente i nuovi ordini';

  @override
  String get settingsSignOutTitle => 'Conferma Logout';

  @override
  String get settingsSignOutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get settingsNotificationSound => 'Suono notifica';

  @override
  String get settingsPasswordMinChars => 'Minimo 6 caratteri';

  @override
  String get settingsPasswordUpdated => 'Password aggiornata con successo';

  @override
  String get settingsNewPassword => 'Nuova password';

  @override
  String get settingsConfirmPassword => 'Conferma password';

  @override
  String get settingsPasswordMismatch => 'Le password non coincidono';

  @override
  String get settingsColorsSaved => 'Colori salvati con successo';

  @override
  String settingsSaveError(String message) {
    return 'Errore nel salvataggio: $message';
  }

  @override
  String get settingsPrimaryColorHint => 'Il colore principale del brand';

  @override
  String get settingsSecondaryColorHint => 'Colore per accenti e dettagli';

  @override
  String get settingsBackgroundColorHint => 'Sfondo delle pagine (tema chiaro)';

  @override
  String get settingsAccent => 'Accento';

  @override
  String get settingsSaveColors => 'Salva Colori';

  @override
  String get settingsStripeOnboardingTitle => 'Configura Stripe';

  @override
  String settingsStripeOnboardingBody(String url) {
    return 'Apri questo link per completare la configurazione:\n\n$url';
  }

  @override
  String get settingsDeliverySaved => 'Impostazioni consegna salvate';

  @override
  String get settingsEnableDelivery => 'Abilita consegne';

  @override
  String get settingsEnableDeliverySub =>
      'Il ristorante apparirà nel marketplace per le consegne a domicilio';

  @override
  String get settingsEnableDeliverySubShort => 'Appari nel marketplace';

  @override
  String get settingsVacation => 'In vacanza';

  @override
  String get settingsVacationSub =>
      'Sospende temporaneamente la ricezione di ordini';

  @override
  String get settingsVacationSubShort => 'Sospende gli ordini';

  @override
  String get settingsDeliveryCost => 'Costo consegna';

  @override
  String get settingsDeliveryMinOrder => 'Ordine minimo';

  @override
  String get settingsDeliveryRadiusLabel => 'Raggio consegna';

  @override
  String get settingsDeliveryEtaLabel => 'Tempo stimato';

  @override
  String get settingsStripeNotConfigured => 'Stripe non configurato';

  @override
  String get settingsStripeNotConnectedSub =>
      ' — necessario per ricevere pagamenti';

  @override
  String get settingsStripeConfigure => 'Configura';

  @override
  String get settingsGeoFail =>
      'Geocodifica fallita. Verifica che l\'indirizzo sia corretto e completo.';

  @override
  String get settingsGeoFailShort =>
      'Geocodifica fallita. Verifica l\'indirizzo.';

  @override
  String get settingsGeoSuccess => 'Geolocalizzazione completata';

  @override
  String get settingsNotGeolocated => 'Ristorante non geolocalizzato';

  @override
  String get settingsNotGeolocatedShort => 'Non geolocalizzato';

  @override
  String get settingsSetAddress => 'Imposta indirizzo';

  @override
  String get settingsGeoMissingHint =>
      'Senza coordinate il ristorante non comparirà nel marketplace dei clienti. Riprova la geocodifica o modifica l\'indirizzo.';

  @override
  String get settingsGeoAddressFirst =>
      'Imposta prima l\'indirizzo del ristorante: serve per calcolare le distanze nel marketplace.';

  @override
  String get settingsChangePassword => 'Cambia password';

  @override
  String get settingsManageCodes => 'Gestisci codici';

  @override
  String settingsVersion(String value) {
    return 'Versione $value';
  }

  @override
  String get settingsRestaurantInfo => 'Informazioni Ristorante';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLightShort => 'Chiaro';

  @override
  String get settingsThemeDarkShort => 'Scuro';

  @override
  String get settingsThemeSystemShort => 'Sistema';

  @override
  String get settingsCuisineType => 'Tipo di cucina';

  @override
  String get settingsDietaryTags => 'Tag alimentari';

  @override
  String get settingsDietaryTagsHint => 'Mostrati come filtri nel marketplace.';

  @override
  String get settingsSaved => 'Salvato';

  @override
  String get settingsSaving => 'Salvataggio...';

  @override
  String get settingsNoTenantError => 'Errore: nessun ristorante associato';

  @override
  String get settingsRetryGeocoding => 'Riprova geocodifica';

  @override
  String get settingsSoundClassic => 'Classico';

  @override
  String get settingsSoundBell => 'Campanello';

  @override
  String get settingsSoundChime => 'Chime';

  @override
  String get analyticsTotalRevenue => 'Ricavi Totali';

  @override
  String cartMinOrderMissing(String amount) =>
      'Mancano € $amount per l\'ordine minimo';

  @override
  String get menuItemAllergens => 'Allergeni';

  @override
  String get menuItemNotesLabel => 'Note (opzionale)';

  @override
  String get menuItemNotesHint => 'Es: senza cipolla, ben cotto...';

  @override
  String menuItemAddWithPrice(String price) => 'Aggiungi - € $price';

  @override
  String get allergenGluten => 'Glutine';

  @override
  String get allergenLactose => 'Lattosio';

  @override
  String get allergenEggs => 'Uova';

  @override
  String get allergenFish => 'Pesce';

  @override
  String get allergenCrustaceans => 'Crostacei';

  @override
  String get allergenPeanuts => 'Arachidi';

  @override
  String get allergenTreeNuts => 'Frutta a guscio';

  @override
  String get allergenSoy => 'Soia';

  @override
  String get allergenCelery => 'Sedano';

  @override
  String get allergenMustard => 'Senape';

  @override
  String get allergenSesame => 'Sesamo';

  @override
  String get allergenSulphites => 'Solfiti';

  @override
  String get allergenLupin => 'Lupini';

  @override
  String get allergenMolluscs => 'Molluschi';

  @override
  String get tagSpicy => 'Piccante';

  @override
  String get tagChefsChoice => 'Scelta dello Chef';

  @override
  String get favoritesRemove => 'Rimuovi dai preferiti';

  @override
  String get favoritesNoRestaurants => 'Nessun ristorante preferito';

  @override
  String get favoritesNoRestaurantsHint =>
      'Tocca il cuore su un ristorante per\nsalvarlo qui';

  @override
  String get favoritesNoItems => 'Nessun piatto preferito';

  @override
  String get favoritesNoItemsHint => 'Tocca il cuore su un piatto per\nsalvarlo qui';
}
