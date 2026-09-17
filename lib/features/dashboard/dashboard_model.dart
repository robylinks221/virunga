class DashboardData {
  const DashboardData({
    required this.scope,
    required this.raw,
  });

  final String scope;
  final Map<String, dynamic> raw;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      scope: json['scope']?.toString() ?? 'member',
      raw: json,
    );
  }

  dynamic value(List<String> keys) {
    for (final key in keys) {
      if (raw.containsKey(key) && raw[key] != null) {
        return raw[key];
      }
    }
    return null;
  }

  String? stringValue(List<String> keys) {
    final v = value(keys);
    if (v == null) return null;

    if (v is Map) {
      for (final key in const ['name', 'label', 'title', 'full_name']) {
        final nested = v[key];
        if (nested != null && nested.toString().trim().isNotEmpty) {
          return nested.toString();
        }
      }
    }

    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  num? numberValue(List<String> keys) {
    final v = value(keys);
    if (v is num) return v;
    if (v != null) return num.tryParse(v.toString());
    return null;
  }

  int? intValue(List<String> keys) {
    final n = numberValue(keys);
    return n?.toInt();
  }
}

class UserProfileData {
  const UserProfileData({
    required this.firstName,
    required this.lastName,
    this.email,
  });

  final String firstName;
  final String lastName;
  final String? email;

  String get fullName {
    final value = '$firstName $lastName'.trim();
    return value.isEmpty ? 'Virunga Member' : value;
  }

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString(),
    );
  }
}

/// Authenticated user information returned by /api/auth/me/.
///
/// The API's User schema includes `role`, which is the correct field to use
/// when deciding whether the logged-in member is a craft seller.
class CurrentUserData {
  const CurrentUserData({
    this.id,
    required this.phoneNumber,
    this.email,
    required this.firstName,
    required this.lastName,
    this.groupId,
    required this.groupName,
    required this.role,
    required this.community,
    required this.isGroupLeader,
  });

  final int? id;
  final String phoneNumber;
  final String? email;
  final String firstName;
  final String lastName;
  final int? groupId;
  final String groupName;
  final String role;
  final String community;
  final bool isGroupLeader;

  String get fullName => '$firstName $lastName'.trim();

  factory CurrentUserData.fromJson(Map<String, dynamic> json) {
    return CurrentUserData(
      id: int.tryParse(json['id']?.toString() ?? ''),
      phoneNumber: json['phone_number']?.toString() ?? '',
      email: json['email']?.toString(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      groupId: int.tryParse(json['group']?.toString() ?? ''),
      groupName: json['group_name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      community: json['community']?.toString() ?? '',
      isGroupLeader: json['is_group_leader'] == true,
    );
  }
}

class WalletData {
  const WalletData({
    required this.id,
    required this.userId,
    required this.ownerName,
    required this.phoneNumber,
    required this.balance,
    required this.isFrozen,
    this.createdAt,
  });

  final int? id;
  final int? userId;
  final String ownerName;
  final String phoneNumber;
  final double balance;
  final bool isFrozen;
  final DateTime? createdAt;

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: int.tryParse(json['id']?.toString() ?? ''),
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      ownerName: json['owner_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      balance: double.tryParse(json['balance']?.toString() ?? '') ?? 0,
      isFrozen: json['is_frozen'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class LedgerEntryData {
  const LedgerEntryData({
    required this.id,
    required this.amount,
    required this.signedAmount,
    required this.direction,
    required this.entryType,
    required this.entryTypeDisplay,
    required this.balanceAfter,
    required this.description,
    required this.reference,
    required this.createdAt,
  });

  final int? id;
  final double amount;
  final double signedAmount;
  final String direction;
  final String entryType;
  final String entryTypeDisplay;
  final double balanceAfter;
  final String description;
  final String reference;
  final DateTime? createdAt;

  bool get isCredit =>
      signedAmount > 0 ||
      direction.toLowerCase().contains('credit') ||
      direction.toLowerCase().contains('in');

  factory LedgerEntryData.fromJson(Map<String, dynamic> json) {
    return LedgerEntryData(
      id: int.tryParse(json['id']?.toString() ?? ''),
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      signedAmount:
          double.tryParse(json['signed_amount']?.toString() ?? '') ?? 0,
      direction: json['direction']?.toString() ?? '',
      entryType: json['entry_type']?.toString() ?? '',
      entryTypeDisplay: json['entry_type_display']?.toString() ?? '',
      balanceAfter:
          double.tryParse(json['balance_after']?.toString() ?? '') ?? 0,
      description: json['description']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class DashboardBundle {
  const DashboardBundle({
    required this.dashboard,
    required this.profile,
    this.currentUser,
    this.wallet,
    this.entries = const [],
  });

  final DashboardData dashboard;
  final UserProfileData profile;
  final CurrentUserData? currentUser;
  final WalletData? wallet;
  final List<LedgerEntryData> entries;

  String get scope => dashboard.scope;
}
