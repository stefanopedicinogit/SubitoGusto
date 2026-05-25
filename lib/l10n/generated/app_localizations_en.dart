// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SubitoGusto';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong. Please try again.';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonNew => 'New';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonShow => 'Show';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonHere => 'Here';

  @override
  String get commonAll => 'All';

  @override
  String get commonAny => 'Any';

  @override
  String get consumerLoginTitle => 'Welcome back';

  @override
  String get consumerLoginSubtitle => 'Sign in to order';

  @override
  String get consumerLoginEmailLabel => 'Email';

  @override
  String get consumerLoginPasswordLabel => 'Password';

  @override
  String get consumerLoginSubmit => 'Sign in';

  @override
  String get consumerLoginNoAccount => 'Don\'t have an account?';

  @override
  String get consumerLoginSignUp => 'Sign up';

  @override
  String get consumerLoginStaffPrompt => 'Are you staff?';

  @override
  String get consumerLoginStaffLink => 'Sign in here';

  @override
  String get consumerLoginContinueWith => 'or continue with';

  @override
  String get consumerLoginGoogle => 'Continue with Google';

  @override
  String get consumerLoginApple => 'Continue with Apple';

  @override
  String get consumerRegisterTitle => 'Create your account';

  @override
  String get consumerRegisterSubtitle => 'Sign up to order in a few clicks';

  @override
  String get consumerRegisterNameLabel => 'Name';

  @override
  String get consumerRegisterEmailLabel => 'Email';

  @override
  String get consumerRegisterPasswordLabel => 'Password';

  @override
  String get consumerRegisterPasswordHint => 'At least 8 characters';

  @override
  String get consumerRegisterSubmit => 'Create account';

  @override
  String get consumerRegisterHaveAccount => 'Already have an account?';

  @override
  String get consumerRegisterSignIn => 'Sign in';

  @override
  String get consumerRegisterSuccess =>
      'Registration successful! Please sign in.';

  @override
  String get consumerRegisterStaffPrompt => 'Are you staff?';

  @override
  String get consumerRegisterStaffLink => 'Go to staff login';

  @override
  String get validationRequired => 'Required field';

  @override
  String get validationEmail => 'Invalid email';

  @override
  String get validationPasswordMin => 'Password must be at least 8 characters';

  @override
  String get navMarketplace => 'Restaurants';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get marketplaceSearchHint => 'Search restaurants...';

  @override
  String get marketplaceEmpty => 'No restaurants available';

  @override
  String get marketplaceEmptyHint =>
      'Restaurants offering delivery will appear here';

  @override
  String get marketplaceDeliveringTo => 'Delivering to';

  @override
  String get marketplaceChangeAddress => 'Change';

  @override
  String get marketplaceFilters => 'Filters';

  @override
  String marketplaceNoResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get marketplaceNoneInZone => 'No restaurant delivers to your area';

  @override
  String get marketplaceOutsideRadius =>
      'Restaurants outside the delivery radius:';

  @override
  String get marketplaceMissingCoords =>
      'Restaurants without coordinates (hidden):';

  @override
  String get marketplaceShowAll => 'Show all anyway';

  @override
  String get marketplaceGeolocationHint =>
      'If the distance looks wrong, the restaurant or your address may have been geocoded incorrectly.';

  @override
  String marketplaceMinOrderShort(String amount) {
    return 'Min. $amount';
  }

  @override
  String get marketplaceFree => 'Free';

  @override
  String marketplaceMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get marketplaceRatingNew => 'New';

  @override
  String get filterSheetTitle => 'Filters and sorting';

  @override
  String get filterSheetReset => 'Reset';

  @override
  String get filterSheetSortBy => 'Sort by';

  @override
  String get filterSheetCuisineType => 'Cuisine type';

  @override
  String get filterSheetDietary => 'Dietary preferences';

  @override
  String get filterSheetMaxTime => 'Max delivery time';

  @override
  String get filterSheetDelivery => 'Delivery';

  @override
  String get filterSheetFreeOnly => 'Free delivery only';

  @override
  String get filterSheetShowResults => 'Show results';

  @override
  String filterSheetMaxMin(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get sortDistance => 'Distance';

  @override
  String get sortDeliveryTime => 'Delivery time';

  @override
  String get sortRating => 'Rating';

  @override
  String get sortPrice => 'Delivery fee';

  @override
  String get cuisinePizza => 'Pizza';

  @override
  String get cuisinePasta => 'Pasta';

  @override
  String get cuisineSushi => 'Sushi';

  @override
  String get cuisineBurger => 'Burger';

  @override
  String get cuisineKebab => 'Kebab';

  @override
  String get cuisineChinese => 'Chinese';

  @override
  String get cuisineIndian => 'Indian';

  @override
  String get cuisineMexican => 'Mexican';

  @override
  String get cuisineAsian => 'Asian';

  @override
  String get cuisineMediterranean => 'Mediterranean';

  @override
  String get cuisineAmerican => 'American';

  @override
  String get cuisineDessert => 'Dessert';

  @override
  String get cuisineBreakfast => 'Breakfast';

  @override
  String get cuisineOther => 'Other';

  @override
  String get dietaryVegan => 'Vegan';

  @override
  String get dietaryVegetarian => 'Vegetarian';

  @override
  String get dietaryGlutenFree => 'Gluten-free';

  @override
  String get dietaryHalal => 'Halal';

  @override
  String get dietaryKosher => 'Kosher';

  @override
  String get dietaryLactoseFree => 'Lactose-free';

  @override
  String get restaurantNotFound => 'Restaurant not found';

  @override
  String get restaurantVacationBadge => 'On vacation';

  @override
  String get restaurantUnavailableBadge => 'Unavailable';

  @override
  String get restaurantStripeMissing =>
      'This restaurant hasn\'t completed its payment setup.';

  @override
  String get menuAddToCart => 'Add';

  @override
  String menuItemAdded(String name) {
    return '$name added';
  }

  @override
  String get cartTitle => 'Your order';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyHint => 'Add dishes from the menu';

  @override
  String get cartClear => 'Clear';

  @override
  String get cartSubmit => 'Submit order';

  @override
  String get cartCustomerNameLabel => 'Your name (optional)';

  @override
  String get cartCustomerNameHint => 'To help with delivery';

  @override
  String get cartOrderSubmittedTitle => 'Order sent!';

  @override
  String cartOrderSubmittedMessage(String orderNumber) {
    return 'Your order #$orderNumber has been received.';
  }

  @override
  String cartOrderSubmittedTotal(String total) {
    return 'Total: $total';
  }

  @override
  String get cartOrderSubmittedFooter => 'You\'ll receive your order shortly.';

  @override
  String get cartOk => 'OK';

  @override
  String cartGoToCheckout(String total) {
    return 'Go to checkout - $total';
  }

  @override
  String cartMinOrderNotMet(String amount) {
    return 'Minimum order $amount';
  }

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersActive => 'Active orders';

  @override
  String get ordersHistory => 'Order history';

  @override
  String get ordersEmpty => 'No orders yet';

  @override
  String get ordersEmptyHint => 'Your orders will appear here';

  @override
  String get ordersDetailTitle => 'Order detail';

  @override
  String ordersNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get ordersNotFound => 'Order not found';

  @override
  String get ordersStatusSection => 'Order status';

  @override
  String get ordersItemsSection => 'Items';

  @override
  String get ordersItemsLoadError => 'Couldn\'t load items';

  @override
  String get ordersSummarySection => 'Summary';

  @override
  String get ordersAddressSection => 'Delivery address';

  @override
  String get ordersNotesSection => 'Notes';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusPreparing => 'Preparing';

  @override
  String get statusReadyForDelivery => 'Ready';

  @override
  String get statusOutForDelivery => 'Out for delivery';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusRefunded => 'Refunded';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutSummary => 'Order summary';

  @override
  String get checkoutDeliveryAddress => 'Delivery address';

  @override
  String get checkoutNoAddress => 'No delivery address';

  @override
  String get checkoutNoAddressHint => 'Add an address to continue.';

  @override
  String get checkoutAddAddress => 'Add address';

  @override
  String get checkoutOrderNotes => 'Notes for the restaurant';

  @override
  String get checkoutOrderNotesHint => 'e.g. Ring the bell, allergies...';

  @override
  String get checkoutPromoCodeTitle => 'Promo code';

  @override
  String get checkoutPromoHint => 'e.g. PIZZA10';

  @override
  String get checkoutPromoApply => 'Apply';

  @override
  String get checkoutPromoRemove => 'Remove';

  @override
  String checkoutPromoApplied(String code) {
    return 'Code \"$code\" applied';
  }

  @override
  String get checkoutPromoInvalid => 'Invalid code';

  @override
  String get checkoutSubtotal => 'Subtotal';

  @override
  String get checkoutDelivery => 'Delivery';

  @override
  String get checkoutDiscount => 'Discount';

  @override
  String get checkoutTotal => 'Total';

  @override
  String checkoutPay(String amount) {
    return 'Pay $amount';
  }

  @override
  String get checkoutProcessing => 'Processing...';

  @override
  String get checkoutCartEmpty => 'Your cart is empty';

  @override
  String get checkoutAddressRequired => 'Add a delivery address';

  @override
  String get orderConfirmedTitle => 'Order confirmed!';

  @override
  String get orderConfirmedSubtitle =>
      'Your order has been received and will be prepared shortly.';

  @override
  String get orderConfirmedOrder => 'Order';

  @override
  String get orderConfirmedTotal => 'Total';

  @override
  String get orderConfirmedEta => 'Estimated time';

  @override
  String get orderConfirmedDelivery => 'Delivery';

  @override
  String get orderConfirmedStatus => 'Status';

  @override
  String get orderConfirmedSeeOrders => 'See my orders';

  @override
  String get orderConfirmedBackToMarketplace => 'Back to marketplace';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileAddresses => 'Delivery addresses';

  @override
  String get profileOrders => 'Order history';

  @override
  String get profilePushNotifications => 'Push notifications';

  @override
  String get profilePushNotificationsSubtitle => 'Updates on your order status';

  @override
  String get profileLanguage => 'Lingua / Language';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileDisplayNameLabel => 'Display name';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get addressesTitle => 'Delivery addresses';

  @override
  String get addressesEmpty => 'No saved addresses';

  @override
  String get addressesAdd => 'Add address';

  @override
  String get addressesEdit => 'Edit address';

  @override
  String get addressesDelete => 'Delete address';

  @override
  String get addressesDeleteConfirm => 'Delete this address?';

  @override
  String get addressesLabel => 'Label';

  @override
  String get addressesStreet => 'Street and number';

  @override
  String get addressesCity => 'City';

  @override
  String get addressesPostalCode => 'Postal code';

  @override
  String get addressesProvince => 'Province';

  @override
  String get addressesNotes => 'Notes (optional)';

  @override
  String get addressesNotesHint => 'Floor, stairwell, apartment...';

  @override
  String get addressesSetDefault => 'Default address';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get favoritesEmptyHint =>
      'Restaurants and items you favorite will appear here';

  @override
  String get favoritesRestaurants => 'Restaurants';

  @override
  String get favoritesItems => 'Items';

  @override
  String get reviewPromptTitle => 'How was it?';

  @override
  String get reviewPromptCommentHint => 'Leave a comment (optional)';

  @override
  String get reviewPromptLater => 'Later';

  @override
  String get reviewPromptSubmit => 'Submit';

  @override
  String get reviewPromptThanks => 'Thanks for your review!';

  @override
  String get reviewLeaveTitle => 'Leave a review';

  @override
  String get reviewLeaveSubtitle =>
      'Help other customers by sharing your experience.';

  @override
  String get reviewLeaveButton => 'Leave review';

  @override
  String get reviewMine => 'Your review';

  @override
  String get reviewEdit => 'Edit';

  @override
  String get locationPromptTitle => 'Where are you?';

  @override
  String get locationPromptSubtitle =>
      'Add an address to discover restaurants delivering to your area.';

  @override
  String get locationPromptAdd => 'Add address';

  @override
  String get locationPromptSkip => 'Continue without address';

  @override
  String get welcomeTitle => 'Welcome to';

  @override
  String get welcomeStart => 'Start ordering';

  @override
  String get welcomeInfo => 'Browse the menu, order, and pay from your phone';

  @override
  String get welcomeTableOccupied => 'This table is already occupied';

  @override
  String get welcomeTableReserved => 'This table is reserved';

  @override
  String get welcomeAskStaff => 'Please ask the staff for help';

  @override
  String welcomeSeats(int count) {
    return '$count seats';
  }

  @override
  String get welcomeSignInCta => 'Sign in to save your order history';

  @override
  String get welcomeOccupied => 'OCCUPIED';

  @override
  String get welcomeReserved => 'RESERVED';

  @override
  String get staffLoginTitle => 'Staff sign-in';

  @override
  String get staffLoginSubtitle => 'Manage your restaurant';

  @override
  String get staffLoginSubmit => 'Sign in';

  @override
  String get staffLoginNoAccount => 'Don\'t have an account?';

  @override
  String get staffLoginRegister => 'Register restaurant';

  @override
  String get staffLoginConsumerPrompt => 'Are you a customer?';

  @override
  String get staffLoginConsumerLink => 'Go to the customer app';

  @override
  String get staffNavDashboard => 'Dashboard';

  @override
  String get staffNavOrders => 'Orders';

  @override
  String get staffNavMenu => 'Menu';

  @override
  String get staffNavFixedMenu => 'Set menus';

  @override
  String get staffNavTables => 'Tables';

  @override
  String get staffNavKitchen => 'Kitchen';

  @override
  String get staffNavUsers => 'Users';

  @override
  String get staffNavAnalytics => 'Analytics';

  @override
  String get staffNavSettings => 'Settings';

  @override
  String get staffNavPromos => 'Promo codes';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardOrdersToday => 'Orders today';

  @override
  String get dashboardRevenueToday => 'Revenue today';

  @override
  String get dashboardActiveOrders => 'Active orders';

  @override
  String get dashboardOccupiedTables => 'Occupied tables';

  @override
  String get dashboardRecentOrders => 'Recent orders';

  @override
  String get dashboardNoOrders => 'No orders yet';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get ordersStaffTitle => 'Orders';

  @override
  String get ordersStaffTabDineIn => 'Dine-in';

  @override
  String get ordersStaffTabDelivery => 'Delivery';

  @override
  String get ordersStaffSearch => 'Search orders...';

  @override
  String get ordersStaffFilterAll => 'All';

  @override
  String get ordersStaffEmpty => 'No orders';

  @override
  String get ordersStaffEmptyHint => 'Orders will appear here';

  @override
  String get ordersStaffNewOrder => 'New order';

  @override
  String get ordersStaffTotal => 'Total';

  @override
  String ordersStaffTable(String name) {
    return 'Table $name';
  }

  @override
  String get menuMgmtTitle => 'Menu management';

  @override
  String get menuMgmtCategories => 'Categories';

  @override
  String get menuMgmtItems => 'Items';

  @override
  String get menuMgmtAllCategories => 'All categories';

  @override
  String get menuMgmtSearchHint => 'Search dish...';

  @override
  String get menuMgmtAddCategory => 'New category';

  @override
  String get menuMgmtAddItem => 'New item';

  @override
  String get menuMgmtEmptyCategories => 'No categories';

  @override
  String get menuMgmtEmptyItems => 'No items';

  @override
  String get menuMgmtAvailable => 'Available';

  @override
  String get menuMgmtUnavailable => 'Unavailable';

  @override
  String get menuMgmtPriceLabel => 'Price';

  @override
  String get menuMgmtDescriptionLabel => 'Description';

  @override
  String get menuMgmtNameLabel => 'Name';

  @override
  String get menuMgmtImage => 'Image';

  @override
  String get menuMgmtTagsLabel => 'Tags';

  @override
  String get menuMgmtCategoryLabel => 'Category';

  @override
  String get tablesTitle => 'Tables';

  @override
  String get tablesAddTable => 'Add table';

  @override
  String get tablesEmpty => 'No tables';

  @override
  String get tablesStatusFree => 'Free';

  @override
  String get tablesStatusOccupied => 'Occupied';

  @override
  String get tablesStatusReserved => 'Reserved';

  @override
  String get tablesCapacity => 'Capacity';

  @override
  String get tablesZone => 'Zone';

  @override
  String get tablesQrCode => 'QR code';

  @override
  String get tablesDownloadQr => 'Download QR';

  @override
  String get tablesPrintQr => 'Print QR';

  @override
  String get usersTitle => 'Users';

  @override
  String get usersAddUser => 'Add user';

  @override
  String get usersEmpty => 'No users';

  @override
  String get usersRoleWaiter => 'Waiter';

  @override
  String get usersRoleKitchen => 'Kitchen';

  @override
  String get usersRoleManager => 'Manager';

  @override
  String get usersRoleAdmin => 'Admin';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsRevenue => 'Revenue';

  @override
  String get analyticsOrders => 'Orders';

  @override
  String get analyticsAvgOrder => 'Avg order';

  @override
  String get analyticsBestSellers => 'Best sellers';

  @override
  String get analyticsPeriodToday => 'Today';

  @override
  String get analyticsPeriodWeek => 'Week';

  @override
  String get analyticsPeriodMonth => 'Month';

  @override
  String get analyticsPeriodYear => 'Year';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsRestaurant => 'Restaurant';

  @override
  String get settingsDelivery => 'Delivery';

  @override
  String get settingsCategoryAndTags => 'Category and tags';

  @override
  String get settingsPromoCodes => 'Promo codes';

  @override
  String get settingsPromoCodesAction => 'Manage codes';

  @override
  String get settingsPromoCodesSubtitle =>
      'Create percent or fixed-amount discounts';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeLight => 'Light theme';

  @override
  String get settingsThemeDark => 'Dark theme';

  @override
  String get settingsThemeSystem => 'System theme';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsSoundAlerts => 'Sound alerts';

  @override
  String get settingsOrderNotifications => 'New order notifications';

  @override
  String get settingsDeliveryEnabled => 'Delivery enabled';

  @override
  String get settingsDeliveryFee => 'Delivery fee';

  @override
  String get settingsDeliveryRadius => 'Radius (km)';

  @override
  String get settingsDeliveryMin => 'Min order';

  @override
  String get settingsDeliveryEta => 'Estimated time (min)';

  @override
  String get settingsVacationMode => 'Vacation mode';

  @override
  String get settingsVacationModeSub => 'Temporarily pause new orders';

  @override
  String get settingsAddress => 'Address';

  @override
  String get settingsAddressNotSet => 'Address not set';

  @override
  String get settingsStripeConnect => 'Stripe Connect';

  @override
  String get settingsStripeConnected => 'Stripe Connect configured';

  @override
  String get settingsStripeNotConnected => 'Stripe Connect not configured';

  @override
  String get settingsStripeConnect_ => 'Connect Stripe';

  @override
  String get settingsBrandColors => 'Brand colors';

  @override
  String get settingsPrimaryColor => 'Primary color';

  @override
  String get settingsSecondaryColor => 'Secondary color';

  @override
  String get settingsBackgroundColor => 'Background';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get promoCodesTitle => 'Promo codes';

  @override
  String get promoCodesEmpty => 'No promo codes';

  @override
  String get promoCodesEmptyHint => 'Tap \"New code\" to create one.';

  @override
  String get promoCodesNew => 'New code';

  @override
  String promoCodesEdit(String code) {
    return 'Edit \"$code\"';
  }

  @override
  String get promoCodesActive => 'Active';

  @override
  String get promoCodesInactive => 'Inactive';

  @override
  String get promoCodesExpired => 'Expired';

  @override
  String get promoCodesExhausted => 'Exhausted';

  @override
  String get promoCodesCode => 'Code';

  @override
  String get promoCodesDiscount => 'Discount';

  @override
  String get promoCodesMinOrder => 'Min order (€)';

  @override
  String get promoCodesMaxUses => 'Max uses';

  @override
  String get promoCodesUnlimited => 'unlimited';

  @override
  String get promoCodesPerCustomer => 'Per customer';

  @override
  String get promoCodesValidUntil => 'Expiration';

  @override
  String get promoCodesNoExpiry => 'No expiration';

  @override
  String get promoCodesRemoveExpiry => 'Remove expiration';

  @override
  String get promoCodesDescription => 'Description (internal)';

  @override
  String get promoCodesActiveSub => 'When off, customers can\'t use it';

  @override
  String get promoCodesDeleteConfirm => 'Delete code?';

  @override
  String promoCodesUsesCount(int count) {
    return '$count uses';
  }

  @override
  String promoCodesUsesCountMax(int count, int max) {
    return '$count / $max uses';
  }

  @override
  String get kitchenTitle => 'Kitchen';

  @override
  String get kitchenEmpty => 'No orders to prepare';

  @override
  String get kitchenMarkReady => 'Ready';

  @override
  String get kitchenMarkPreparing => 'Preparing';

  @override
  String get notifPanelTitle => 'Notifications';

  @override
  String get notifPanelEmpty => 'No notifications';

  @override
  String get notifPanelMarkAllRead => 'Mark all as read';

  @override
  String get notifPanelClear => 'Clear all';

  @override
  String get registerTenantTitle => 'Register your\nbusiness';

  @override
  String get registerTenantSubtitle => 'Launch your business in minutes';

  @override
  String get registerTenantBusinessName => 'Business name *';

  @override
  String get registerTenantPhone => 'Phone';

  @override
  String get registerTenantAddress => 'Address';

  @override
  String get registerTenantBusinessEmail => 'Business email';

  @override
  String get registerTenantFirstName => 'First name';

  @override
  String get registerTenantLastName => 'Last name';

  @override
  String get registerTenantAccountEmail => 'Login email *';

  @override
  String get registerTenantPassword => 'Password *';

  @override
  String get registerTenantSubmit => 'Sign up';

  @override
  String get registerTenantContinue => 'Continue';

  @override
  String get registerTenantHaveAccount => 'Already have an account?';

  @override
  String get registerTenantSignIn => 'Sign in';

  @override
  String get registerTenantSuccess => 'Registration complete! Please sign in.';

  @override
  String get registerTenantTagline =>
      'Get your business up and running\nin just a few minutes';

  @override
  String get registerTenantCreateAccount => 'Create your account';

  @override
  String get registerTenantFormSubtitle =>
      'Fill in your details to register your business';

  @override
  String get registerTenantStep1Title => 'Business Info';

  @override
  String get registerTenantStep1Subtitle => 'Your business details';

  @override
  String get registerTenantStep2Title => 'Administrator Account';

  @override
  String get registerTenantStep2Subtitle => 'Your login credentials';

  @override
  String get registerTenantAccountEmailHint => 'You\'ll use this to log in';

  @override
  String get registerTenantPasswordHint => 'Minimum 6 characters';

  @override
  String get registerTenantConsumerPrompt => 'Are you a customer?';

  @override
  String get registerTenantConsumerLink => 'Sign in here';

  @override
  String get registerTenantNameRequired => 'Name is required';

  @override
  String get registerTenantEmailRequired => 'Email is required';

  @override
  String get registerTenantEmailInvalid => 'Enter a valid email';

  @override
  String get registerTenantPasswordRequired => 'Password is required';

  @override
  String get registerTenantPasswordShort =>
      'Password must be at least 6 characters';

  @override
  String get ordersStaffPaymentPaid => 'Paid';

  @override
  String get ordersStaffPaymentPending => 'Awaiting payment';

  @override
  String get ordersStaffPaymentFailed => 'Payment failed';

  @override
  String get ordersStaffPaymentRefunded => 'Refunded';

  @override
  String get ordersStaffCustomer => 'Customer';

  @override
  String get ordersStaffNotes => 'Notes';

  @override
  String get ordersStaffNoNotes => 'No notes';

  @override
  String get ordersStaffItems => 'Items';

  @override
  String get ordersStaffActions => 'Actions';

  @override
  String get ordersStaffConfirm => 'Confirm';

  @override
  String get ordersStaffStartPreparing => 'Start preparing';

  @override
  String get ordersStaffMarkReady => 'Mark ready';

  @override
  String get ordersStaffMarkOutForDelivery => 'Out for delivery';

  @override
  String get ordersStaffMarkDelivered => 'Delivered';

  @override
  String get ordersStaffCancel => 'Cancel order';

  @override
  String get ordersStaffRefund => 'Refund';

  @override
  String get ordersStaffPrintReceipt => 'Print receipt';

  @override
  String get ordersStaffCloseTable => 'Close table';

  @override
  String get manualOrderTitle => 'New manual order';

  @override
  String get manualOrderButton => 'New order';

  @override
  String get manualOrderCustomer => 'Customer name';

  @override
  String get manualOrderTable => 'Table';

  @override
  String get manualOrderSelectTable => 'Select table';

  @override
  String get manualOrderItems => 'Items';

  @override
  String get manualOrderAddItem => 'Add item';

  @override
  String get manualOrderNotes => 'Notes (optional)';

  @override
  String get manualOrderSubmit => 'Create order';

  @override
  String get manualOrderItemRequired => 'Add at least one item';

  @override
  String get menuMgmtAvailableHint => 'Visible to customers';

  @override
  String get menuMgmtUnavailableHint => 'Hidden from customers';

  @override
  String get menuMgmtDeleteCategoryConfirm => 'Delete this category?';

  @override
  String get menuMgmtDeleteItemConfirm => 'Delete this item?';

  @override
  String get menuMgmtItemAdded => 'Item added';

  @override
  String get menuMgmtItemUpdated => 'Item updated';

  @override
  String get menuMgmtItemDeleted => 'Item deleted';

  @override
  String get menuMgmtCategoryAdded => 'Category added';

  @override
  String get menuMgmtCategoryUpdated => 'Category updated';

  @override
  String get menuMgmtCategoryDeleted => 'Category deleted';

  @override
  String get menuMgmtPriceRequired => 'Enter a price';

  @override
  String get menuMgmtNameRequired => 'Enter a name';

  @override
  String get menuMgmtUploadImage => 'Upload image';

  @override
  String get menuMgmtChangeImage => 'Change image';

  @override
  String get menuMgmtRemoveImage => 'Remove image';

  @override
  String get tablesAddName => 'Name / Number';

  @override
  String get tablesEditTable => 'Edit table';

  @override
  String get tablesDeleteConfirm => 'Delete this table?';

  @override
  String get tablesShowQr => 'Show QR';

  @override
  String get tablesScanInstructions => 'Scan to order';

  @override
  String get dashboardWelcome => 'Welcome back';

  @override
  String get dashboardSubtitle => 'Here\'s a snapshot of your business';

  @override
  String get dashboardKpis => 'Stats';

  @override
  String get dashboardQuickActions => 'Quick actions';

  @override
  String get dashboardOrderNumber => 'Order';

  @override
  String get dashboardCustomer => 'Customer';

  @override
  String get dashboardAmount => 'Amount';

  @override
  String get dashboardTime => 'Time';

  @override
  String get dashboardTestCustomerView => 'Test customer view';

  @override
  String get dashboardTestCustomerViewSubtitle =>
      'Simulate scanning a table\'s QR code';

  @override
  String get dashboardTestCustomerViewSubtitleShort => 'Simulate QR scan';

  @override
  String get dashboardSelectTable => 'Select table';

  @override
  String get dashboardSelectTableHeader => 'Select a table';

  @override
  String get kitchenPending => 'Pending';

  @override
  String get kitchenInProgress => 'Preparing';

  @override
  String get kitchenReady => 'Ready';

  @override
  String get kitchenItem => 'Item';

  @override
  String get kitchenTable => 'Table';

  @override
  String get kitchenOrderNumber => 'Order';

  @override
  String get kitchenSince => 'Since';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorAuth => 'Authentication error';

  @override
  String get errorAuthInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorAuthEmailNotConfirmed =>
      'Please confirm your email before signing in.';

  @override
  String get errorAuthAlreadyRegistered =>
      'An account with this email already exists.';

  @override
  String get errorAuthPasswordShort => 'Password is too short.';

  @override
  String get errorAuthUserNotFound => 'No account found with this email.';

  @override
  String get errorAuthRateLimit =>
      'Too many attempts. Please try again in a few minutes.';

  @override
  String get errorAuthGeneric => 'Authentication error. Please try again.';

  @override
  String get errorDbDuplicate => 'An item with this data already exists.';

  @override
  String get errorDbForeignKey =>
      'Operation not allowed: this item is linked to others.';

  @override
  String get errorDbNotNull => 'A required field is missing.';

  @override
  String get errorDbPermission => 'You don\'t have permission for this action.';

  @override
  String get errorDbNotFound => 'Item not found.';

  @override
  String get errorDbGeneric => 'Server error. Please try again shortly.';

  @override
  String get errorStorageTooLarge => 'File too large.';

  @override
  String get errorStorageNotFound => 'File not found.';

  @override
  String get errorStorageNotAllowed => 'You can\'t upload this file.';

  @override
  String get errorStorageGeneric => 'Upload error. Please try again.';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorPermission => 'Permission denied';

  @override
  String get settingsRestaurantName => 'Name';

  @override
  String get settingsLogo => 'Logo';

  @override
  String get settingsCoverImage => 'Cover image';

  @override
  String get settingsPhone => 'Phone';

  @override
  String get settingsEmail => 'Email';

  @override
  String get settingsHours => 'Opening hours';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsRole => 'Role';

  @override
  String get usersHeader => 'User';

  @override
  String get usersEmail => 'Email';

  @override
  String get usersRole => 'Role';

  @override
  String get usersStatus => 'Status';

  @override
  String get usersLastLogin => 'Last login';

  @override
  String get usersActions => 'Actions';

  @override
  String get usersNever => 'Never';

  @override
  String get usersAdd => 'New user';

  @override
  String get usersDeactivate => 'Deactivate';

  @override
  String get usersActivate => 'Activate';

  @override
  String usersDeleteConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get usersDeletedToast => 'User deleted';

  @override
  String get kitchenDisplayTitle => 'Kitchen Display';

  @override
  String get fixedMenuTitle => 'Set menus';

  @override
  String get fixedMenuSubtitle => 'Manage your restaurant\'s set menus';

  @override
  String get fixedMenuAdd => 'New set menu';

  @override
  String get fixedMenuEmpty => 'No set menus';

  @override
  String get manualOrderSelectItems => 'Select items';

  @override
  String get manualOrderSubtotal => 'Subtotal';

  @override
  String get manualOrderEmptyCart => 'No items selected';

  @override
  String get orderDetailTitle => 'Order detail';

  @override
  String get orderDetailItems => 'Items';

  @override
  String get orderDetailNotes => 'Notes';

  @override
  String get orderDetailTotal => 'Total';

  @override
  String get orderDetailUpdateStatus => 'Change status';

  @override
  String get customerMenuChoose => 'Pick your favorite dishes';

  @override
  String get customerMenuNoMenu => 'Menu unavailable';

  @override
  String get customerMenuNoItems => 'No items in this category';

  @override
  String get customerMenuNoFixed => 'No set menus available';

  @override
  String get customerMenuFixedTab => 'Set menus';

  @override
  String get menuItemDialogNew => 'New item';

  @override
  String get menuItemDialogEdit => 'Edit item';

  @override
  String get menuItemDialogName => 'Name *';

  @override
  String get menuItemDialogCategory => 'Category *';

  @override
  String get menuItemDialogDescription => 'Description';

  @override
  String get menuItemDialogDescriptionHint => 'Item description...';

  @override
  String get menuItemDialogPrice => 'Price *';

  @override
  String get menuItemDialogPriceRequired => 'Enter a price';

  @override
  String get menuItemDialogPriceInvalid => 'Invalid price';

  @override
  String get menuItemDialogPrepTime => 'Prep time (min)';

  @override
  String get menuItemDialogCalories => 'Calories';

  @override
  String get menuItemDialogImage => 'Image';

  @override
  String get menuItemDialogUploadPhoto => 'Upload photo';

  @override
  String get menuItemDialogChangePhoto => 'Change photo';

  @override
  String get menuItemDialogRemove => 'Remove';

  @override
  String get menuItemDialogOrder => 'Order';

  @override
  String get menuItemDialogTags => 'Tags';

  @override
  String get menuItemDialogAllergens => 'Allergens';

  @override
  String get menuItemDialogAvailable => 'Available';

  @override
  String get menuItemDialogActive => 'Active';

  @override
  String get menuItemDialogDeleteConfirm => 'Delete this item?';

  @override
  String get menuItemDialogCreated => 'Item created';

  @override
  String get menuItemDialogUpdated => 'Item updated';

  @override
  String get menuItemDialogDeleted => 'Item deleted';

  @override
  String get menuItemDialogSelectCategoryFirst => 'Select a category';

  @override
  String get categoryDialogNew => 'New category';

  @override
  String get categoryDialogEdit => 'Edit category';

  @override
  String get categoryDialogName => 'Category name';

  @override
  String get categoryDialogDeleteConfirm => 'Delete this category?';

  @override
  String get analyticsPeriod => 'Period:';

  @override
  String get analyticsRefresh => 'Refresh';

  @override
  String get analyticsCompletedOrders => 'Completed orders';

  @override
  String get analyticsAvgTicket => 'Avg ticket';

  @override
  String get analyticsItemsSold => 'Items sold';

  @override
  String get analyticsRevenueTrend => 'Revenue trend';

  @override
  String get analyticsOrdersByStatus => 'Orders by status';

  @override
  String get analyticsTopItems => 'Top items';

  @override
  String get analyticsPeakHours => 'Peak hours';

  @override
  String get analyticsByCategory => 'By category';

  @override
  String get tableDialogNew => 'New table';

  @override
  String get tableDialogEdit => 'Edit table';

  @override
  String get tableDialogName => 'Name *';

  @override
  String get tableDialogSeats => 'Seats *';

  @override
  String get tableDialogSeatsRequired => 'Enter seat count';

  @override
  String get tableDialogInvalidNumber => 'Invalid value';

  @override
  String get tableDialogZone => 'Zone';

  @override
  String get tableDialogState => 'State';

  @override
  String get tableDialogActive => 'Active';

  @override
  String get tableDialogActiveSub => 'Visible and usable';

  @override
  String get tableDialogQrCode => 'QR code';

  @override
  String get tableDialogCreated => 'Table created';

  @override
  String get tableDialogUpdated => 'Table updated';

  @override
  String get tableDialogDeleted => 'Table deleted';

  @override
  String get tableDialogCreate => 'Create';

  @override
  String get categoryDialogEditTitle => 'Edit category';

  @override
  String get categoryDialogNewTitle => 'New category';

  @override
  String get categoryDialogNameLabel => 'Name *';

  @override
  String get categoryDialogDescription => 'Description';

  @override
  String get categoryDialogDescriptionHint => 'Optional description...';

  @override
  String get categoryDialogOrder => 'Order';

  @override
  String get categoryDialogActive => 'Active';

  @override
  String get categoryDialogActiveSub => 'Visible in the menu';

  @override
  String get categoryDialogCreated => 'Category created';

  @override
  String get categoryDialogUpdated => 'Category updated';

  @override
  String get categoryDialogDeleted => 'Category deleted';

  @override
  String get categoryDialogDeleteWarn =>
      'Warning: all items in this category will need to be reassigned.';

  @override
  String get userDialogNew => 'New user';

  @override
  String get userDialogEdit => 'Edit user';

  @override
  String get userDialogFirstName => 'First name';

  @override
  String get userDialogLastName => 'Last name';

  @override
  String get userDialogEmail => 'Email *';

  @override
  String get userDialogEmailInvalid => 'Enter a valid email';

  @override
  String get userDialogPassword => 'Password *';

  @override
  String get userDialogPasswordHint => 'At least 6 characters';

  @override
  String get userDialogRole => 'Role *';

  @override
  String get userDialogActive => 'Active user';

  @override
  String get userDialogActiveSubtitle => 'The user can access the system';

  @override
  String get userDialogInactiveSubtitle => 'The user cannot log in';

  @override
  String get userDialogCreate => 'Create user';

  @override
  String get userDialogCreated => 'User created successfully';

  @override
  String get userDialogUpdated => 'User updated';

  @override
  String get userDialogEmailExists => 'This email is already registered';

  @override
  String get userDialogRoleAdmin => 'Administrator';

  @override
  String get userDialogRoleManager => 'Manager';

  @override
  String get userDialogRoleWaiter => 'Waiter';

  @override
  String get userDialogRoleKitchen => 'Kitchen';

  @override
  String get userDialogRoleAdminDesc =>
      'Full access: menu, tables, orders, users and settings.';

  @override
  String get userDialogRoleManagerDesc =>
      'Manage menu, tables and orders. Cannot manage users or settings.';

  @override
  String get userDialogRoleWaiterDesc =>
      'Can view and manage orders only. Ideal for waiters.';

  @override
  String get userDialogRoleKitchenDesc =>
      'Sees orders to prepare only. Ideal for kitchen staff.';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get fixedMenuDialogNew => 'New set menu';

  @override
  String get fixedMenuDialogEdit => 'Edit set menu';

  @override
  String get fixedMenuDialogName => 'Name *';

  @override
  String get fixedMenuDialogNameRequired => 'Enter a name';

  @override
  String get fixedMenuDialogDescription => 'Description';

  @override
  String get fixedMenuDialogDescriptionHint => 'Optional menu description';

  @override
  String get fixedMenuDialogPrice => 'Price *';

  @override
  String get fixedMenuDialogPriceRequired => 'Enter a price';

  @override
  String get fixedMenuDialogPriceInvalid => 'Invalid price';

  @override
  String get fixedMenuDialogAvailability => 'Availability';

  @override
  String get fixedMenuDialogAlways => 'Always';

  @override
  String get fixedMenuDialogLunch => 'Lunch';

  @override
  String get fixedMenuDialogDinner => 'Dinner';

  @override
  String get fixedMenuDialogDays => 'Days (leave empty for all)';

  @override
  String get fixedMenuDialogActive => 'Active menu';

  @override
  String get fixedMenuDialogActiveSub => 'Visible to customers';

  @override
  String get fixedMenuDialogCreated => 'Menu created';

  @override
  String get fixedMenuDialogUpdated => 'Menu updated';

  @override
  String get fixedMenuDialogDeleted => 'Menu deleted';

  @override
  String get fixedMenuDialogDeleteWarn =>
      'This will also delete all linked courses and choices.';

  @override
  String get fixedMenuDialogDeleteTitle => 'Delete Menu';

  @override
  String fixedMenuDialogDeleteConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get fixedMenuDialogImageUrl => 'Image URL';

  @override
  String get fixedMenuCoursesTitle => 'Manage courses and choices';

  @override
  String get fixedMenuCoursesAdd => 'Add course';

  @override
  String get fixedMenuCoursesEmpty => 'No courses';

  @override
  String get fixedMenuCoursesEmptyHint =>
      'Add courses like Starter, Main, Dessert...';

  @override
  String fixedMenuCoursesDeleteConfirm(String name) {
    return 'Delete \"$name\" and all its choices?';
  }

  @override
  String get fixedMenuCoursesRequired => 'Required';

  @override
  String get fixedMenuCoursesDeleteTitle => 'Delete Course';

  @override
  String fixedMenuCoursesChoicesAvailable(int count) {
    return '$count choices available';
  }

  @override
  String get fixedMenuCoursesEditCourse => 'Edit Course';

  @override
  String get fixedMenuCoursesNewCourse => 'New Course';

  @override
  String get fixedMenuCoursesNameLabel => 'Name *';

  @override
  String get fixedMenuCoursesNameHint => 'e.g. Starter, Main, Dessert';

  @override
  String get fixedMenuCoursesDescription => 'Description';

  @override
  String get fixedMenuCoursesDescriptionHint => 'Optional description';

  @override
  String get fixedMenuCoursesRequiredToggle => 'Required selection';

  @override
  String get fixedMenuCoursesRequiredToggleSub => 'Customer must choose';

  @override
  String get fixedMenuChoicesAdd => 'Add Choice';

  @override
  String get fixedMenuChoicesEmpty => 'No choices. Add dishes from the menu.';

  @override
  String get fixedMenuChoicesRemove => 'Remove';

  @override
  String get fixedMenuChoicesSearchHint => 'Search dish...';

  @override
  String get fixedMenuChoicesNoItemsAvailable => 'No dishes available';

  @override
  String get fixedMenuChoicesSupplement => 'Supplement';

  @override
  String get fixedMenuChoicesDefault => 'Default';

  @override
  String get fixedMenuChoicesAddBtn => 'Add';

  @override
  String get tooltipEdit => 'Edit';

  @override
  String get tooltipDelete => 'Delete';

  @override
  String get fixedMenuCardChooseCourses => 'Choose your courses';

  @override
  String get fixedMenuSelectionMenuNotFound => 'Menu not found';

  @override
  String get fixedMenuSelectionSelectAllRequired =>
      'Select all required courses';

  @override
  String fixedMenuSelectionAddToCart(String price) {
    return 'Add to cart - €$price';
  }

  @override
  String get fixedMenuSelectionOptional => 'Optional';

  @override
  String get fixedMenuSelectionNoChoices =>
      'No choices available for this course';

  @override
  String get fixedMenuSelectionRecommended => 'Recommended';

  @override
  String fixedMenuSelectionAddedToCart(String name) {
    return '$name added to cart';
  }

  @override
  String get editAddressTitle => 'Edit address';

  @override
  String get editAddressUseMyLocation => 'Use my location';

  @override
  String get editAddressLocating => 'Locating...';

  @override
  String get editAddressPermissionDenied =>
      'Permission denied. Enter the address manually.';

  @override
  String editAddressUnavailable(String message) {
    return 'Location unavailable: $message';
  }

  @override
  String get editAddressReverseFail =>
      'Could not read the address. Try again or enter it manually.';

  @override
  String get editAddressRequired => 'Enter an address';

  @override
  String get editAddressUpdatedGeo => 'Address updated and geolocated';

  @override
  String get editAddressSavedNoGeo => 'Address saved (geolocation failed)';

  @override
  String get editAddressLabel => 'Full address';

  @override
  String get editAddressHint => '5 Via Roma, 20121 Milan';

  @override
  String get editAddressFormatHelp =>
      'Format: street + number, postal code + city. Coordinates are computed on save.';

  @override
  String get settingsNotConfigured => 'Not configured';

  @override
  String get settingsLoadingError => 'Failed to load';

  @override
  String get settingsNotificationsOrders => 'Order notifications';

  @override
  String get settingsNotificationsOrdersSub => 'Receive alerts for new orders';

  @override
  String get settingsSoundAlertsTitle => 'Sound alerts';

  @override
  String get settingsSoundAlertsSub => 'Play a sound for notifications';

  @override
  String get settingsVibrationTitle => 'Vibration';

  @override
  String get settingsVibrationSub => 'Vibrate for notifications (mobile)';

  @override
  String get settingsVibrationSubShort => 'Vibrate for notifications';

  @override
  String get settingsOrdersManagement => 'Orders Management';

  @override
  String get settingsAutoConfirm => 'Auto-confirm';

  @override
  String get settingsAutoConfirmSub => 'Automatically confirm new orders';

  @override
  String get settingsSignOutTitle => 'Confirm Sign Out';

  @override
  String get settingsSignOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get settingsNotificationSound => 'Notification sound';

  @override
  String get settingsPasswordMinChars => 'Minimum 6 characters';

  @override
  String get settingsPasswordUpdated => 'Password updated successfully';

  @override
  String get settingsNewPassword => 'New password';

  @override
  String get settingsConfirmPassword => 'Confirm password';

  @override
  String get settingsPasswordMismatch => 'Passwords do not match';

  @override
  String get settingsColorsSaved => 'Colors saved successfully';

  @override
  String settingsSaveError(String message) {
    return 'Save error: $message';
  }

  @override
  String get settingsPrimaryColorHint => 'Main brand color';

  @override
  String get settingsSecondaryColorHint => 'Color for accents and details';

  @override
  String get settingsBackgroundColorHint => 'Page background (light theme)';

  @override
  String get settingsAccent => 'Accent';

  @override
  String get settingsSaveColors => 'Save Colors';

  @override
  String get settingsStripeOnboardingTitle => 'Configure Stripe';

  @override
  String settingsStripeOnboardingBody(String url) {
    return 'Open this link to complete the setup:\n\n$url';
  }

  @override
  String get settingsDeliverySaved => 'Delivery settings saved';

  @override
  String get settingsEnableDelivery => 'Enable delivery';

  @override
  String get settingsEnableDeliverySub =>
      'The restaurant will appear in the marketplace for home delivery';

  @override
  String get settingsEnableDeliverySubShort => 'Show in marketplace';

  @override
  String get settingsVacation => 'On vacation';

  @override
  String get settingsVacationSub => 'Temporarily suspends incoming orders';

  @override
  String get settingsVacationSubShort => 'Pauses orders';

  @override
  String get settingsDeliveryCost => 'Delivery fee';

  @override
  String get settingsDeliveryMinOrder => 'Minimum order';

  @override
  String get settingsDeliveryRadiusLabel => 'Delivery radius';

  @override
  String get settingsDeliveryEtaLabel => 'Estimated time';

  @override
  String get settingsStripeNotConfigured => 'Stripe not configured';

  @override
  String get settingsStripeNotConnectedSub => ' — required to receive payments';

  @override
  String get settingsStripeConfigure => 'Configure';

  @override
  String get settingsGeoFail =>
      'Geocoding failed. Verify the address is correct and complete.';

  @override
  String get settingsGeoFailShort => 'Geocoding failed. Verify the address.';

  @override
  String get settingsGeoSuccess => 'Geolocation complete';

  @override
  String get settingsNotGeolocated => 'Restaurant not geolocated';

  @override
  String get settingsNotGeolocatedShort => 'Not geolocated';

  @override
  String get settingsSetAddress => 'Set address';

  @override
  String get settingsGeoMissingHint =>
      'Without coordinates the restaurant will not appear in the customer marketplace. Retry geocoding or edit the address.';

  @override
  String get settingsGeoAddressFirst =>
      'Set the restaurant address first: it is needed to compute marketplace distances.';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsManageCodes => 'Manage codes';

  @override
  String settingsVersion(String value) {
    return 'Version $value';
  }

  @override
  String get settingsRestaurantInfo => 'Restaurant information';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLightShort => 'Light';

  @override
  String get settingsThemeDarkShort => 'Dark';

  @override
  String get settingsThemeSystemShort => 'System';

  @override
  String get settingsCuisineType => 'Cuisine type';

  @override
  String get settingsDietaryTags => 'Dietary tags';

  @override
  String get settingsDietaryTagsHint => 'Shown as filters in the marketplace.';

  @override
  String get settingsSaved => 'Saved';

  @override
  String get settingsSaving => 'Saving...';

  @override
  String get settingsNoTenantError => 'Error: no restaurant linked';

  @override
  String get settingsRetryGeocoding => 'Retry geocoding';

  @override
  String get settingsSoundClassic => 'Classic';

  @override
  String get settingsSoundBell => 'Bell';

  @override
  String get settingsSoundChime => 'Chime';

  @override
  String get analyticsTotalRevenue => 'Total Revenue';
}
