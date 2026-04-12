/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'SubitoGusto';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;

  // Order Number Prefix
  static const String orderNumberPrefix = 'ORD';
}

/// Allergen constants
class Allergens {
  static const String glutine = 'glutine';
  static const String crostacei = 'crostacei';
  static const String uova = 'uova';
  static const String pesce = 'pesce';
  static const String arachidi = 'arachidi';
  static const String soia = 'soia';
  static const String latte = 'latte';
  static const String fruttaGuscio = 'frutta_guscio';
  static const String sedano = 'sedano';
  static const String senape = 'senape';
  static const String sesamo = 'sesamo';
  static const String solfiti = 'solfiti';
  static const String lupini = 'lupini';
  static const String molluschi = 'molluschi';

  static const List<String> all = [
    glutine,
    crostacei,
    uova,
    pesce,
    arachidi,
    soia,
    latte,
    fruttaGuscio,
    sedano,
    senape,
    sesamo,
    solfiti,
    lupini,
    molluschi,
  ];

  static String getDisplayName(String allergen) {
    switch (allergen) {
      case glutine:
        return 'Glutine';
      case crostacei:
        return 'Crostacei';
      case uova:
        return 'Uova';
      case pesce:
        return 'Pesce';
      case arachidi:
        return 'Arachidi';
      case soia:
        return 'Soia';
      case latte:
        return 'Latte';
      case fruttaGuscio:
        return 'Frutta a guscio';
      case sedano:
        return 'Sedano';
      case senape:
        return 'Senape';
      case sesamo:
        return 'Sesamo';
      case solfiti:
        return 'Solfiti';
      case lupini:
        return 'Lupini';
      case molluschi:
        return 'Molluschi';
      default:
        return allergen;
    }
  }

  static String getEmoji(String allergen) {
    switch (allergen) {
      case glutine:
        return '🌾';
      case crostacei:
        return '🦐';
      case uova:
        return '🥚';
      case pesce:
        return '🐟';
      case arachidi:
        return '🥜';
      case soia:
        return '🫘';
      case latte:
        return '🥛';
      case fruttaGuscio:
        return '🌰';
      case sedano:
        return '🥬';
      case senape:
        return '🟡';
      case sesamo:
        return '⚪';
      case solfiti:
        return '🍷';
      case lupini:
        return '🫛';
      case molluschi:
        return '🦪';
      default:
        return '⚠️';
    }
  }
}

/// Order status constants
class OrderStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String preparing = 'preparing';
  static const String ready = 'ready';
  static const String served = 'served';
  static const String paid = 'paid';
  static const String cancelled = 'cancelled';

  static const List<String> all = [
    pending,
    confirmed,
    preparing,
    ready,
    served,
    paid,
    cancelled,
  ];

  static const List<String> active = [
    pending,
    confirmed,
    preparing,
    ready,
  ];

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'In attesa';
      case confirmed:
        return 'Confermato';
      case preparing:
        return 'In preparazione';
      case ready:
        return 'Pronto';
      case served:
        return 'Servito';
      case paid:
        return 'Pagato';
      case cancelled:
        return 'Annullato';
      default:
        return status;
    }
  }

  static String getEmoji(String status) {
    switch (status) {
      case pending:
        return '⏳';
      case confirmed:
        return '✅';
      case preparing:
        return '👨‍🍳';
      case ready:
        return '🔔';
      case served:
        return '🍽️';
      case paid:
        return '💰';
      case cancelled:
        return '❌';
      default:
        return '❓';
    }
  }
}

/// Table status constants
class TableStatus {
  static const String available = 'available';
  static const String occupied = 'occupied';
  static const String reserved = 'reserved';

  static const List<String> all = [available, occupied, reserved];

  static String getDisplayName(String status) {
    switch (status) {
      case available:
        return 'Disponibile';
      case occupied:
        return 'Occupato';
      case reserved:
        return 'Prenotato';
      default:
        return status;
    }
  }
}

/// User role constants
class UserRole {
  static const String admin = 'admin';
  static const String manager = 'manager';
  static const String waiter = 'waiter';
  static const String kitchen = 'kitchen';

  static const List<String> all = [admin, manager, waiter, kitchen];

  static String getDisplayName(String role) {
    switch (role) {
      case admin:
        return 'Amministratore';
      case manager:
        return 'Manager';
      case waiter:
        return 'Cameriere';
      case kitchen:
        return 'Cucina';
      default:
        return role;
    }
  }
}

/// Menu item tags
class MenuTags {
  static const String vegetariano = 'vegetariano';
  static const String vegano = 'vegano';
  static const String glutenFree = 'gluten_free';
  static const String piccante = 'piccante';
  static const String chefsChoice = 'chefs_choice';
  static const String novita = 'novita';
  static const String bio = 'bio';

  static const List<String> all = [
    vegetariano,
    vegano,
    glutenFree,
    piccante,
    chefsChoice,
    novita,
    bio,
  ];

  static String getDisplayName(String tag) {
    switch (tag) {
      case vegetariano:
        return 'Vegetariano';
      case vegano:
        return 'Vegano';
      case glutenFree:
        return 'Senza Glutine';
      case piccante:
        return 'Piccante';
      case chefsChoice:
        return 'Scelta dello Chef';
      case novita:
        return 'Novità';
      case bio:
        return 'Bio';
      default:
        return tag;
    }
  }

  static String getEmoji(String tag) {
    switch (tag) {
      case vegetariano:
        return '🥬';
      case vegano:
        return '🌱';
      case glutenFree:
        return '🚫🌾';
      case piccante:
        return '🌶️';
      case chefsChoice:
        return '⭐';
      case novita:
        return '🆕';
      case bio:
        return '🌿';
      default:
        return '🏷️';
    }
  }
}
