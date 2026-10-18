// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MailProviderType, int> provider =
      GeneratedColumn<int>(
        'provider',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MailProviderType>($AccountsTable.$converterprovider);
  @override
  late final GeneratedColumnWithTypeConverter<AuthKind, int> authKind =
      GeneratedColumn<int>(
        'auth_kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AuthKind>($AccountsTable.$converterauthKind);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imapHostMeta = const VerificationMeta(
    'imapHost',
  );
  @override
  late final GeneratedColumn<String> imapHost = GeneratedColumn<String>(
    'imap_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imapPortMeta = const VerificationMeta(
    'imapPort',
  );
  @override
  late final GeneratedColumn<int> imapPort = GeneratedColumn<int>(
    'imap_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(993),
  );
  static const VerificationMeta _smtpHostMeta = const VerificationMeta(
    'smtpHost',
  );
  @override
  late final GeneratedColumn<String> smtpHost = GeneratedColumn<String>(
    'smtp_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _smtpPortMeta = const VerificationMeta(
    'smtpPort',
  );
  @override
  late final GeneratedColumn<int> smtpPort = GeneratedColumn<int>(
    'smtp_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(587),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, int> syncState =
      GeneratedColumn<int>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<SyncState>($AccountsTable.$convertersyncState);
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quotaUsedBytesMeta = const VerificationMeta(
    'quotaUsedBytes',
  );
  @override
  late final GeneratedColumn<int> quotaUsedBytes = GeneratedColumn<int>(
    'quota_used_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quotaTotalBytesMeta = const VerificationMeta(
    'quotaTotalBytes',
  );
  @override
  late final GeneratedColumn<int> quotaTotalBytes = GeneratedColumn<int>(
    'quota_total_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bytesTodayMeta = const VerificationMeta(
    'bytesToday',
  );
  @override
  late final GeneratedColumn<int> bytesToday = GeneratedColumn<int>(
    'bytes_today',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bytesDayMeta = const VerificationMeta(
    'bytesDay',
  );
  @override
  late final GeneratedColumn<DateTime> bytesDay = GeneratedColumn<DateTime>(
    'bytes_day',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    provider,
    authKind,
    email,
    displayName,
    imapHost,
    imapPort,
    smtpHost,
    smtpPort,
    syncState,
    lastError,
    lastSyncAt,
    quotaUsedBytes,
    quotaTotalBytes,
    bytesToday,
    bytesDay,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('imap_host')) {
      context.handle(
        _imapHostMeta,
        imapHost.isAcceptableOrUnknown(data['imap_host']!, _imapHostMeta),
      );
    }
    if (data.containsKey('imap_port')) {
      context.handle(
        _imapPortMeta,
        imapPort.isAcceptableOrUnknown(data['imap_port']!, _imapPortMeta),
      );
    }
    if (data.containsKey('smtp_host')) {
      context.handle(
        _smtpHostMeta,
        smtpHost.isAcceptableOrUnknown(data['smtp_host']!, _smtpHostMeta),
      );
    }
    if (data.containsKey('smtp_port')) {
      context.handle(
        _smtpPortMeta,
        smtpPort.isAcceptableOrUnknown(data['smtp_port']!, _smtpPortMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('quota_used_bytes')) {
      context.handle(
        _quotaUsedBytesMeta,
        quotaUsedBytes.isAcceptableOrUnknown(
          data['quota_used_bytes']!,
          _quotaUsedBytesMeta,
        ),
      );
    }
    if (data.containsKey('quota_total_bytes')) {
      context.handle(
        _quotaTotalBytesMeta,
        quotaTotalBytes.isAcceptableOrUnknown(
          data['quota_total_bytes']!,
          _quotaTotalBytesMeta,
        ),
      );
    }
    if (data.containsKey('bytes_today')) {
      context.handle(
        _bytesTodayMeta,
        bytesToday.isAcceptableOrUnknown(data['bytes_today']!, _bytesTodayMeta),
      );
    }
    if (data.containsKey('bytes_day')) {
      context.handle(
        _bytesDayMeta,
        bytesDay.isAcceptableOrUnknown(data['bytes_day']!, _bytesDayMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      provider: $AccountsTable.$converterprovider.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}provider'],
        )!,
      ),
      authKind: $AccountsTable.$converterauthKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}auth_kind'],
        )!,
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      imapHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imap_host'],
      )!,
      imapPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imap_port'],
      )!,
      smtpHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smtp_host'],
      )!,
      smtpPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}smtp_port'],
      )!,
      syncState: $AccountsTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      quotaUsedBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quota_used_bytes'],
      ),
      quotaTotalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quota_total_bytes'],
      ),
      bytesToday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes_today'],
      )!,
      bytesDay: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}bytes_day'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MailProviderType, int, int> $converterprovider =
      const EnumIndexConverter<MailProviderType>(MailProviderType.values);
  static JsonTypeConverter2<AuthKind, int, int> $converterauthKind =
      const EnumIndexConverter<AuthKind>(AuthKind.values);
  static JsonTypeConverter2<SyncState, int, int> $convertersyncState =
      const EnumIndexConverter<SyncState>(SyncState.values);
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final MailProviderType provider;
  final AuthKind authKind;
  final String email;
  final String displayName;
  final String imapHost;
  final int imapPort;
  final String smtpHost;
  final int smtpPort;
  final SyncState syncState;
  final String? lastError;
  final DateTime? lastSyncAt;
  final int? quotaUsedBytes;
  final int? quotaTotalBytes;

  /// Bytes downloaded today (Gmail caps IMAP at ~2,500 MB/day; we stop at 2,000).
  final int bytesToday;
  final DateTime? bytesDay;
  final DateTime createdAt;
  const AccountRow({
    required this.id,
    required this.provider,
    required this.authKind,
    required this.email,
    required this.displayName,
    required this.imapHost,
    required this.imapPort,
    required this.smtpHost,
    required this.smtpPort,
    required this.syncState,
    this.lastError,
    this.lastSyncAt,
    this.quotaUsedBytes,
    this.quotaTotalBytes,
    required this.bytesToday,
    this.bytesDay,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['provider'] = Variable<int>(
        $AccountsTable.$converterprovider.toSql(provider),
      );
    }
    {
      map['auth_kind'] = Variable<int>(
        $AccountsTable.$converterauthKind.toSql(authKind),
      );
    }
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    map['imap_host'] = Variable<String>(imapHost);
    map['imap_port'] = Variable<int>(imapPort);
    map['smtp_host'] = Variable<String>(smtpHost);
    map['smtp_port'] = Variable<int>(smtpPort);
    {
      map['sync_state'] = Variable<int>(
        $AccountsTable.$convertersyncState.toSql(syncState),
      );
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    if (!nullToAbsent || quotaUsedBytes != null) {
      map['quota_used_bytes'] = Variable<int>(quotaUsedBytes);
    }
    if (!nullToAbsent || quotaTotalBytes != null) {
      map['quota_total_bytes'] = Variable<int>(quotaTotalBytes);
    }
    map['bytes_today'] = Variable<int>(bytesToday);
    if (!nullToAbsent || bytesDay != null) {
      map['bytes_day'] = Variable<DateTime>(bytesDay);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      provider: Value(provider),
      authKind: Value(authKind),
      email: Value(email),
      displayName: Value(displayName),
      imapHost: Value(imapHost),
      imapPort: Value(imapPort),
      smtpHost: Value(smtpHost),
      smtpPort: Value(smtpPort),
      syncState: Value(syncState),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      quotaUsedBytes: quotaUsedBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(quotaUsedBytes),
      quotaTotalBytes: quotaTotalBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(quotaTotalBytes),
      bytesToday: Value(bytesToday),
      bytesDay: bytesDay == null && nullToAbsent
          ? const Value.absent()
          : Value(bytesDay),
      createdAt: Value(createdAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      provider: $AccountsTable.$converterprovider.fromJson(
        serializer.fromJson<int>(json['provider']),
      ),
      authKind: $AccountsTable.$converterauthKind.fromJson(
        serializer.fromJson<int>(json['authKind']),
      ),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      imapHost: serializer.fromJson<String>(json['imapHost']),
      imapPort: serializer.fromJson<int>(json['imapPort']),
      smtpHost: serializer.fromJson<String>(json['smtpHost']),
      smtpPort: serializer.fromJson<int>(json['smtpPort']),
      syncState: $AccountsTable.$convertersyncState.fromJson(
        serializer.fromJson<int>(json['syncState']),
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      quotaUsedBytes: serializer.fromJson<int?>(json['quotaUsedBytes']),
      quotaTotalBytes: serializer.fromJson<int?>(json['quotaTotalBytes']),
      bytesToday: serializer.fromJson<int>(json['bytesToday']),
      bytesDay: serializer.fromJson<DateTime?>(json['bytesDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provider': serializer.toJson<int>(
        $AccountsTable.$converterprovider.toJson(provider),
      ),
      'authKind': serializer.toJson<int>(
        $AccountsTable.$converterauthKind.toJson(authKind),
      ),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'imapHost': serializer.toJson<String>(imapHost),
      'imapPort': serializer.toJson<int>(imapPort),
      'smtpHost': serializer.toJson<String>(smtpHost),
      'smtpPort': serializer.toJson<int>(smtpPort),
      'syncState': serializer.toJson<int>(
        $AccountsTable.$convertersyncState.toJson(syncState),
      ),
      'lastError': serializer.toJson<String?>(lastError),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'quotaUsedBytes': serializer.toJson<int?>(quotaUsedBytes),
      'quotaTotalBytes': serializer.toJson<int?>(quotaTotalBytes),
      'bytesToday': serializer.toJson<int>(bytesToday),
      'bytesDay': serializer.toJson<DateTime?>(bytesDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AccountRow copyWith({
    String? id,
    MailProviderType? provider,
    AuthKind? authKind,
    String? email,
    String? displayName,
    String? imapHost,
    int? imapPort,
    String? smtpHost,
    int? smtpPort,
    SyncState? syncState,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> lastSyncAt = const Value.absent(),
    Value<int?> quotaUsedBytes = const Value.absent(),
    Value<int?> quotaTotalBytes = const Value.absent(),
    int? bytesToday,
    Value<DateTime?> bytesDay = const Value.absent(),
    DateTime? createdAt,
  }) => AccountRow(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    authKind: authKind ?? this.authKind,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    imapHost: imapHost ?? this.imapHost,
    imapPort: imapPort ?? this.imapPort,
    smtpHost: smtpHost ?? this.smtpHost,
    smtpPort: smtpPort ?? this.smtpPort,
    syncState: syncState ?? this.syncState,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    quotaUsedBytes: quotaUsedBytes.present
        ? quotaUsedBytes.value
        : this.quotaUsedBytes,
    quotaTotalBytes: quotaTotalBytes.present
        ? quotaTotalBytes.value
        : this.quotaTotalBytes,
    bytesToday: bytesToday ?? this.bytesToday,
    bytesDay: bytesDay.present ? bytesDay.value : this.bytesDay,
    createdAt: createdAt ?? this.createdAt,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      authKind: data.authKind.present ? data.authKind.value : this.authKind,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      imapHost: data.imapHost.present ? data.imapHost.value : this.imapHost,
      imapPort: data.imapPort.present ? data.imapPort.value : this.imapPort,
      smtpHost: data.smtpHost.present ? data.smtpHost.value : this.smtpHost,
      smtpPort: data.smtpPort.present ? data.smtpPort.value : this.smtpPort,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      quotaUsedBytes: data.quotaUsedBytes.present
          ? data.quotaUsedBytes.value
          : this.quotaUsedBytes,
      quotaTotalBytes: data.quotaTotalBytes.present
          ? data.quotaTotalBytes.value
          : this.quotaTotalBytes,
      bytesToday: data.bytesToday.present
          ? data.bytesToday.value
          : this.bytesToday,
      bytesDay: data.bytesDay.present ? data.bytesDay.value : this.bytesDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('authKind: $authKind, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('imapHost: $imapHost, ')
          ..write('imapPort: $imapPort, ')
          ..write('smtpHost: $smtpHost, ')
          ..write('smtpPort: $smtpPort, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('quotaUsedBytes: $quotaUsedBytes, ')
          ..write('quotaTotalBytes: $quotaTotalBytes, ')
          ..write('bytesToday: $bytesToday, ')
          ..write('bytesDay: $bytesDay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    provider,
    authKind,
    email,
    displayName,
    imapHost,
    imapPort,
    smtpHost,
    smtpPort,
    syncState,
    lastError,
    lastSyncAt,
    quotaUsedBytes,
    quotaTotalBytes,
    bytesToday,
    bytesDay,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.authKind == this.authKind &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.imapHost == this.imapHost &&
          other.imapPort == this.imapPort &&
          other.smtpHost == this.smtpHost &&
          other.smtpPort == this.smtpPort &&
          other.syncState == this.syncState &&
          other.lastError == this.lastError &&
          other.lastSyncAt == this.lastSyncAt &&
          other.quotaUsedBytes == this.quotaUsedBytes &&
          other.quotaTotalBytes == this.quotaTotalBytes &&
          other.bytesToday == this.bytesToday &&
          other.bytesDay == this.bytesDay &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<MailProviderType> provider;
  final Value<AuthKind> authKind;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String> imapHost;
  final Value<int> imapPort;
  final Value<String> smtpHost;
  final Value<int> smtpPort;
  final Value<SyncState> syncState;
  final Value<String?> lastError;
  final Value<DateTime?> lastSyncAt;
  final Value<int?> quotaUsedBytes;
  final Value<int?> quotaTotalBytes;
  final Value<int> bytesToday;
  final Value<DateTime?> bytesDay;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.authKind = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.imapHost = const Value.absent(),
    this.imapPort = const Value.absent(),
    this.smtpHost = const Value.absent(),
    this.smtpPort = const Value.absent(),
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.quotaUsedBytes = const Value.absent(),
    this.quotaTotalBytes = const Value.absent(),
    this.bytesToday = const Value.absent(),
    this.bytesDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required MailProviderType provider,
    required AuthKind authKind,
    required String email,
    this.displayName = const Value.absent(),
    this.imapHost = const Value.absent(),
    this.imapPort = const Value.absent(),
    this.smtpHost = const Value.absent(),
    this.smtpPort = const Value.absent(),
    this.syncState = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.quotaUsedBytes = const Value.absent(),
    this.quotaTotalBytes = const Value.absent(),
    this.bytesToday = const Value.absent(),
    this.bytesDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       provider = Value(provider),
       authKind = Value(authKind),
       email = Value(email);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<int>? provider,
    Expression<int>? authKind,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? imapHost,
    Expression<int>? imapPort,
    Expression<String>? smtpHost,
    Expression<int>? smtpPort,
    Expression<int>? syncState,
    Expression<String>? lastError,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? quotaUsedBytes,
    Expression<int>? quotaTotalBytes,
    Expression<int>? bytesToday,
    Expression<DateTime>? bytesDay,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (authKind != null) 'auth_kind': authKind,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (imapHost != null) 'imap_host': imapHost,
      if (imapPort != null) 'imap_port': imapPort,
      if (smtpHost != null) 'smtp_host': smtpHost,
      if (smtpPort != null) 'smtp_port': smtpPort,
      if (syncState != null) 'sync_state': syncState,
      if (lastError != null) 'last_error': lastError,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (quotaUsedBytes != null) 'quota_used_bytes': quotaUsedBytes,
      if (quotaTotalBytes != null) 'quota_total_bytes': quotaTotalBytes,
      if (bytesToday != null) 'bytes_today': bytesToday,
      if (bytesDay != null) 'bytes_day': bytesDay,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<MailProviderType>? provider,
    Value<AuthKind>? authKind,
    Value<String>? email,
    Value<String>? displayName,
    Value<String>? imapHost,
    Value<int>? imapPort,
    Value<String>? smtpHost,
    Value<int>? smtpPort,
    Value<SyncState>? syncState,
    Value<String?>? lastError,
    Value<DateTime?>? lastSyncAt,
    Value<int?>? quotaUsedBytes,
    Value<int?>? quotaTotalBytes,
    Value<int>? bytesToday,
    Value<DateTime?>? bytesDay,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      authKind: authKind ?? this.authKind,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      imapHost: imapHost ?? this.imapHost,
      imapPort: imapPort ?? this.imapPort,
      smtpHost: smtpHost ?? this.smtpHost,
      smtpPort: smtpPort ?? this.smtpPort,
      syncState: syncState ?? this.syncState,
      lastError: lastError ?? this.lastError,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      quotaUsedBytes: quotaUsedBytes ?? this.quotaUsedBytes,
      quotaTotalBytes: quotaTotalBytes ?? this.quotaTotalBytes,
      bytesToday: bytesToday ?? this.bytesToday,
      bytesDay: bytesDay ?? this.bytesDay,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<int>(
        $AccountsTable.$converterprovider.toSql(provider.value),
      );
    }
    if (authKind.present) {
      map['auth_kind'] = Variable<int>(
        $AccountsTable.$converterauthKind.toSql(authKind.value),
      );
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (imapHost.present) {
      map['imap_host'] = Variable<String>(imapHost.value);
    }
    if (imapPort.present) {
      map['imap_port'] = Variable<int>(imapPort.value);
    }
    if (smtpHost.present) {
      map['smtp_host'] = Variable<String>(smtpHost.value);
    }
    if (smtpPort.present) {
      map['smtp_port'] = Variable<int>(smtpPort.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<int>(
        $AccountsTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (quotaUsedBytes.present) {
      map['quota_used_bytes'] = Variable<int>(quotaUsedBytes.value);
    }
    if (quotaTotalBytes.present) {
      map['quota_total_bytes'] = Variable<int>(quotaTotalBytes.value);
    }
    if (bytesToday.present) {
      map['bytes_today'] = Variable<int>(bytesToday.value);
    }
    if (bytesDay.present) {
      map['bytes_day'] = Variable<DateTime>(bytesDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('authKind: $authKind, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('imapHost: $imapHost, ')
          ..write('imapPort: $imapPort, ')
          ..write('smtpHost: $smtpHost, ')
          ..write('smtpPort: $smtpPort, ')
          ..write('syncState: $syncState, ')
          ..write('lastError: $lastError, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('quotaUsedBytes: $quotaUsedBytes, ')
          ..write('quotaTotalBytes: $quotaTotalBytes, ')
          ..write('bytesToday: $bytesToday, ')
          ..write('bytesDay: $bytesDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, FolderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FolderRole, int> role =
      GeneratedColumn<int>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<FolderRole>($FoldersTable.$converterrole);
  static const VerificationMeta _uidValidityMeta = const VerificationMeta(
    'uidValidity',
  );
  @override
  late final GeneratedColumn<int> uidValidity = GeneratedColumn<int>(
    'uid_validity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uidNextMeta = const VerificationMeta(
    'uidNext',
  );
  @override
  late final GeneratedColumn<int> uidNext = GeneratedColumn<int>(
    'uid_next',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _highestModSeqMeta = const VerificationMeta(
    'highestModSeq',
  );
  @override
  late final GeneratedColumn<int> highestModSeq = GeneratedColumn<int>(
    'highest_mod_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCountMeta = const VerificationMeta(
    'totalCount',
  );
  @override
  late final GeneratedColumn<int> totalCount = GeneratedColumn<int>(
    'total_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _staleMeta = const VerificationMeta('stale');
  @override
  late final GeneratedColumn<bool> stale = GeneratedColumn<bool>(
    'stale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stale" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    path,
    name,
    role,
    uidValidity,
    uidNext,
    highestModSeq,
    totalCount,
    unreadCount,
    stale,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<FolderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('uid_validity')) {
      context.handle(
        _uidValidityMeta,
        uidValidity.isAcceptableOrUnknown(
          data['uid_validity']!,
          _uidValidityMeta,
        ),
      );
    }
    if (data.containsKey('uid_next')) {
      context.handle(
        _uidNextMeta,
        uidNext.isAcceptableOrUnknown(data['uid_next']!, _uidNextMeta),
      );
    }
    if (data.containsKey('highest_mod_seq')) {
      context.handle(
        _highestModSeqMeta,
        highestModSeq.isAcceptableOrUnknown(
          data['highest_mod_seq']!,
          _highestModSeqMeta,
        ),
      );
    }
    if (data.containsKey('total_count')) {
      context.handle(
        _totalCountMeta,
        totalCount.isAcceptableOrUnknown(data['total_count']!, _totalCountMeta),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('stale')) {
      context.handle(
        _staleMeta,
        stale.isAcceptableOrUnknown(data['stale']!, _staleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountId, path},
  ];
  @override
  FolderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: $FoldersTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}role'],
        )!,
      ),
      uidValidity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uid_validity'],
      ),
      uidNext: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uid_next'],
      ),
      highestModSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_mod_seq'],
      ),
      totalCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_count'],
      )!,
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      stale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stale'],
      )!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FolderRole, int, int> $converterrole =
      const EnumIndexConverter<FolderRole>(FolderRole.values);
}

class FolderRow extends DataClass implements Insertable<FolderRow> {
  final int id;
  final String accountId;
  final String path;
  final String name;
  final FolderRole role;
  final int? uidValidity;
  final int? uidNext;
  final int? highestModSeq;
  final int totalCount;
  final int unreadCount;
  final bool stale;
  const FolderRow({
    required this.id,
    required this.accountId,
    required this.path,
    required this.name,
    required this.role,
    this.uidValidity,
    this.uidNext,
    this.highestModSeq,
    required this.totalCount,
    required this.unreadCount,
    required this.stale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<String>(accountId);
    map['path'] = Variable<String>(path);
    map['name'] = Variable<String>(name);
    {
      map['role'] = Variable<int>($FoldersTable.$converterrole.toSql(role));
    }
    if (!nullToAbsent || uidValidity != null) {
      map['uid_validity'] = Variable<int>(uidValidity);
    }
    if (!nullToAbsent || uidNext != null) {
      map['uid_next'] = Variable<int>(uidNext);
    }
    if (!nullToAbsent || highestModSeq != null) {
      map['highest_mod_seq'] = Variable<int>(highestModSeq);
    }
    map['total_count'] = Variable<int>(totalCount);
    map['unread_count'] = Variable<int>(unreadCount);
    map['stale'] = Variable<bool>(stale);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      accountId: Value(accountId),
      path: Value(path),
      name: Value(name),
      role: Value(role),
      uidValidity: uidValidity == null && nullToAbsent
          ? const Value.absent()
          : Value(uidValidity),
      uidNext: uidNext == null && nullToAbsent
          ? const Value.absent()
          : Value(uidNext),
      highestModSeq: highestModSeq == null && nullToAbsent
          ? const Value.absent()
          : Value(highestModSeq),
      totalCount: Value(totalCount),
      unreadCount: Value(unreadCount),
      stale: Value(stale),
    );
  }

  factory FolderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderRow(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      path: serializer.fromJson<String>(json['path']),
      name: serializer.fromJson<String>(json['name']),
      role: $FoldersTable.$converterrole.fromJson(
        serializer.fromJson<int>(json['role']),
      ),
      uidValidity: serializer.fromJson<int?>(json['uidValidity']),
      uidNext: serializer.fromJson<int?>(json['uidNext']),
      highestModSeq: serializer.fromJson<int?>(json['highestModSeq']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      stale: serializer.fromJson<bool>(json['stale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String>(accountId),
      'path': serializer.toJson<String>(path),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<int>($FoldersTable.$converterrole.toJson(role)),
      'uidValidity': serializer.toJson<int?>(uidValidity),
      'uidNext': serializer.toJson<int?>(uidNext),
      'highestModSeq': serializer.toJson<int?>(highestModSeq),
      'totalCount': serializer.toJson<int>(totalCount),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'stale': serializer.toJson<bool>(stale),
    };
  }

  FolderRow copyWith({
    int? id,
    String? accountId,
    String? path,
    String? name,
    FolderRole? role,
    Value<int?> uidValidity = const Value.absent(),
    Value<int?> uidNext = const Value.absent(),
    Value<int?> highestModSeq = const Value.absent(),
    int? totalCount,
    int? unreadCount,
    bool? stale,
  }) => FolderRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    path: path ?? this.path,
    name: name ?? this.name,
    role: role ?? this.role,
    uidValidity: uidValidity.present ? uidValidity.value : this.uidValidity,
    uidNext: uidNext.present ? uidNext.value : this.uidNext,
    highestModSeq: highestModSeq.present
        ? highestModSeq.value
        : this.highestModSeq,
    totalCount: totalCount ?? this.totalCount,
    unreadCount: unreadCount ?? this.unreadCount,
    stale: stale ?? this.stale,
  );
  FolderRow copyWithCompanion(FoldersCompanion data) {
    return FolderRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      path: data.path.present ? data.path.value : this.path,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      uidValidity: data.uidValidity.present
          ? data.uidValidity.value
          : this.uidValidity,
      uidNext: data.uidNext.present ? data.uidNext.value : this.uidNext,
      highestModSeq: data.highestModSeq.present
          ? data.highestModSeq.value
          : this.highestModSeq,
      totalCount: data.totalCount.present
          ? data.totalCount.value
          : this.totalCount,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      stale: data.stale.present ? data.stale.value : this.stale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('uidValidity: $uidValidity, ')
          ..write('uidNext: $uidNext, ')
          ..write('highestModSeq: $highestModSeq, ')
          ..write('totalCount: $totalCount, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('stale: $stale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    path,
    name,
    role,
    uidValidity,
    uidNext,
    highestModSeq,
    totalCount,
    unreadCount,
    stale,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.path == this.path &&
          other.name == this.name &&
          other.role == this.role &&
          other.uidValidity == this.uidValidity &&
          other.uidNext == this.uidNext &&
          other.highestModSeq == this.highestModSeq &&
          other.totalCount == this.totalCount &&
          other.unreadCount == this.unreadCount &&
          other.stale == this.stale);
}

class FoldersCompanion extends UpdateCompanion<FolderRow> {
  final Value<int> id;
  final Value<String> accountId;
  final Value<String> path;
  final Value<String> name;
  final Value<FolderRole> role;
  final Value<int?> uidValidity;
  final Value<int?> uidNext;
  final Value<int?> highestModSeq;
  final Value<int> totalCount;
  final Value<int> unreadCount;
  final Value<bool> stale;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.path = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.uidValidity = const Value.absent(),
    this.uidNext = const Value.absent(),
    this.highestModSeq = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.stale = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    required String path,
    required String name,
    required FolderRole role,
    this.uidValidity = const Value.absent(),
    this.uidNext = const Value.absent(),
    this.highestModSeq = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.stale = const Value.absent(),
  }) : accountId = Value(accountId),
       path = Value(path),
       name = Value(name),
       role = Value(role);
  static Insertable<FolderRow> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<String>? path,
    Expression<String>? name,
    Expression<int>? role,
    Expression<int>? uidValidity,
    Expression<int>? uidNext,
    Expression<int>? highestModSeq,
    Expression<int>? totalCount,
    Expression<int>? unreadCount,
    Expression<bool>? stale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (uidValidity != null) 'uid_validity': uidValidity,
      if (uidNext != null) 'uid_next': uidNext,
      if (highestModSeq != null) 'highest_mod_seq': highestModSeq,
      if (totalCount != null) 'total_count': totalCount,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (stale != null) 'stale': stale,
    });
  }

  FoldersCompanion copyWith({
    Value<int>? id,
    Value<String>? accountId,
    Value<String>? path,
    Value<String>? name,
    Value<FolderRole>? role,
    Value<int?>? uidValidity,
    Value<int?>? uidNext,
    Value<int?>? highestModSeq,
    Value<int>? totalCount,
    Value<int>? unreadCount,
    Value<bool>? stale,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      path: path ?? this.path,
      name: name ?? this.name,
      role: role ?? this.role,
      uidValidity: uidValidity ?? this.uidValidity,
      uidNext: uidNext ?? this.uidNext,
      highestModSeq: highestModSeq ?? this.highestModSeq,
      totalCount: totalCount ?? this.totalCount,
      unreadCount: unreadCount ?? this.unreadCount,
      stale: stale ?? this.stale,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<int>(
        $FoldersTable.$converterrole.toSql(role.value),
      );
    }
    if (uidValidity.present) {
      map['uid_validity'] = Variable<int>(uidValidity.value);
    }
    if (uidNext.present) {
      map['uid_next'] = Variable<int>(uidNext.value);
    }
    if (highestModSeq.present) {
      map['highest_mod_seq'] = Variable<int>(highestModSeq.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (stale.present) {
      map['stale'] = Variable<bool>(stale.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('uidValidity: $uidValidity, ')
          ..write('uidNext: $uidNext, ')
          ..write('highestModSeq: $highestModSeq, ')
          ..write('totalCount: $totalCount, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('stale: $stale')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES folders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<int> uid = GeneratedColumn<int>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdHeaderMeta = const VerificationMeta(
    'messageIdHeader',
  );
  @override
  late final GeneratedColumn<String> messageIdHeader = GeneratedColumn<String>(
    'message_id_header',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gmMsgIdMeta = const VerificationMeta(
    'gmMsgId',
  );
  @override
  late final GeneratedColumn<int> gmMsgId = GeneratedColumn<int>(
    'gm_msg_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromEmailMeta = const VerificationMeta(
    'fromEmail',
  );
  @override
  late final GeneratedColumn<String> fromEmail = GeneratedColumn<String>(
    'from_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromNameMeta = const VerificationMeta(
    'fromName',
  );
  @override
  late final GeneratedColumn<String> fromName = GeneratedColumn<String>(
    'from_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _toLineMeta = const VerificationMeta('toLine');
  @override
  late final GeneratedColumn<String> toLine = GeneratedColumn<String>(
    'to_line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _snippetMeta = const VerificationMeta(
    'snippet',
  );
  @override
  late final GeneratedColumn<String> snippet = GeneratedColumn<String>(
    'snippet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSeenMeta = const VerificationMeta('isSeen');
  @override
  late final GeneratedColumn<bool> isSeen = GeneratedColumn<bool>(
    'is_seen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_seen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFlaggedMeta = const VerificationMeta(
    'isFlagged',
  );
  @override
  late final GeneratedColumn<bool> isFlagged = GeneratedColumn<bool>(
    'is_flagged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_flagged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasAttachmentsMeta = const VerificationMeta(
    'hasAttachments',
  );
  @override
  late final GeneratedColumn<bool> hasAttachments = GeneratedColumn<bool>(
    'has_attachments',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_attachments" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listUnsubscribeMeta = const VerificationMeta(
    'listUnsubscribe',
  );
  @override
  late final GeneratedColumn<String> listUnsubscribe = GeneratedColumn<String>(
    'list_unsubscribe',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listUnsubscribePostMeta =
      const VerificationMeta('listUnsubscribePost');
  @override
  late final GeneratedColumn<bool> listUnsubscribePost = GeneratedColumn<bool>(
    'list_unsubscribe_post',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("list_unsubscribe_post" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _precedenceMeta = const VerificationMeta(
    'precedence',
  );
  @override
  late final GeneratedColumn<String> precedence = GeneratedColumn<String>(
    'precedence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoSubmittedMeta = const VerificationMeta(
    'autoSubmitted',
  );
  @override
  late final GeneratedColumn<String> autoSubmitted = GeneratedColumn<String>(
    'auto_submitted',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dkimPassMeta = const VerificationMeta(
    'dkimPass',
  );
  @override
  late final GeneratedColumn<bool> dkimPass = GeneratedColumn<bool>(
    'dkim_pass',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dkim_pass" IN (0, 1))',
    ),
  );
  static const VerificationMeta _gmLabelsMeta = const VerificationMeta(
    'gmLabels',
  );
  @override
  late final GeneratedColumn<String> gmLabels = GeneratedColumn<String>(
    'gm_labels',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MailCategory?, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<MailCategory?>($MessagesTable.$convertercategoryn);
  static const VerificationMeta _categoryConfidenceMeta =
      const VerificationMeta('categoryConfidence');
  @override
  late final GeneratedColumn<double> categoryConfidence =
      GeneratedColumn<double>(
        'category_confidence',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _categoryReasonMeta = const VerificationMeta(
    'categoryReason',
  );
  @override
  late final GeneratedColumn<String> categoryReason = GeneratedColumn<String>(
    'category_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isProtectedMeta = const VerificationMeta(
    'isProtected',
  );
  @override
  late final GeneratedColumn<bool> isProtected = GeneratedColumn<bool>(
    'is_protected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_protected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyTextMeta = const VerificationMeta(
    'bodyText',
  );
  @override
  late final GeneratedColumn<String> bodyText = GeneratedColumn<String>(
    'body_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    folderId,
    uid,
    messageIdHeader,
    gmMsgId,
    threadId,
    fromEmail,
    fromName,
    toLine,
    subject,
    snippet,
    date,
    size,
    isSeen,
    isFlagged,
    hasAttachments,
    listId,
    listUnsubscribe,
    listUnsubscribePost,
    precedence,
    autoSubmitted,
    dkimPass,
    gmLabels,
    category,
    categoryConfidence,
    categoryReason,
    isProtected,
    expiresAt,
    bodyText,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('message_id_header')) {
      context.handle(
        _messageIdHeaderMeta,
        messageIdHeader.isAcceptableOrUnknown(
          data['message_id_header']!,
          _messageIdHeaderMeta,
        ),
      );
    }
    if (data.containsKey('gm_msg_id')) {
      context.handle(
        _gmMsgIdMeta,
        gmMsgId.isAcceptableOrUnknown(data['gm_msg_id']!, _gmMsgIdMeta),
      );
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    }
    if (data.containsKey('from_email')) {
      context.handle(
        _fromEmailMeta,
        fromEmail.isAcceptableOrUnknown(data['from_email']!, _fromEmailMeta),
      );
    } else if (isInserting) {
      context.missing(_fromEmailMeta);
    }
    if (data.containsKey('from_name')) {
      context.handle(
        _fromNameMeta,
        fromName.isAcceptableOrUnknown(data['from_name']!, _fromNameMeta),
      );
    }
    if (data.containsKey('to_line')) {
      context.handle(
        _toLineMeta,
        toLine.isAcceptableOrUnknown(data['to_line']!, _toLineMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    }
    if (data.containsKey('snippet')) {
      context.handle(
        _snippetMeta,
        snippet.isAcceptableOrUnknown(data['snippet']!, _snippetMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('is_seen')) {
      context.handle(
        _isSeenMeta,
        isSeen.isAcceptableOrUnknown(data['is_seen']!, _isSeenMeta),
      );
    }
    if (data.containsKey('is_flagged')) {
      context.handle(
        _isFlaggedMeta,
        isFlagged.isAcceptableOrUnknown(data['is_flagged']!, _isFlaggedMeta),
      );
    }
    if (data.containsKey('has_attachments')) {
      context.handle(
        _hasAttachmentsMeta,
        hasAttachments.isAcceptableOrUnknown(
          data['has_attachments']!,
          _hasAttachmentsMeta,
        ),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    }
    if (data.containsKey('list_unsubscribe')) {
      context.handle(
        _listUnsubscribeMeta,
        listUnsubscribe.isAcceptableOrUnknown(
          data['list_unsubscribe']!,
          _listUnsubscribeMeta,
        ),
      );
    }
    if (data.containsKey('list_unsubscribe_post')) {
      context.handle(
        _listUnsubscribePostMeta,
        listUnsubscribePost.isAcceptableOrUnknown(
          data['list_unsubscribe_post']!,
          _listUnsubscribePostMeta,
        ),
      );
    }
    if (data.containsKey('precedence')) {
      context.handle(
        _precedenceMeta,
        precedence.isAcceptableOrUnknown(data['precedence']!, _precedenceMeta),
      );
    }
    if (data.containsKey('auto_submitted')) {
      context.handle(
        _autoSubmittedMeta,
        autoSubmitted.isAcceptableOrUnknown(
          data['auto_submitted']!,
          _autoSubmittedMeta,
        ),
      );
    }
    if (data.containsKey('dkim_pass')) {
      context.handle(
        _dkimPassMeta,
        dkimPass.isAcceptableOrUnknown(data['dkim_pass']!, _dkimPassMeta),
      );
    }
    if (data.containsKey('gm_labels')) {
      context.handle(
        _gmLabelsMeta,
        gmLabels.isAcceptableOrUnknown(data['gm_labels']!, _gmLabelsMeta),
      );
    }
    if (data.containsKey('category_confidence')) {
      context.handle(
        _categoryConfidenceMeta,
        categoryConfidence.isAcceptableOrUnknown(
          data['category_confidence']!,
          _categoryConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('category_reason')) {
      context.handle(
        _categoryReasonMeta,
        categoryReason.isAcceptableOrUnknown(
          data['category_reason']!,
          _categoryReasonMeta,
        ),
      );
    }
    if (data.containsKey('is_protected')) {
      context.handle(
        _isProtectedMeta,
        isProtected.isAcceptableOrUnknown(
          data['is_protected']!,
          _isProtectedMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('body_text')) {
      context.handle(
        _bodyTextMeta,
        bodyText.isAcceptableOrUnknown(data['body_text']!, _bodyTextMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {folderId, uid},
  ];
  @override
  MessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uid'],
      )!,
      messageIdHeader: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id_header'],
      ),
      gmMsgId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gm_msg_id'],
      ),
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      ),
      fromEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_email'],
      )!,
      fromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_name'],
      )!,
      toLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_line'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      snippet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      isSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_seen'],
      )!,
      isFlagged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_flagged'],
      )!,
      hasAttachments: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_attachments'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      ),
      listUnsubscribe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_unsubscribe'],
      ),
      listUnsubscribePost: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}list_unsubscribe_post'],
      )!,
      precedence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}precedence'],
      ),
      autoSubmitted: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auto_submitted'],
      ),
      dkimPass: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dkim_pass'],
      ),
      gmLabels: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gm_labels'],
      ),
      category: $MessagesTable.$convertercategoryn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        ),
      ),
      categoryConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}category_confidence'],
      ),
      categoryReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_reason'],
      ),
      isProtected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_protected'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      bodyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_text'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MailCategory, int, int> $convertercategory =
      const EnumIndexConverter<MailCategory>(MailCategory.values);
  static JsonTypeConverter2<MailCategory?, int?, int?> $convertercategoryn =
      JsonTypeConverter2.asNullable($convertercategory);
}

class MessageRow extends DataClass implements Insertable<MessageRow> {
  final int id;
  final String accountId;
  final int folderId;
  final int uid;
  final String? messageIdHeader;
  final int? gmMsgId;
  final String? threadId;
  final String fromEmail;
  final String fromName;
  final String toLine;
  final String subject;
  final String snippet;
  final DateTime date;
  final int size;
  final bool isSeen;
  final bool isFlagged;
  final bool hasAttachments;
  final String? listId;
  final String? listUnsubscribe;
  final bool listUnsubscribePost;
  final String? precedence;
  final String? autoSubmitted;
  final bool? dkimPass;
  final String? gmLabels;
  final MailCategory? category;
  final double? categoryConfidence;
  final String? categoryReason;
  final bool isProtected;
  final DateTime? expiresAt;

  /// Plain-text body, fetched lazily (BODY.PEEK) and cached.
  final String? bodyText;
  final DateTime syncedAt;
  const MessageRow({
    required this.id,
    required this.accountId,
    required this.folderId,
    required this.uid,
    this.messageIdHeader,
    this.gmMsgId,
    this.threadId,
    required this.fromEmail,
    required this.fromName,
    required this.toLine,
    required this.subject,
    required this.snippet,
    required this.date,
    required this.size,
    required this.isSeen,
    required this.isFlagged,
    required this.hasAttachments,
    this.listId,
    this.listUnsubscribe,
    required this.listUnsubscribePost,
    this.precedence,
    this.autoSubmitted,
    this.dkimPass,
    this.gmLabels,
    this.category,
    this.categoryConfidence,
    this.categoryReason,
    required this.isProtected,
    this.expiresAt,
    this.bodyText,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<String>(accountId);
    map['folder_id'] = Variable<int>(folderId);
    map['uid'] = Variable<int>(uid);
    if (!nullToAbsent || messageIdHeader != null) {
      map['message_id_header'] = Variable<String>(messageIdHeader);
    }
    if (!nullToAbsent || gmMsgId != null) {
      map['gm_msg_id'] = Variable<int>(gmMsgId);
    }
    if (!nullToAbsent || threadId != null) {
      map['thread_id'] = Variable<String>(threadId);
    }
    map['from_email'] = Variable<String>(fromEmail);
    map['from_name'] = Variable<String>(fromName);
    map['to_line'] = Variable<String>(toLine);
    map['subject'] = Variable<String>(subject);
    map['snippet'] = Variable<String>(snippet);
    map['date'] = Variable<DateTime>(date);
    map['size'] = Variable<int>(size);
    map['is_seen'] = Variable<bool>(isSeen);
    map['is_flagged'] = Variable<bool>(isFlagged);
    map['has_attachments'] = Variable<bool>(hasAttachments);
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<String>(listId);
    }
    if (!nullToAbsent || listUnsubscribe != null) {
      map['list_unsubscribe'] = Variable<String>(listUnsubscribe);
    }
    map['list_unsubscribe_post'] = Variable<bool>(listUnsubscribePost);
    if (!nullToAbsent || precedence != null) {
      map['precedence'] = Variable<String>(precedence);
    }
    if (!nullToAbsent || autoSubmitted != null) {
      map['auto_submitted'] = Variable<String>(autoSubmitted);
    }
    if (!nullToAbsent || dkimPass != null) {
      map['dkim_pass'] = Variable<bool>(dkimPass);
    }
    if (!nullToAbsent || gmLabels != null) {
      map['gm_labels'] = Variable<String>(gmLabels);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(
        $MessagesTable.$convertercategoryn.toSql(category),
      );
    }
    if (!nullToAbsent || categoryConfidence != null) {
      map['category_confidence'] = Variable<double>(categoryConfidence);
    }
    if (!nullToAbsent || categoryReason != null) {
      map['category_reason'] = Variable<String>(categoryReason);
    }
    map['is_protected'] = Variable<bool>(isProtected);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || bodyText != null) {
      map['body_text'] = Variable<String>(bodyText);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      folderId: Value(folderId),
      uid: Value(uid),
      messageIdHeader: messageIdHeader == null && nullToAbsent
          ? const Value.absent()
          : Value(messageIdHeader),
      gmMsgId: gmMsgId == null && nullToAbsent
          ? const Value.absent()
          : Value(gmMsgId),
      threadId: threadId == null && nullToAbsent
          ? const Value.absent()
          : Value(threadId),
      fromEmail: Value(fromEmail),
      fromName: Value(fromName),
      toLine: Value(toLine),
      subject: Value(subject),
      snippet: Value(snippet),
      date: Value(date),
      size: Value(size),
      isSeen: Value(isSeen),
      isFlagged: Value(isFlagged),
      hasAttachments: Value(hasAttachments),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
      listUnsubscribe: listUnsubscribe == null && nullToAbsent
          ? const Value.absent()
          : Value(listUnsubscribe),
      listUnsubscribePost: Value(listUnsubscribePost),
      precedence: precedence == null && nullToAbsent
          ? const Value.absent()
          : Value(precedence),
      autoSubmitted: autoSubmitted == null && nullToAbsent
          ? const Value.absent()
          : Value(autoSubmitted),
      dkimPass: dkimPass == null && nullToAbsent
          ? const Value.absent()
          : Value(dkimPass),
      gmLabels: gmLabels == null && nullToAbsent
          ? const Value.absent()
          : Value(gmLabels),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      categoryConfidence: categoryConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryConfidence),
      categoryReason: categoryReason == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryReason),
      isProtected: Value(isProtected),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      bodyText: bodyText == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyText),
      syncedAt: Value(syncedAt),
    );
  }

  factory MessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageRow(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      folderId: serializer.fromJson<int>(json['folderId']),
      uid: serializer.fromJson<int>(json['uid']),
      messageIdHeader: serializer.fromJson<String?>(json['messageIdHeader']),
      gmMsgId: serializer.fromJson<int?>(json['gmMsgId']),
      threadId: serializer.fromJson<String?>(json['threadId']),
      fromEmail: serializer.fromJson<String>(json['fromEmail']),
      fromName: serializer.fromJson<String>(json['fromName']),
      toLine: serializer.fromJson<String>(json['toLine']),
      subject: serializer.fromJson<String>(json['subject']),
      snippet: serializer.fromJson<String>(json['snippet']),
      date: serializer.fromJson<DateTime>(json['date']),
      size: serializer.fromJson<int>(json['size']),
      isSeen: serializer.fromJson<bool>(json['isSeen']),
      isFlagged: serializer.fromJson<bool>(json['isFlagged']),
      hasAttachments: serializer.fromJson<bool>(json['hasAttachments']),
      listId: serializer.fromJson<String?>(json['listId']),
      listUnsubscribe: serializer.fromJson<String?>(json['listUnsubscribe']),
      listUnsubscribePost: serializer.fromJson<bool>(
        json['listUnsubscribePost'],
      ),
      precedence: serializer.fromJson<String?>(json['precedence']),
      autoSubmitted: serializer.fromJson<String?>(json['autoSubmitted']),
      dkimPass: serializer.fromJson<bool?>(json['dkimPass']),
      gmLabels: serializer.fromJson<String?>(json['gmLabels']),
      category: $MessagesTable.$convertercategoryn.fromJson(
        serializer.fromJson<int?>(json['category']),
      ),
      categoryConfidence: serializer.fromJson<double?>(
        json['categoryConfidence'],
      ),
      categoryReason: serializer.fromJson<String?>(json['categoryReason']),
      isProtected: serializer.fromJson<bool>(json['isProtected']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      bodyText: serializer.fromJson<String?>(json['bodyText']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String>(accountId),
      'folderId': serializer.toJson<int>(folderId),
      'uid': serializer.toJson<int>(uid),
      'messageIdHeader': serializer.toJson<String?>(messageIdHeader),
      'gmMsgId': serializer.toJson<int?>(gmMsgId),
      'threadId': serializer.toJson<String?>(threadId),
      'fromEmail': serializer.toJson<String>(fromEmail),
      'fromName': serializer.toJson<String>(fromName),
      'toLine': serializer.toJson<String>(toLine),
      'subject': serializer.toJson<String>(subject),
      'snippet': serializer.toJson<String>(snippet),
      'date': serializer.toJson<DateTime>(date),
      'size': serializer.toJson<int>(size),
      'isSeen': serializer.toJson<bool>(isSeen),
      'isFlagged': serializer.toJson<bool>(isFlagged),
      'hasAttachments': serializer.toJson<bool>(hasAttachments),
      'listId': serializer.toJson<String?>(listId),
      'listUnsubscribe': serializer.toJson<String?>(listUnsubscribe),
      'listUnsubscribePost': serializer.toJson<bool>(listUnsubscribePost),
      'precedence': serializer.toJson<String?>(precedence),
      'autoSubmitted': serializer.toJson<String?>(autoSubmitted),
      'dkimPass': serializer.toJson<bool?>(dkimPass),
      'gmLabels': serializer.toJson<String?>(gmLabels),
      'category': serializer.toJson<int?>(
        $MessagesTable.$convertercategoryn.toJson(category),
      ),
      'categoryConfidence': serializer.toJson<double?>(categoryConfidence),
      'categoryReason': serializer.toJson<String?>(categoryReason),
      'isProtected': serializer.toJson<bool>(isProtected),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'bodyText': serializer.toJson<String?>(bodyText),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  MessageRow copyWith({
    int? id,
    String? accountId,
    int? folderId,
    int? uid,
    Value<String?> messageIdHeader = const Value.absent(),
    Value<int?> gmMsgId = const Value.absent(),
    Value<String?> threadId = const Value.absent(),
    String? fromEmail,
    String? fromName,
    String? toLine,
    String? subject,
    String? snippet,
    DateTime? date,
    int? size,
    bool? isSeen,
    bool? isFlagged,
    bool? hasAttachments,
    Value<String?> listId = const Value.absent(),
    Value<String?> listUnsubscribe = const Value.absent(),
    bool? listUnsubscribePost,
    Value<String?> precedence = const Value.absent(),
    Value<String?> autoSubmitted = const Value.absent(),
    Value<bool?> dkimPass = const Value.absent(),
    Value<String?> gmLabels = const Value.absent(),
    Value<MailCategory?> category = const Value.absent(),
    Value<double?> categoryConfidence = const Value.absent(),
    Value<String?> categoryReason = const Value.absent(),
    bool? isProtected,
    Value<DateTime?> expiresAt = const Value.absent(),
    Value<String?> bodyText = const Value.absent(),
    DateTime? syncedAt,
  }) => MessageRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    folderId: folderId ?? this.folderId,
    uid: uid ?? this.uid,
    messageIdHeader: messageIdHeader.present
        ? messageIdHeader.value
        : this.messageIdHeader,
    gmMsgId: gmMsgId.present ? gmMsgId.value : this.gmMsgId,
    threadId: threadId.present ? threadId.value : this.threadId,
    fromEmail: fromEmail ?? this.fromEmail,
    fromName: fromName ?? this.fromName,
    toLine: toLine ?? this.toLine,
    subject: subject ?? this.subject,
    snippet: snippet ?? this.snippet,
    date: date ?? this.date,
    size: size ?? this.size,
    isSeen: isSeen ?? this.isSeen,
    isFlagged: isFlagged ?? this.isFlagged,
    hasAttachments: hasAttachments ?? this.hasAttachments,
    listId: listId.present ? listId.value : this.listId,
    listUnsubscribe: listUnsubscribe.present
        ? listUnsubscribe.value
        : this.listUnsubscribe,
    listUnsubscribePost: listUnsubscribePost ?? this.listUnsubscribePost,
    precedence: precedence.present ? precedence.value : this.precedence,
    autoSubmitted: autoSubmitted.present
        ? autoSubmitted.value
        : this.autoSubmitted,
    dkimPass: dkimPass.present ? dkimPass.value : this.dkimPass,
    gmLabels: gmLabels.present ? gmLabels.value : this.gmLabels,
    category: category.present ? category.value : this.category,
    categoryConfidence: categoryConfidence.present
        ? categoryConfidence.value
        : this.categoryConfidence,
    categoryReason: categoryReason.present
        ? categoryReason.value
        : this.categoryReason,
    isProtected: isProtected ?? this.isProtected,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    bodyText: bodyText.present ? bodyText.value : this.bodyText,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  MessageRow copyWithCompanion(MessagesCompanion data) {
    return MessageRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      uid: data.uid.present ? data.uid.value : this.uid,
      messageIdHeader: data.messageIdHeader.present
          ? data.messageIdHeader.value
          : this.messageIdHeader,
      gmMsgId: data.gmMsgId.present ? data.gmMsgId.value : this.gmMsgId,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      fromEmail: data.fromEmail.present ? data.fromEmail.value : this.fromEmail,
      fromName: data.fromName.present ? data.fromName.value : this.fromName,
      toLine: data.toLine.present ? data.toLine.value : this.toLine,
      subject: data.subject.present ? data.subject.value : this.subject,
      snippet: data.snippet.present ? data.snippet.value : this.snippet,
      date: data.date.present ? data.date.value : this.date,
      size: data.size.present ? data.size.value : this.size,
      isSeen: data.isSeen.present ? data.isSeen.value : this.isSeen,
      isFlagged: data.isFlagged.present ? data.isFlagged.value : this.isFlagged,
      hasAttachments: data.hasAttachments.present
          ? data.hasAttachments.value
          : this.hasAttachments,
      listId: data.listId.present ? data.listId.value : this.listId,
      listUnsubscribe: data.listUnsubscribe.present
          ? data.listUnsubscribe.value
          : this.listUnsubscribe,
      listUnsubscribePost: data.listUnsubscribePost.present
          ? data.listUnsubscribePost.value
          : this.listUnsubscribePost,
      precedence: data.precedence.present
          ? data.precedence.value
          : this.precedence,
      autoSubmitted: data.autoSubmitted.present
          ? data.autoSubmitted.value
          : this.autoSubmitted,
      dkimPass: data.dkimPass.present ? data.dkimPass.value : this.dkimPass,
      gmLabels: data.gmLabels.present ? data.gmLabels.value : this.gmLabels,
      category: data.category.present ? data.category.value : this.category,
      categoryConfidence: data.categoryConfidence.present
          ? data.categoryConfidence.value
          : this.categoryConfidence,
      categoryReason: data.categoryReason.present
          ? data.categoryReason.value
          : this.categoryReason,
      isProtected: data.isProtected.present
          ? data.isProtected.value
          : this.isProtected,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      bodyText: data.bodyText.present ? data.bodyText.value : this.bodyText,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('folderId: $folderId, ')
          ..write('uid: $uid, ')
          ..write('messageIdHeader: $messageIdHeader, ')
          ..write('gmMsgId: $gmMsgId, ')
          ..write('threadId: $threadId, ')
          ..write('fromEmail: $fromEmail, ')
          ..write('fromName: $fromName, ')
          ..write('toLine: $toLine, ')
          ..write('subject: $subject, ')
          ..write('snippet: $snippet, ')
          ..write('date: $date, ')
          ..write('size: $size, ')
          ..write('isSeen: $isSeen, ')
          ..write('isFlagged: $isFlagged, ')
          ..write('hasAttachments: $hasAttachments, ')
          ..write('listId: $listId, ')
          ..write('listUnsubscribe: $listUnsubscribe, ')
          ..write('listUnsubscribePost: $listUnsubscribePost, ')
          ..write('precedence: $precedence, ')
          ..write('autoSubmitted: $autoSubmitted, ')
          ..write('dkimPass: $dkimPass, ')
          ..write('gmLabels: $gmLabels, ')
          ..write('category: $category, ')
          ..write('categoryConfidence: $categoryConfidence, ')
          ..write('categoryReason: $categoryReason, ')
          ..write('isProtected: $isProtected, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('bodyText: $bodyText, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    accountId,
    folderId,
    uid,
    messageIdHeader,
    gmMsgId,
    threadId,
    fromEmail,
    fromName,
    toLine,
    subject,
    snippet,
    date,
    size,
    isSeen,
    isFlagged,
    hasAttachments,
    listId,
    listUnsubscribe,
    listUnsubscribePost,
    precedence,
    autoSubmitted,
    dkimPass,
    gmLabels,
    category,
    categoryConfidence,
    categoryReason,
    isProtected,
    expiresAt,
    bodyText,
    syncedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.folderId == this.folderId &&
          other.uid == this.uid &&
          other.messageIdHeader == this.messageIdHeader &&
          other.gmMsgId == this.gmMsgId &&
          other.threadId == this.threadId &&
          other.fromEmail == this.fromEmail &&
          other.fromName == this.fromName &&
          other.toLine == this.toLine &&
          other.subject == this.subject &&
          other.snippet == this.snippet &&
          other.date == this.date &&
          other.size == this.size &&
          other.isSeen == this.isSeen &&
          other.isFlagged == this.isFlagged &&
          other.hasAttachments == this.hasAttachments &&
          other.listId == this.listId &&
          other.listUnsubscribe == this.listUnsubscribe &&
          other.listUnsubscribePost == this.listUnsubscribePost &&
          other.precedence == this.precedence &&
          other.autoSubmitted == this.autoSubmitted &&
          other.dkimPass == this.dkimPass &&
          other.gmLabels == this.gmLabels &&
          other.category == this.category &&
          other.categoryConfidence == this.categoryConfidence &&
          other.categoryReason == this.categoryReason &&
          other.isProtected == this.isProtected &&
          other.expiresAt == this.expiresAt &&
          other.bodyText == this.bodyText &&
          other.syncedAt == this.syncedAt);
}

class MessagesCompanion extends UpdateCompanion<MessageRow> {
  final Value<int> id;
  final Value<String> accountId;
  final Value<int> folderId;
  final Value<int> uid;
  final Value<String?> messageIdHeader;
  final Value<int?> gmMsgId;
  final Value<String?> threadId;
  final Value<String> fromEmail;
  final Value<String> fromName;
  final Value<String> toLine;
  final Value<String> subject;
  final Value<String> snippet;
  final Value<DateTime> date;
  final Value<int> size;
  final Value<bool> isSeen;
  final Value<bool> isFlagged;
  final Value<bool> hasAttachments;
  final Value<String?> listId;
  final Value<String?> listUnsubscribe;
  final Value<bool> listUnsubscribePost;
  final Value<String?> precedence;
  final Value<String?> autoSubmitted;
  final Value<bool?> dkimPass;
  final Value<String?> gmLabels;
  final Value<MailCategory?> category;
  final Value<double?> categoryConfidence;
  final Value<String?> categoryReason;
  final Value<bool> isProtected;
  final Value<DateTime?> expiresAt;
  final Value<String?> bodyText;
  final Value<DateTime> syncedAt;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.folderId = const Value.absent(),
    this.uid = const Value.absent(),
    this.messageIdHeader = const Value.absent(),
    this.gmMsgId = const Value.absent(),
    this.threadId = const Value.absent(),
    this.fromEmail = const Value.absent(),
    this.fromName = const Value.absent(),
    this.toLine = const Value.absent(),
    this.subject = const Value.absent(),
    this.snippet = const Value.absent(),
    this.date = const Value.absent(),
    this.size = const Value.absent(),
    this.isSeen = const Value.absent(),
    this.isFlagged = const Value.absent(),
    this.hasAttachments = const Value.absent(),
    this.listId = const Value.absent(),
    this.listUnsubscribe = const Value.absent(),
    this.listUnsubscribePost = const Value.absent(),
    this.precedence = const Value.absent(),
    this.autoSubmitted = const Value.absent(),
    this.dkimPass = const Value.absent(),
    this.gmLabels = const Value.absent(),
    this.category = const Value.absent(),
    this.categoryConfidence = const Value.absent(),
    this.categoryReason = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    required int folderId,
    required int uid,
    this.messageIdHeader = const Value.absent(),
    this.gmMsgId = const Value.absent(),
    this.threadId = const Value.absent(),
    required String fromEmail,
    this.fromName = const Value.absent(),
    this.toLine = const Value.absent(),
    this.subject = const Value.absent(),
    this.snippet = const Value.absent(),
    required DateTime date,
    this.size = const Value.absent(),
    this.isSeen = const Value.absent(),
    this.isFlagged = const Value.absent(),
    this.hasAttachments = const Value.absent(),
    this.listId = const Value.absent(),
    this.listUnsubscribe = const Value.absent(),
    this.listUnsubscribePost = const Value.absent(),
    this.precedence = const Value.absent(),
    this.autoSubmitted = const Value.absent(),
    this.dkimPass = const Value.absent(),
    this.gmLabels = const Value.absent(),
    this.category = const Value.absent(),
    this.categoryConfidence = const Value.absent(),
    this.categoryReason = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       folderId = Value(folderId),
       uid = Value(uid),
       fromEmail = Value(fromEmail),
       date = Value(date);
  static Insertable<MessageRow> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<int>? folderId,
    Expression<int>? uid,
    Expression<String>? messageIdHeader,
    Expression<int>? gmMsgId,
    Expression<String>? threadId,
    Expression<String>? fromEmail,
    Expression<String>? fromName,
    Expression<String>? toLine,
    Expression<String>? subject,
    Expression<String>? snippet,
    Expression<DateTime>? date,
    Expression<int>? size,
    Expression<bool>? isSeen,
    Expression<bool>? isFlagged,
    Expression<bool>? hasAttachments,
    Expression<String>? listId,
    Expression<String>? listUnsubscribe,
    Expression<bool>? listUnsubscribePost,
    Expression<String>? precedence,
    Expression<String>? autoSubmitted,
    Expression<bool>? dkimPass,
    Expression<String>? gmLabels,
    Expression<int>? category,
    Expression<double>? categoryConfidence,
    Expression<String>? categoryReason,
    Expression<bool>? isProtected,
    Expression<DateTime>? expiresAt,
    Expression<String>? bodyText,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (folderId != null) 'folder_id': folderId,
      if (uid != null) 'uid': uid,
      if (messageIdHeader != null) 'message_id_header': messageIdHeader,
      if (gmMsgId != null) 'gm_msg_id': gmMsgId,
      if (threadId != null) 'thread_id': threadId,
      if (fromEmail != null) 'from_email': fromEmail,
      if (fromName != null) 'from_name': fromName,
      if (toLine != null) 'to_line': toLine,
      if (subject != null) 'subject': subject,
      if (snippet != null) 'snippet': snippet,
      if (date != null) 'date': date,
      if (size != null) 'size': size,
      if (isSeen != null) 'is_seen': isSeen,
      if (isFlagged != null) 'is_flagged': isFlagged,
      if (hasAttachments != null) 'has_attachments': hasAttachments,
      if (listId != null) 'list_id': listId,
      if (listUnsubscribe != null) 'list_unsubscribe': listUnsubscribe,
      if (listUnsubscribePost != null)
        'list_unsubscribe_post': listUnsubscribePost,
      if (precedence != null) 'precedence': precedence,
      if (autoSubmitted != null) 'auto_submitted': autoSubmitted,
      if (dkimPass != null) 'dkim_pass': dkimPass,
      if (gmLabels != null) 'gm_labels': gmLabels,
      if (category != null) 'category': category,
      if (categoryConfidence != null) 'category_confidence': categoryConfidence,
      if (categoryReason != null) 'category_reason': categoryReason,
      if (isProtected != null) 'is_protected': isProtected,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (bodyText != null) 'body_text': bodyText,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  MessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? accountId,
    Value<int>? folderId,
    Value<int>? uid,
    Value<String?>? messageIdHeader,
    Value<int?>? gmMsgId,
    Value<String?>? threadId,
    Value<String>? fromEmail,
    Value<String>? fromName,
    Value<String>? toLine,
    Value<String>? subject,
    Value<String>? snippet,
    Value<DateTime>? date,
    Value<int>? size,
    Value<bool>? isSeen,
    Value<bool>? isFlagged,
    Value<bool>? hasAttachments,
    Value<String?>? listId,
    Value<String?>? listUnsubscribe,
    Value<bool>? listUnsubscribePost,
    Value<String?>? precedence,
    Value<String?>? autoSubmitted,
    Value<bool?>? dkimPass,
    Value<String?>? gmLabels,
    Value<MailCategory?>? category,
    Value<double?>? categoryConfidence,
    Value<String?>? categoryReason,
    Value<bool>? isProtected,
    Value<DateTime?>? expiresAt,
    Value<String?>? bodyText,
    Value<DateTime>? syncedAt,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      folderId: folderId ?? this.folderId,
      uid: uid ?? this.uid,
      messageIdHeader: messageIdHeader ?? this.messageIdHeader,
      gmMsgId: gmMsgId ?? this.gmMsgId,
      threadId: threadId ?? this.threadId,
      fromEmail: fromEmail ?? this.fromEmail,
      fromName: fromName ?? this.fromName,
      toLine: toLine ?? this.toLine,
      subject: subject ?? this.subject,
      snippet: snippet ?? this.snippet,
      date: date ?? this.date,
      size: size ?? this.size,
      isSeen: isSeen ?? this.isSeen,
      isFlagged: isFlagged ?? this.isFlagged,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      listId: listId ?? this.listId,
      listUnsubscribe: listUnsubscribe ?? this.listUnsubscribe,
      listUnsubscribePost: listUnsubscribePost ?? this.listUnsubscribePost,
      precedence: precedence ?? this.precedence,
      autoSubmitted: autoSubmitted ?? this.autoSubmitted,
      dkimPass: dkimPass ?? this.dkimPass,
      gmLabels: gmLabels ?? this.gmLabels,
      category: category ?? this.category,
      categoryConfidence: categoryConfidence ?? this.categoryConfidence,
      categoryReason: categoryReason ?? this.categoryReason,
      isProtected: isProtected ?? this.isProtected,
      expiresAt: expiresAt ?? this.expiresAt,
      bodyText: bodyText ?? this.bodyText,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (uid.present) {
      map['uid'] = Variable<int>(uid.value);
    }
    if (messageIdHeader.present) {
      map['message_id_header'] = Variable<String>(messageIdHeader.value);
    }
    if (gmMsgId.present) {
      map['gm_msg_id'] = Variable<int>(gmMsgId.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (fromEmail.present) {
      map['from_email'] = Variable<String>(fromEmail.value);
    }
    if (fromName.present) {
      map['from_name'] = Variable<String>(fromName.value);
    }
    if (toLine.present) {
      map['to_line'] = Variable<String>(toLine.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (snippet.present) {
      map['snippet'] = Variable<String>(snippet.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (isSeen.present) {
      map['is_seen'] = Variable<bool>(isSeen.value);
    }
    if (isFlagged.present) {
      map['is_flagged'] = Variable<bool>(isFlagged.value);
    }
    if (hasAttachments.present) {
      map['has_attachments'] = Variable<bool>(hasAttachments.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (listUnsubscribe.present) {
      map['list_unsubscribe'] = Variable<String>(listUnsubscribe.value);
    }
    if (listUnsubscribePost.present) {
      map['list_unsubscribe_post'] = Variable<bool>(listUnsubscribePost.value);
    }
    if (precedence.present) {
      map['precedence'] = Variable<String>(precedence.value);
    }
    if (autoSubmitted.present) {
      map['auto_submitted'] = Variable<String>(autoSubmitted.value);
    }
    if (dkimPass.present) {
      map['dkim_pass'] = Variable<bool>(dkimPass.value);
    }
    if (gmLabels.present) {
      map['gm_labels'] = Variable<String>(gmLabels.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $MessagesTable.$convertercategoryn.toSql(category.value),
      );
    }
    if (categoryConfidence.present) {
      map['category_confidence'] = Variable<double>(categoryConfidence.value);
    }
    if (categoryReason.present) {
      map['category_reason'] = Variable<String>(categoryReason.value);
    }
    if (isProtected.present) {
      map['is_protected'] = Variable<bool>(isProtected.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (bodyText.present) {
      map['body_text'] = Variable<String>(bodyText.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('folderId: $folderId, ')
          ..write('uid: $uid, ')
          ..write('messageIdHeader: $messageIdHeader, ')
          ..write('gmMsgId: $gmMsgId, ')
          ..write('threadId: $threadId, ')
          ..write('fromEmail: $fromEmail, ')
          ..write('fromName: $fromName, ')
          ..write('toLine: $toLine, ')
          ..write('subject: $subject, ')
          ..write('snippet: $snippet, ')
          ..write('date: $date, ')
          ..write('size: $size, ')
          ..write('isSeen: $isSeen, ')
          ..write('isFlagged: $isFlagged, ')
          ..write('hasAttachments: $hasAttachments, ')
          ..write('listId: $listId, ')
          ..write('listUnsubscribe: $listUnsubscribe, ')
          ..write('listUnsubscribePost: $listUnsubscribePost, ')
          ..write('precedence: $precedence, ')
          ..write('autoSubmitted: $autoSubmitted, ')
          ..write('dkimPass: $dkimPass, ')
          ..write('gmLabels: $gmLabels, ')
          ..write('category: $category, ')
          ..write('categoryConfidence: $categoryConfidence, ')
          ..write('categoryReason: $categoryReason, ')
          ..write('isProtected: $isProtected, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('bodyText: $bodyText, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $SendersTable extends Senders with TableInfo<$SendersTable, SenderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SendersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SenderDecision, int> decision =
      GeneratedColumn<int>(
        'decision',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<SenderDecision>($SendersTable.$converterdecision);
  static const VerificationMeta _decidedAtMeta = const VerificationMeta(
    'decidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> decidedAt = GeneratedColumn<DateTime>(
    'decided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    email,
    name,
    domain,
    decision,
    decidedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'senders';
  @override
  VerificationContext validateIntegrity(
    Insertable<SenderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    } else if (isInserting) {
      context.missing(_domainMeta);
    }
    if (data.containsKey('decided_at')) {
      context.handle(
        _decidedAtMeta,
        decidedAt.isAcceptableOrUnknown(data['decided_at']!, _decidedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {email};
  @override
  SenderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SenderRow(
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      domain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}domain'],
      )!,
      decision: $SendersTable.$converterdecision.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}decision'],
        )!,
      ),
      decidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}decided_at'],
      ),
    );
  }

  @override
  $SendersTable createAlias(String alias) {
    return $SendersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SenderDecision, int, int> $converterdecision =
      const EnumIndexConverter<SenderDecision>(SenderDecision.values);
}

class SenderRow extends DataClass implements Insertable<SenderRow> {
  final String email;
  final String name;
  final String domain;
  final SenderDecision decision;
  final DateTime? decidedAt;
  const SenderRow({
    required this.email,
    required this.name,
    required this.domain,
    required this.decision,
    this.decidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['email'] = Variable<String>(email);
    map['name'] = Variable<String>(name);
    map['domain'] = Variable<String>(domain);
    {
      map['decision'] = Variable<int>(
        $SendersTable.$converterdecision.toSql(decision),
      );
    }
    if (!nullToAbsent || decidedAt != null) {
      map['decided_at'] = Variable<DateTime>(decidedAt);
    }
    return map;
  }

  SendersCompanion toCompanion(bool nullToAbsent) {
    return SendersCompanion(
      email: Value(email),
      name: Value(name),
      domain: Value(domain),
      decision: Value(decision),
      decidedAt: decidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(decidedAt),
    );
  }

  factory SenderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SenderRow(
      email: serializer.fromJson<String>(json['email']),
      name: serializer.fromJson<String>(json['name']),
      domain: serializer.fromJson<String>(json['domain']),
      decision: $SendersTable.$converterdecision.fromJson(
        serializer.fromJson<int>(json['decision']),
      ),
      decidedAt: serializer.fromJson<DateTime?>(json['decidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'email': serializer.toJson<String>(email),
      'name': serializer.toJson<String>(name),
      'domain': serializer.toJson<String>(domain),
      'decision': serializer.toJson<int>(
        $SendersTable.$converterdecision.toJson(decision),
      ),
      'decidedAt': serializer.toJson<DateTime?>(decidedAt),
    };
  }

  SenderRow copyWith({
    String? email,
    String? name,
    String? domain,
    SenderDecision? decision,
    Value<DateTime?> decidedAt = const Value.absent(),
  }) => SenderRow(
    email: email ?? this.email,
    name: name ?? this.name,
    domain: domain ?? this.domain,
    decision: decision ?? this.decision,
    decidedAt: decidedAt.present ? decidedAt.value : this.decidedAt,
  );
  SenderRow copyWithCompanion(SendersCompanion data) {
    return SenderRow(
      email: data.email.present ? data.email.value : this.email,
      name: data.name.present ? data.name.value : this.name,
      domain: data.domain.present ? data.domain.value : this.domain,
      decision: data.decision.present ? data.decision.value : this.decision,
      decidedAt: data.decidedAt.present ? data.decidedAt.value : this.decidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SenderRow(')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('domain: $domain, ')
          ..write('decision: $decision, ')
          ..write('decidedAt: $decidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(email, name, domain, decision, decidedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SenderRow &&
          other.email == this.email &&
          other.name == this.name &&
          other.domain == this.domain &&
          other.decision == this.decision &&
          other.decidedAt == this.decidedAt);
}

class SendersCompanion extends UpdateCompanion<SenderRow> {
  final Value<String> email;
  final Value<String> name;
  final Value<String> domain;
  final Value<SenderDecision> decision;
  final Value<DateTime?> decidedAt;
  final Value<int> rowid;
  const SendersCompanion({
    this.email = const Value.absent(),
    this.name = const Value.absent(),
    this.domain = const Value.absent(),
    this.decision = const Value.absent(),
    this.decidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SendersCompanion.insert({
    required String email,
    this.name = const Value.absent(),
    required String domain,
    this.decision = const Value.absent(),
    this.decidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : email = Value(email),
       domain = Value(domain);
  static Insertable<SenderRow> custom({
    Expression<String>? email,
    Expression<String>? name,
    Expression<String>? domain,
    Expression<int>? decision,
    Expression<DateTime>? decidedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (domain != null) 'domain': domain,
      if (decision != null) 'decision': decision,
      if (decidedAt != null) 'decided_at': decidedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SendersCompanion copyWith({
    Value<String>? email,
    Value<String>? name,
    Value<String>? domain,
    Value<SenderDecision>? decision,
    Value<DateTime?>? decidedAt,
    Value<int>? rowid,
  }) {
    return SendersCompanion(
      email: email ?? this.email,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      decision: decision ?? this.decision,
      decidedAt: decidedAt ?? this.decidedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (decision.present) {
      map['decision'] = Variable<int>(
        $SendersTable.$converterdecision.toSql(decision.value),
      );
    }
    if (decidedAt.present) {
      map['decided_at'] = Variable<DateTime>(decidedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SendersCompanion(')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('domain: $domain, ')
          ..write('decision: $decision, ')
          ..write('decidedAt: $decidedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorKeyMeta = const VerificationMeta(
    'colorKey',
  );
  @override
  late final GeneratedColumn<String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('gray'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TagKind>($TagsTable.$converterkind);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isProtectedMeta = const VerificationMeta(
    'isProtected',
  );
  @override
  late final GeneratedColumn<bool> isProtected = GeneratedColumn<bool>(
    'is_protected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_protected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    name,
    colorKey,
    kind,
    description,
    isProtected,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_key')) {
      context.handle(
        _colorKeyMeta,
        colorKey.isAcceptableOrUnknown(data['color_key']!, _colorKeyMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_protected')) {
      context.handle(
        _isProtectedMeta,
        isProtected.isAcceptableOrUnknown(
          data['is_protected']!,
          _isProtectedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_key'],
      )!,
      kind: $TagsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isProtected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_protected'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TagKind, int, int> $converterkind =
      const EnumIndexConverter<TagKind>(TagKind.values);
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final int id;

  /// Stable key for system tags ('finance', 'hr', 'news', 'promotion', 'travel').
  final String key;
  final String name;
  final String colorKey;
  final TagKind kind;

  /// Natural-language description for custom tags ("hoá đơn điện, nước…").
  final String? description;
  final bool isProtected;
  final DateTime createdAt;
  const TagRow({
    required this.id,
    required this.key,
    required this.name,
    required this.colorKey,
    required this.kind,
    this.description,
    required this.isProtected,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    map['color_key'] = Variable<String>(colorKey);
    {
      map['kind'] = Variable<int>($TagsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_protected'] = Variable<bool>(isProtected);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      key: Value(key),
      name: Value(name),
      colorKey: Value(colorKey),
      kind: Value(kind),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isProtected: Value(isProtected),
      createdAt: Value(createdAt),
    );
  }

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      colorKey: serializer.fromJson<String>(json['colorKey']),
      kind: $TagsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      description: serializer.fromJson<String?>(json['description']),
      isProtected: serializer.fromJson<bool>(json['isProtected']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'colorKey': serializer.toJson<String>(colorKey),
      'kind': serializer.toJson<int>($TagsTable.$converterkind.toJson(kind)),
      'description': serializer.toJson<String?>(description),
      'isProtected': serializer.toJson<bool>(isProtected),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TagRow copyWith({
    int? id,
    String? key,
    String? name,
    String? colorKey,
    TagKind? kind,
    Value<String?> description = const Value.absent(),
    bool? isProtected,
    DateTime? createdAt,
  }) => TagRow(
    id: id ?? this.id,
    key: key ?? this.key,
    name: name ?? this.name,
    colorKey: colorKey ?? this.colorKey,
    kind: kind ?? this.kind,
    description: description.present ? description.value : this.description,
    isProtected: isProtected ?? this.isProtected,
    createdAt: createdAt ?? this.createdAt,
  );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      isProtected: data.isProtected.present
          ? data.isProtected.value
          : this.isProtected,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('colorKey: $colorKey, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('isProtected: $isProtected, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    key,
    name,
    colorKey,
    kind,
    description,
    isProtected,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.key == this.key &&
          other.name == this.name &&
          other.colorKey == this.colorKey &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.isProtected == this.isProtected &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> name;
  final Value<String> colorKey;
  final Value<TagKind> kind;
  final Value<String?> description;
  final Value<bool> isProtected;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String name,
    this.colorKey = const Value.absent(),
    required TagKind kind,
    this.description = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : key = Value(key),
       name = Value(name),
       kind = Value(kind);
  static Insertable<TagRow> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? colorKey,
    Expression<int>? kind,
    Expression<String>? description,
    Expression<bool>? isProtected,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (colorKey != null) 'color_key': colorKey,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (isProtected != null) 'is_protected': isProtected,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? name,
    Value<String>? colorKey,
    Value<TagKind>? kind,
    Value<String?>? description,
    Value<bool>? isProtected,
    Value<DateTime>? createdAt,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      colorKey: colorKey ?? this.colorKey,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      isProtected: isProtected ?? this.isProtected,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>(colorKey.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>($TagsTable.$converterkind.toSql(kind.value));
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isProtected.present) {
      map['is_protected'] = Variable<bool>(isProtected.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('colorKey: $colorKey, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('isProtected: $isProtected, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MessageTagsTable extends MessageTags
    with TableInfo<$MessageTagsTable, MessageTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TagSource>($MessageTagsTable.$convertersource);
  @override
  List<GeneratedColumn> get $columns => [messageId, tagId, confidence, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, tagId};
  @override
  MessageTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTagRow(
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      source: $MessageTagsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
    );
  }

  @override
  $MessageTagsTable createAlias(String alias) {
    return $MessageTagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TagSource, int, int> $convertersource =
      const EnumIndexConverter<TagSource>(TagSource.values);
}

class MessageTagRow extends DataClass implements Insertable<MessageTagRow> {
  final int messageId;
  final int tagId;
  final double confidence;
  final TagSource source;
  const MessageTagRow({
    required this.messageId,
    required this.tagId,
    required this.confidence,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<int>(messageId);
    map['tag_id'] = Variable<int>(tagId);
    map['confidence'] = Variable<double>(confidence);
    {
      map['source'] = Variable<int>(
        $MessageTagsTable.$convertersource.toSql(source),
      );
    }
    return map;
  }

  MessageTagsCompanion toCompanion(bool nullToAbsent) {
    return MessageTagsCompanion(
      messageId: Value(messageId),
      tagId: Value(tagId),
      confidence: Value(confidence),
      source: Value(source),
    );
  }

  factory MessageTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTagRow(
      messageId: serializer.fromJson<int>(json['messageId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      confidence: serializer.fromJson<double>(json['confidence']),
      source: $MessageTagsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<int>(messageId),
      'tagId': serializer.toJson<int>(tagId),
      'confidence': serializer.toJson<double>(confidence),
      'source': serializer.toJson<int>(
        $MessageTagsTable.$convertersource.toJson(source),
      ),
    };
  }

  MessageTagRow copyWith({
    int? messageId,
    int? tagId,
    double? confidence,
    TagSource? source,
  }) => MessageTagRow(
    messageId: messageId ?? this.messageId,
    tagId: tagId ?? this.tagId,
    confidence: confidence ?? this.confidence,
    source: source ?? this.source,
  );
  MessageTagRow copyWithCompanion(MessageTagsCompanion data) {
    return MessageTagRow(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTagRow(')
          ..write('messageId: $messageId, ')
          ..write('tagId: $tagId, ')
          ..write('confidence: $confidence, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, tagId, confidence, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTagRow &&
          other.messageId == this.messageId &&
          other.tagId == this.tagId &&
          other.confidence == this.confidence &&
          other.source == this.source);
}

class MessageTagsCompanion extends UpdateCompanion<MessageTagRow> {
  final Value<int> messageId;
  final Value<int> tagId;
  final Value<double> confidence;
  final Value<TagSource> source;
  final Value<int> rowid;
  const MessageTagsCompanion({
    this.messageId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.confidence = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageTagsCompanion.insert({
    required int messageId,
    required int tagId,
    this.confidence = const Value.absent(),
    required TagSource source,
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId),
       tagId = Value(tagId),
       source = Value(source);
  static Insertable<MessageTagRow> custom({
    Expression<int>? messageId,
    Expression<int>? tagId,
    Expression<double>? confidence,
    Expression<int>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (tagId != null) 'tag_id': tagId,
      if (confidence != null) 'confidence': confidence,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageTagsCompanion copyWith({
    Value<int>? messageId,
    Value<int>? tagId,
    Value<double>? confidence,
    Value<TagSource>? source,
    Value<int>? rowid,
  }) {
    return MessageTagsCompanion(
      messageId: messageId ?? this.messageId,
      tagId: tagId ?? this.tagId,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $MessageTagsTable.$convertersource.toSql(source.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTagsCompanion(')
          ..write('messageId: $messageId, ')
          ..write('tagId: $tagId, ')
          ..write('confidence: $confidence, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActionsLogTable extends ActionsLog
    with TableInfo<$ActionsLogTable, ActionLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionsLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MailActionType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MailActionType>($ActionsLogTable.$convertertype);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageIdHeaderMeta = const VerificationMeta(
    'messageIdHeader',
  );
  @override
  late final GeneratedColumn<String> messageIdHeader = GeneratedColumn<String>(
    'message_id_header',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromFolderPathMeta = const VerificationMeta(
    'fromFolderPath',
  );
  @override
  late final GeneratedColumn<String> fromFolderPath = GeneratedColumn<String>(
    'from_folder_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toFolderPathMeta = const VerificationMeta(
    'toFolderPath',
  );
  @override
  late final GeneratedColumn<String> toFolderPath = GeneratedColumn<String>(
    'to_folder_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalUidMeta = const VerificationMeta(
    'originalUid',
  );
  @override
  late final GeneratedColumn<int> originalUid = GeneratedColumn<int>(
    'original_uid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newUidMeta = const VerificationMeta('newUid');
  @override
  late final GeneratedColumn<int> newUid = GeneratedColumn<int>(
    'new_uid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActionStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ActionStatus>($ActionsLogTable.$converterstatus);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _undoneAtMeta = const VerificationMeta(
    'undoneAt',
  );
  @override
  late final GeneratedColumn<DateTime> undoneAt = GeneratedColumn<DateTime>(
    'undone_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    batchId,
    type,
    accountId,
    messageId,
    messageIdHeader,
    fromFolderPath,
    toFolderPath,
    originalUid,
    newUid,
    status,
    label,
    error,
    createdAt,
    undoneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'actions_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActionLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    }
    if (data.containsKey('message_id_header')) {
      context.handle(
        _messageIdHeaderMeta,
        messageIdHeader.isAcceptableOrUnknown(
          data['message_id_header']!,
          _messageIdHeaderMeta,
        ),
      );
    }
    if (data.containsKey('from_folder_path')) {
      context.handle(
        _fromFolderPathMeta,
        fromFolderPath.isAcceptableOrUnknown(
          data['from_folder_path']!,
          _fromFolderPathMeta,
        ),
      );
    }
    if (data.containsKey('to_folder_path')) {
      context.handle(
        _toFolderPathMeta,
        toFolderPath.isAcceptableOrUnknown(
          data['to_folder_path']!,
          _toFolderPathMeta,
        ),
      );
    }
    if (data.containsKey('original_uid')) {
      context.handle(
        _originalUidMeta,
        originalUid.isAcceptableOrUnknown(
          data['original_uid']!,
          _originalUidMeta,
        ),
      );
    }
    if (data.containsKey('new_uid')) {
      context.handle(
        _newUidMeta,
        newUid.isAcceptableOrUnknown(data['new_uid']!, _newUidMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('undone_at')) {
      context.handle(
        _undoneAtMeta,
        undoneAt.isAcceptableOrUnknown(data['undone_at']!, _undoneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActionLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      )!,
      type: $ActionsLogTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      ),
      messageIdHeader: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id_header'],
      ),
      fromFolderPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_folder_path'],
      ),
      toFolderPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_folder_path'],
      ),
      originalUid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_uid'],
      ),
      newUid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_uid'],
      ),
      status: $ActionsLogTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      undoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}undone_at'],
      ),
    );
  }

  @override
  $ActionsLogTable createAlias(String alias) {
    return $ActionsLogTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MailActionType, int, int> $convertertype =
      const EnumIndexConverter<MailActionType>(MailActionType.values);
  static JsonTypeConverter2<ActionStatus, int, int> $converterstatus =
      const EnumIndexConverter<ActionStatus>(ActionStatus.values);
}

class ActionLogRow extends DataClass implements Insertable<ActionLogRow> {
  final int id;
  final String batchId;
  final MailActionType type;
  final String accountId;
  final int? messageId;
  final String? messageIdHeader;
  final String? fromFolderPath;
  final String? toFolderPath;
  final int? originalUid;
  final int? newUid;
  final ActionStatus status;
  final String label;
  final String? error;
  final DateTime createdAt;
  final DateTime? undoneAt;
  const ActionLogRow({
    required this.id,
    required this.batchId,
    required this.type,
    required this.accountId,
    this.messageId,
    this.messageIdHeader,
    this.fromFolderPath,
    this.toFolderPath,
    this.originalUid,
    this.newUid,
    required this.status,
    required this.label,
    this.error,
    required this.createdAt,
    this.undoneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<String>(batchId);
    {
      map['type'] = Variable<int>($ActionsLogTable.$convertertype.toSql(type));
    }
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<int>(messageId);
    }
    if (!nullToAbsent || messageIdHeader != null) {
      map['message_id_header'] = Variable<String>(messageIdHeader);
    }
    if (!nullToAbsent || fromFolderPath != null) {
      map['from_folder_path'] = Variable<String>(fromFolderPath);
    }
    if (!nullToAbsent || toFolderPath != null) {
      map['to_folder_path'] = Variable<String>(toFolderPath);
    }
    if (!nullToAbsent || originalUid != null) {
      map['original_uid'] = Variable<int>(originalUid);
    }
    if (!nullToAbsent || newUid != null) {
      map['new_uid'] = Variable<int>(newUid);
    }
    {
      map['status'] = Variable<int>(
        $ActionsLogTable.$converterstatus.toSql(status),
      );
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || undoneAt != null) {
      map['undone_at'] = Variable<DateTime>(undoneAt);
    }
    return map;
  }

  ActionsLogCompanion toCompanion(bool nullToAbsent) {
    return ActionsLogCompanion(
      id: Value(id),
      batchId: Value(batchId),
      type: Value(type),
      accountId: Value(accountId),
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      messageIdHeader: messageIdHeader == null && nullToAbsent
          ? const Value.absent()
          : Value(messageIdHeader),
      fromFolderPath: fromFolderPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fromFolderPath),
      toFolderPath: toFolderPath == null && nullToAbsent
          ? const Value.absent()
          : Value(toFolderPath),
      originalUid: originalUid == null && nullToAbsent
          ? const Value.absent()
          : Value(originalUid),
      newUid: newUid == null && nullToAbsent
          ? const Value.absent()
          : Value(newUid),
      status: Value(status),
      label: Value(label),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      createdAt: Value(createdAt),
      undoneAt: undoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(undoneAt),
    );
  }

  factory ActionLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActionLogRow(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<String>(json['batchId']),
      type: $ActionsLogTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      accountId: serializer.fromJson<String>(json['accountId']),
      messageId: serializer.fromJson<int?>(json['messageId']),
      messageIdHeader: serializer.fromJson<String?>(json['messageIdHeader']),
      fromFolderPath: serializer.fromJson<String?>(json['fromFolderPath']),
      toFolderPath: serializer.fromJson<String?>(json['toFolderPath']),
      originalUid: serializer.fromJson<int?>(json['originalUid']),
      newUid: serializer.fromJson<int?>(json['newUid']),
      status: $ActionsLogTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      label: serializer.fromJson<String>(json['label']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      undoneAt: serializer.fromJson<DateTime?>(json['undoneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<String>(batchId),
      'type': serializer.toJson<int>(
        $ActionsLogTable.$convertertype.toJson(type),
      ),
      'accountId': serializer.toJson<String>(accountId),
      'messageId': serializer.toJson<int?>(messageId),
      'messageIdHeader': serializer.toJson<String?>(messageIdHeader),
      'fromFolderPath': serializer.toJson<String?>(fromFolderPath),
      'toFolderPath': serializer.toJson<String?>(toFolderPath),
      'originalUid': serializer.toJson<int?>(originalUid),
      'newUid': serializer.toJson<int?>(newUid),
      'status': serializer.toJson<int>(
        $ActionsLogTable.$converterstatus.toJson(status),
      ),
      'label': serializer.toJson<String>(label),
      'error': serializer.toJson<String?>(error),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'undoneAt': serializer.toJson<DateTime?>(undoneAt),
    };
  }

  ActionLogRow copyWith({
    int? id,
    String? batchId,
    MailActionType? type,
    String? accountId,
    Value<int?> messageId = const Value.absent(),
    Value<String?> messageIdHeader = const Value.absent(),
    Value<String?> fromFolderPath = const Value.absent(),
    Value<String?> toFolderPath = const Value.absent(),
    Value<int?> originalUid = const Value.absent(),
    Value<int?> newUid = const Value.absent(),
    ActionStatus? status,
    String? label,
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> undoneAt = const Value.absent(),
  }) => ActionLogRow(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    type: type ?? this.type,
    accountId: accountId ?? this.accountId,
    messageId: messageId.present ? messageId.value : this.messageId,
    messageIdHeader: messageIdHeader.present
        ? messageIdHeader.value
        : this.messageIdHeader,
    fromFolderPath: fromFolderPath.present
        ? fromFolderPath.value
        : this.fromFolderPath,
    toFolderPath: toFolderPath.present ? toFolderPath.value : this.toFolderPath,
    originalUid: originalUid.present ? originalUid.value : this.originalUid,
    newUid: newUid.present ? newUid.value : this.newUid,
    status: status ?? this.status,
    label: label ?? this.label,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
    undoneAt: undoneAt.present ? undoneAt.value : this.undoneAt,
  );
  ActionLogRow copyWithCompanion(ActionsLogCompanion data) {
    return ActionLogRow(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      type: data.type.present ? data.type.value : this.type,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      messageIdHeader: data.messageIdHeader.present
          ? data.messageIdHeader.value
          : this.messageIdHeader,
      fromFolderPath: data.fromFolderPath.present
          ? data.fromFolderPath.value
          : this.fromFolderPath,
      toFolderPath: data.toFolderPath.present
          ? data.toFolderPath.value
          : this.toFolderPath,
      originalUid: data.originalUid.present
          ? data.originalUid.value
          : this.originalUid,
      newUid: data.newUid.present ? data.newUid.value : this.newUid,
      status: data.status.present ? data.status.value : this.status,
      label: data.label.present ? data.label.value : this.label,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      undoneAt: data.undoneAt.present ? data.undoneAt.value : this.undoneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActionLogRow(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('type: $type, ')
          ..write('accountId: $accountId, ')
          ..write('messageId: $messageId, ')
          ..write('messageIdHeader: $messageIdHeader, ')
          ..write('fromFolderPath: $fromFolderPath, ')
          ..write('toFolderPath: $toFolderPath, ')
          ..write('originalUid: $originalUid, ')
          ..write('newUid: $newUid, ')
          ..write('status: $status, ')
          ..write('label: $label, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('undoneAt: $undoneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    batchId,
    type,
    accountId,
    messageId,
    messageIdHeader,
    fromFolderPath,
    toFolderPath,
    originalUid,
    newUid,
    status,
    label,
    error,
    createdAt,
    undoneAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionLogRow &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.type == this.type &&
          other.accountId == this.accountId &&
          other.messageId == this.messageId &&
          other.messageIdHeader == this.messageIdHeader &&
          other.fromFolderPath == this.fromFolderPath &&
          other.toFolderPath == this.toFolderPath &&
          other.originalUid == this.originalUid &&
          other.newUid == this.newUid &&
          other.status == this.status &&
          other.label == this.label &&
          other.error == this.error &&
          other.createdAt == this.createdAt &&
          other.undoneAt == this.undoneAt);
}

class ActionsLogCompanion extends UpdateCompanion<ActionLogRow> {
  final Value<int> id;
  final Value<String> batchId;
  final Value<MailActionType> type;
  final Value<String> accountId;
  final Value<int?> messageId;
  final Value<String?> messageIdHeader;
  final Value<String?> fromFolderPath;
  final Value<String?> toFolderPath;
  final Value<int?> originalUid;
  final Value<int?> newUid;
  final Value<ActionStatus> status;
  final Value<String> label;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  final Value<DateTime?> undoneAt;
  const ActionsLogCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.type = const Value.absent(),
    this.accountId = const Value.absent(),
    this.messageId = const Value.absent(),
    this.messageIdHeader = const Value.absent(),
    this.fromFolderPath = const Value.absent(),
    this.toFolderPath = const Value.absent(),
    this.originalUid = const Value.absent(),
    this.newUid = const Value.absent(),
    this.status = const Value.absent(),
    this.label = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.undoneAt = const Value.absent(),
  });
  ActionsLogCompanion.insert({
    this.id = const Value.absent(),
    required String batchId,
    required MailActionType type,
    required String accountId,
    this.messageId = const Value.absent(),
    this.messageIdHeader = const Value.absent(),
    this.fromFolderPath = const Value.absent(),
    this.toFolderPath = const Value.absent(),
    this.originalUid = const Value.absent(),
    this.newUid = const Value.absent(),
    required ActionStatus status,
    this.label = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.undoneAt = const Value.absent(),
  }) : batchId = Value(batchId),
       type = Value(type),
       accountId = Value(accountId),
       status = Value(status);
  static Insertable<ActionLogRow> custom({
    Expression<int>? id,
    Expression<String>? batchId,
    Expression<int>? type,
    Expression<String>? accountId,
    Expression<int>? messageId,
    Expression<String>? messageIdHeader,
    Expression<String>? fromFolderPath,
    Expression<String>? toFolderPath,
    Expression<int>? originalUid,
    Expression<int>? newUid,
    Expression<int>? status,
    Expression<String>? label,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? undoneAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (type != null) 'type': type,
      if (accountId != null) 'account_id': accountId,
      if (messageId != null) 'message_id': messageId,
      if (messageIdHeader != null) 'message_id_header': messageIdHeader,
      if (fromFolderPath != null) 'from_folder_path': fromFolderPath,
      if (toFolderPath != null) 'to_folder_path': toFolderPath,
      if (originalUid != null) 'original_uid': originalUid,
      if (newUid != null) 'new_uid': newUid,
      if (status != null) 'status': status,
      if (label != null) 'label': label,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
      if (undoneAt != null) 'undone_at': undoneAt,
    });
  }

  ActionsLogCompanion copyWith({
    Value<int>? id,
    Value<String>? batchId,
    Value<MailActionType>? type,
    Value<String>? accountId,
    Value<int?>? messageId,
    Value<String?>? messageIdHeader,
    Value<String?>? fromFolderPath,
    Value<String?>? toFolderPath,
    Value<int?>? originalUid,
    Value<int?>? newUid,
    Value<ActionStatus>? status,
    Value<String>? label,
    Value<String?>? error,
    Value<DateTime>? createdAt,
    Value<DateTime?>? undoneAt,
  }) {
    return ActionsLogCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      messageId: messageId ?? this.messageId,
      messageIdHeader: messageIdHeader ?? this.messageIdHeader,
      fromFolderPath: fromFolderPath ?? this.fromFolderPath,
      toFolderPath: toFolderPath ?? this.toFolderPath,
      originalUid: originalUid ?? this.originalUid,
      newUid: newUid ?? this.newUid,
      status: status ?? this.status,
      label: label ?? this.label,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      undoneAt: undoneAt ?? this.undoneAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $ActionsLogTable.$convertertype.toSql(type.value),
      );
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (messageIdHeader.present) {
      map['message_id_header'] = Variable<String>(messageIdHeader.value);
    }
    if (fromFolderPath.present) {
      map['from_folder_path'] = Variable<String>(fromFolderPath.value);
    }
    if (toFolderPath.present) {
      map['to_folder_path'] = Variable<String>(toFolderPath.value);
    }
    if (originalUid.present) {
      map['original_uid'] = Variable<int>(originalUid.value);
    }
    if (newUid.present) {
      map['new_uid'] = Variable<int>(newUid.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $ActionsLogTable.$converterstatus.toSql(status.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (undoneAt.present) {
      map['undone_at'] = Variable<DateTime>(undoneAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionsLogCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('type: $type, ')
          ..write('accountId: $accountId, ')
          ..write('messageId: $messageId, ')
          ..write('messageIdHeader: $messageIdHeader, ')
          ..write('fromFolderPath: $fromFolderPath, ')
          ..write('toFolderPath: $toFolderPath, ')
          ..write('originalUid: $originalUid, ')
          ..write('newUid: $newUid, ')
          ..write('status: $status, ')
          ..write('label: $label, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('undoneAt: $undoneAt')
          ..write(')'))
        .toString();
  }
}

class $RulesTable extends Rules with TableInfo<$RulesTable, RuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dslJsonMeta = const VerificationMeta(
    'dslJson',
  );
  @override
  late final GeneratedColumn<String> dslJson = GeneratedColumn<String>(
    'dsl_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, dslJson, enabled, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dsl_json')) {
      context.handle(
        _dslJsonMeta,
        dslJson.isAcceptableOrUnknown(data['dsl_json']!, _dslJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dslJsonMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dslJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dsl_json'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RulesTable createAlias(String alias) {
    return $RulesTable(attachedDatabase, alias);
  }
}

class RuleRow extends DataClass implements Insertable<RuleRow> {
  final int id;
  final String name;

  /// JSON of the mail-filter DSL produced by the AI command parser.
  final String dslJson;
  final bool enabled;
  final DateTime createdAt;
  const RuleRow({
    required this.id,
    required this.name,
    required this.dslJson,
    required this.enabled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['dsl_json'] = Variable<String>(dslJson);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RulesCompanion toCompanion(bool nullToAbsent) {
    return RulesCompanion(
      id: Value(id),
      name: Value(name),
      dslJson: Value(dslJson),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
    );
  }

  factory RuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuleRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dslJson: serializer.fromJson<String>(json['dslJson']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dslJson': serializer.toJson<String>(dslJson),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RuleRow copyWith({
    int? id,
    String? name,
    String? dslJson,
    bool? enabled,
    DateTime? createdAt,
  }) => RuleRow(
    id: id ?? this.id,
    name: name ?? this.name,
    dslJson: dslJson ?? this.dslJson,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
  );
  RuleRow copyWithCompanion(RulesCompanion data) {
    return RuleRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dslJson: data.dslJson.present ? data.dslJson.value : this.dslJson,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuleRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dslJson: $dslJson, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dslJson, enabled, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuleRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.dslJson == this.dslJson &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt);
}

class RulesCompanion extends UpdateCompanion<RuleRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> dslJson;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  const RulesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dslJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RulesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String dslJson,
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       dslJson = Value(dslJson);
  static Insertable<RuleRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dslJson,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dslJson != null) 'dsl_json': dslJson,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RulesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? dslJson,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
  }) {
    return RulesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dslJson: dslJson ?? this.dslJson,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dslJson.present) {
      map['dsl_json'] = Variable<String>(dslJson.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RulesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dslJson: $dslJson, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LabelsTrainingTable extends LabelsTraining
    with TableInfo<$LabelsTrainingTable, TrainingLabelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelsTrainingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, messageId, label, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labels_training';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingLabelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingLabelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingLabelRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LabelsTrainingTable createAlias(String alias) {
    return $LabelsTrainingTable(attachedDatabase, alias);
  }
}

class TrainingLabelRow extends DataClass
    implements Insertable<TrainingLabelRow> {
  final int id;
  final int messageId;
  final String label;
  final DateTime createdAt;
  const TrainingLabelRow({
    required this.id,
    required this.messageId,
    required this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<int>(messageId);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LabelsTrainingCompanion toCompanion(bool nullToAbsent) {
    return LabelsTrainingCompanion(
      id: Value(id),
      messageId: Value(messageId),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory TrainingLabelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingLabelRow(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<int>(json['messageId']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<int>(messageId),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrainingLabelRow copyWith({
    int? id,
    int? messageId,
    String? label,
    DateTime? createdAt,
  }) => TrainingLabelRow(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    label: label ?? this.label,
    createdAt: createdAt ?? this.createdAt,
  );
  TrainingLabelRow copyWithCompanion(LabelsTrainingCompanion data) {
    return TrainingLabelRow(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingLabelRow(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, messageId, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingLabelRow &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class LabelsTrainingCompanion extends UpdateCompanion<TrainingLabelRow> {
  final Value<int> id;
  final Value<int> messageId;
  final Value<String> label;
  final Value<DateTime> createdAt;
  const LabelsTrainingCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LabelsTrainingCompanion.insert({
    this.id = const Value.absent(),
    required int messageId,
    required String label,
    this.createdAt = const Value.absent(),
  }) : messageId = Value(messageId),
       label = Value(label);
  static Insertable<TrainingLabelRow> custom({
    Expression<int>? id,
    Expression<int>? messageId,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LabelsTrainingCompanion copyWith({
    Value<int>? id,
    Value<int>? messageId,
    Value<String>? label,
    Value<DateTime>? createdAt,
  }) {
    return LabelsTrainingCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsTrainingCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SummariesCacheTable extends SummariesCache
    with TableInfo<$SummariesCacheTable, SummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SummariesCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, summaryJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'summaries_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<SummaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_summaryJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SummaryRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SummariesCacheTable createAlias(String alias) {
    return $SummariesCacheTable(attachedDatabase, alias);
  }
}

class SummaryRow extends DataClass implements Insertable<SummaryRow> {
  final String key;
  final String summaryJson;
  final DateTime createdAt;
  const SummaryRow({
    required this.key,
    required this.summaryJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['summary_json'] = Variable<String>(summaryJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SummariesCacheCompanion toCompanion(bool nullToAbsent) {
    return SummariesCacheCompanion(
      key: Value(key),
      summaryJson: Value(summaryJson),
      createdAt: Value(createdAt),
    );
  }

  factory SummaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SummaryRow(
      key: serializer.fromJson<String>(json['key']),
      summaryJson: serializer.fromJson<String>(json['summaryJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'summaryJson': serializer.toJson<String>(summaryJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SummaryRow copyWith({
    String? key,
    String? summaryJson,
    DateTime? createdAt,
  }) => SummaryRow(
    key: key ?? this.key,
    summaryJson: summaryJson ?? this.summaryJson,
    createdAt: createdAt ?? this.createdAt,
  );
  SummaryRow copyWithCompanion(SummariesCacheCompanion data) {
    return SummaryRow(
      key: data.key.present ? data.key.value : this.key,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SummaryRow(')
          ..write('key: $key, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, summaryJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SummaryRow &&
          other.key == this.key &&
          other.summaryJson == this.summaryJson &&
          other.createdAt == this.createdAt);
}

class SummariesCacheCompanion extends UpdateCompanion<SummaryRow> {
  final Value<String> key;
  final Value<String> summaryJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SummariesCacheCompanion({
    this.key = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SummariesCacheCompanion.insert({
    required String key,
    required String summaryJson,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       summaryJson = Value(summaryJson);
  static Insertable<SummaryRow> custom({
    Expression<String>? key,
    Expression<String>? summaryJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SummariesCacheCompanion copyWith({
    Value<String>? key,
    Value<String>? summaryJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SummariesCacheCompanion(
      key: key ?? this.key,
      summaryJson: summaryJson ?? this.summaryJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SummariesCacheCompanion(')
          ..write('key: $key, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiTransparencyLogTable extends AiTransparencyLog
    with TableInfo<$AiTransparencyLogTable, TransparencyLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiTransparencyLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesSentMeta = const VerificationMeta(
    'bytesSent',
  );
  @override
  late final GeneratedColumn<int> bytesSent = GeneratedColumn<int>(
    'bytes_sent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purpose,
    destination,
    bytesSent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_transparency_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransparencyLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    } else if (isInserting) {
      context.missing(_purposeMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('bytes_sent')) {
      context.handle(
        _bytesSentMeta,
        bytesSent.isAcceptableOrUnknown(data['bytes_sent']!, _bytesSentMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesSentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransparencyLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransparencyLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      bytesSent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes_sent'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AiTransparencyLogTable createAlias(String alias) {
    return $AiTransparencyLogTable(attachedDatabase, alias);
  }
}

class TransparencyLogRow extends DataClass
    implements Insertable<TransparencyLogRow> {
  final int id;
  final String purpose;
  final String destination;
  final int bytesSent;
  final DateTime createdAt;
  const TransparencyLogRow({
    required this.id,
    required this.purpose,
    required this.destination,
    required this.bytesSent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purpose'] = Variable<String>(purpose);
    map['destination'] = Variable<String>(destination);
    map['bytes_sent'] = Variable<int>(bytesSent);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AiTransparencyLogCompanion toCompanion(bool nullToAbsent) {
    return AiTransparencyLogCompanion(
      id: Value(id),
      purpose: Value(purpose),
      destination: Value(destination),
      bytesSent: Value(bytesSent),
      createdAt: Value(createdAt),
    );
  }

  factory TransparencyLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransparencyLogRow(
      id: serializer.fromJson<int>(json['id']),
      purpose: serializer.fromJson<String>(json['purpose']),
      destination: serializer.fromJson<String>(json['destination']),
      bytesSent: serializer.fromJson<int>(json['bytesSent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purpose': serializer.toJson<String>(purpose),
      'destination': serializer.toJson<String>(destination),
      'bytesSent': serializer.toJson<int>(bytesSent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransparencyLogRow copyWith({
    int? id,
    String? purpose,
    String? destination,
    int? bytesSent,
    DateTime? createdAt,
  }) => TransparencyLogRow(
    id: id ?? this.id,
    purpose: purpose ?? this.purpose,
    destination: destination ?? this.destination,
    bytesSent: bytesSent ?? this.bytesSent,
    createdAt: createdAt ?? this.createdAt,
  );
  TransparencyLogRow copyWithCompanion(AiTransparencyLogCompanion data) {
    return TransparencyLogRow(
      id: data.id.present ? data.id.value : this.id,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      bytesSent: data.bytesSent.present ? data.bytesSent.value : this.bytesSent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransparencyLogRow(')
          ..write('id: $id, ')
          ..write('purpose: $purpose, ')
          ..write('destination: $destination, ')
          ..write('bytesSent: $bytesSent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purpose, destination, bytesSent, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransparencyLogRow &&
          other.id == this.id &&
          other.purpose == this.purpose &&
          other.destination == this.destination &&
          other.bytesSent == this.bytesSent &&
          other.createdAt == this.createdAt);
}

class AiTransparencyLogCompanion extends UpdateCompanion<TransparencyLogRow> {
  final Value<int> id;
  final Value<String> purpose;
  final Value<String> destination;
  final Value<int> bytesSent;
  final Value<DateTime> createdAt;
  const AiTransparencyLogCompanion({
    this.id = const Value.absent(),
    this.purpose = const Value.absent(),
    this.destination = const Value.absent(),
    this.bytesSent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AiTransparencyLogCompanion.insert({
    this.id = const Value.absent(),
    required String purpose,
    required String destination,
    required int bytesSent,
    this.createdAt = const Value.absent(),
  }) : purpose = Value(purpose),
       destination = Value(destination),
       bytesSent = Value(bytesSent);
  static Insertable<TransparencyLogRow> custom({
    Expression<int>? id,
    Expression<String>? purpose,
    Expression<String>? destination,
    Expression<int>? bytesSent,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purpose != null) 'purpose': purpose,
      if (destination != null) 'destination': destination,
      if (bytesSent != null) 'bytes_sent': bytesSent,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AiTransparencyLogCompanion copyWith({
    Value<int>? id,
    Value<String>? purpose,
    Value<String>? destination,
    Value<int>? bytesSent,
    Value<DateTime>? createdAt,
  }) {
    return AiTransparencyLogCompanion(
      id: id ?? this.id,
      purpose: purpose ?? this.purpose,
      destination: destination ?? this.destination,
      bytesSent: bytesSent ?? this.bytesSent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (bytesSent.present) {
      map['bytes_sent'] = Variable<int>(bytesSent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiTransparencyLogCompanion(')
          ..write('id: $id, ')
          ..write('purpose: $purpose, ')
          ..write('destination: $destination, ')
          ..write('bytesSent: $bytesSent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $SendersTable senders = $SendersTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $MessageTagsTable messageTags = $MessageTagsTable(this);
  late final $ActionsLogTable actionsLog = $ActionsLogTable(this);
  late final $RulesTable rules = $RulesTable(this);
  late final $LabelsTrainingTable labelsTraining = $LabelsTrainingTable(this);
  late final $SummariesCacheTable summariesCache = $SummariesCacheTable(this);
  late final $AiTransparencyLogTable aiTransparencyLog =
      $AiTransparencyLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    folders,
    messages,
    senders,
    tags,
    messageTags,
    actionsLog,
    rules,
    labelsTraining,
    summariesCache,
    aiTransparencyLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('folders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'folders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'messages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('message_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('message_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'messages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('labels_training', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required MailProviderType provider,
  required AuthKind authKind,
  required String email,
  Value<String> displayName,
  Value<String> imapHost,
  Value<int> imapPort,
  Value<String> smtpHost,
  Value<int> smtpPort,
  Value<SyncState> syncState,
  Value<String?> lastError,
  Value<DateTime?> lastSyncAt,
  Value<int?> quotaUsedBytes,
  Value<int?> quotaTotalBytes,
  Value<int> bytesToday,
  Value<DateTime?> bytesDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<MailProviderType> provider,
  Value<AuthKind> authKind,
  Value<String> email,
  Value<String> displayName,
  Value<String> imapHost,
  Value<int> imapPort,
  Value<String> smtpHost,
  Value<int> smtpPort,
  Value<SyncState> syncState,
  Value<String?> lastError,
  Value<DateTime?> lastSyncAt,
  Value<int?> quotaUsedBytes,
  Value<int?> quotaTotalBytes,
  Value<int> bytesToday,
  Value<DateTime?> bytesDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, AccountRow> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoldersTable, List<FolderRow>> _foldersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.folders,
    aliasName: 'accounts__id__folders__account_id',
  );

  $$FoldersTableProcessedTableManager get foldersRefs {
    final manager = $$FoldersTableTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_foldersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<MessageRow>>
  _messagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'accounts__id__messages__account_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MailProviderType, MailProviderType, int>
  get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<AuthKind, AuthKind, int> get authKind =>
      $composableBuilder(
        column: $table.authKind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imapHost => $composableBuilder(
    column: $table.imapHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get imapPort => $composableBuilder(
    column: $table.imapPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smtpHost => $composableBuilder(
    column: $table.smtpHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get smtpPort => $composableBuilder(
    column: $table.smtpPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, int> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quotaUsedBytes => $composableBuilder(
    column: $table.quotaUsedBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quotaTotalBytes => $composableBuilder(
    column: $table.quotaTotalBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytesToday => $composableBuilder(
    column: $table.bytesToday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bytesDay => $composableBuilder(
    column: $table.bytesDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> foldersRefs(
    Expression<bool> Function($$FoldersTableFilterComposer f) f,
  ) {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authKind => $composableBuilder(
    column: $table.authKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imapHost => $composableBuilder(
    column: $table.imapHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get imapPort => $composableBuilder(
    column: $table.imapPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smtpHost => $composableBuilder(
    column: $table.smtpHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get smtpPort => $composableBuilder(
    column: $table.smtpPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quotaUsedBytes => $composableBuilder(
    column: $table.quotaUsedBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quotaTotalBytes => $composableBuilder(
    column: $table.quotaTotalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytesToday => $composableBuilder(
    column: $table.bytesToday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bytesDay => $composableBuilder(
    column: $table.bytesDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MailProviderType, int> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AuthKind, int> get authKind =>
      $composableBuilder(column: $table.authKind, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imapHost =>
      $composableBuilder(column: $table.imapHost, builder: (column) => column);

  GeneratedColumn<int> get imapPort =>
      $composableBuilder(column: $table.imapPort, builder: (column) => column);

  GeneratedColumn<String> get smtpHost =>
      $composableBuilder(column: $table.smtpHost, builder: (column) => column);

  GeneratedColumn<int> get smtpPort =>
      $composableBuilder(column: $table.smtpPort, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, int> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quotaUsedBytes => $composableBuilder(
    column: $table.quotaUsedBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quotaTotalBytes => $composableBuilder(
    column: $table.quotaTotalBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bytesToday => $composableBuilder(
    column: $table.bytesToday,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get bytesDay =>
      $composableBuilder(column: $table.bytesDay, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> foldersRefs<T extends Object>(
    Expression<T> Function($$FoldersTableAnnotationComposer a) f,
  ) {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (AccountRow, $$AccountsTableReferences),
          AccountRow,
          PrefetchHooks Function({bool foldersRefs, bool messagesRefs})
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<MailProviderType> provider = const Value.absent(),
                Value<AuthKind> authKind = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> imapHost = const Value.absent(),
                Value<int> imapPort = const Value.absent(),
                Value<String> smtpHost = const Value.absent(),
                Value<int> smtpPort = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int?> quotaUsedBytes = const Value.absent(),
                Value<int?> quotaTotalBytes = const Value.absent(),
                Value<int> bytesToday = const Value.absent(),
                Value<DateTime?> bytesDay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                provider: provider,
                authKind: authKind,
                email: email,
                displayName: displayName,
                imapHost: imapHost,
                imapPort: imapPort,
                smtpHost: smtpHost,
                smtpPort: smtpPort,
                syncState: syncState,
                lastError: lastError,
                lastSyncAt: lastSyncAt,
                quotaUsedBytes: quotaUsedBytes,
                quotaTotalBytes: quotaTotalBytes,
                bytesToday: bytesToday,
                bytesDay: bytesDay,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required MailProviderType provider,
                required AuthKind authKind,
                required String email,
                Value<String> displayName = const Value.absent(),
                Value<String> imapHost = const Value.absent(),
                Value<int> imapPort = const Value.absent(),
                Value<String> smtpHost = const Value.absent(),
                Value<int> smtpPort = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int?> quotaUsedBytes = const Value.absent(),
                Value<int?> quotaTotalBytes = const Value.absent(),
                Value<int> bytesToday = const Value.absent(),
                Value<DateTime?> bytesDay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                provider: provider,
                authKind: authKind,
                email: email,
                displayName: displayName,
                imapHost: imapHost,
                imapPort: imapPort,
                smtpHost: smtpHost,
                smtpPort: smtpPort,
                syncState: syncState,
                lastError: lastError,
                lastSyncAt: lastSyncAt,
                quotaUsedBytes: quotaUsedBytes,
                quotaTotalBytes: quotaTotalBytes,
                bytesToday: bytesToday,
                bytesDay: bytesDay,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, AccountRow>(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foldersRefs = false, messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (foldersRefs) db.folders,
                if (messagesRefs) db.messages,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (foldersRefs)
                    await $_getPrefetchedData<
                      AccountRow,
                      $AccountsTable,
                      FolderRow
                    >(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._foldersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AccountsTableReferences(db, table, p0).foldersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                  if (messagesRefs)
                    await $_getPrefetchedData<
                      AccountRow,
                      $AccountsTable,
                      MessageRow
                    >(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AccountsTableReferences(db, table, p0).messagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, $$AccountsTableReferences),
      AccountRow,
      PrefetchHooks Function({bool foldersRefs, bool messagesRefs})
    >;
typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({
  Value<int> id,
  required String accountId,
  required String path,
  required String name,
  required FolderRole role,
  Value<int?> uidValidity,
  Value<int?> uidNext,
  Value<int?> highestModSeq,
  Value<int> totalCount,
  Value<int> unreadCount,
  Value<bool> stale,
});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({
  Value<int> id,
  Value<String> accountId,
  Value<String> path,
  Value<String> name,
  Value<FolderRole> role,
  Value<int?> uidValidity,
  Value<int?> uidNext,
  Value<int?> highestModSeq,
  Value<int> totalCount,
  Value<int> unreadCount,
  Value<bool> stale,
});

final class $$FoldersTableReferences
    extends BaseReferences<_$AppDatabase, $FoldersTable, FolderRow> {
  $$FoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('folders__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<MessageRow>>
  _messagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'folders__id__messages__folder_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FolderRole, FolderRole, int> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get uidValidity => $composableBuilder(
    column: $table.uidValidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uidNext => $composableBuilder(
    column: $table.uidNext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highestModSeq => $composableBuilder(
    column: $table.highestModSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stale => $composableBuilder(
    column: $table.stale,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uidValidity => $composableBuilder(
    column: $table.uidValidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uidNext => $composableBuilder(
    column: $table.uidNext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highestModSeq => $composableBuilder(
    column: $table.highestModSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stale => $composableBuilder(
    column: $table.stale,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FolderRole, int> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get uidValidity => $composableBuilder(
    column: $table.uidValidity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uidNext =>
      $composableBuilder(column: $table.uidNext, builder: (column) => column);

  GeneratedColumn<int> get highestModSeq => $composableBuilder(
    column: $table.highestModSeq,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stale =>
      $composableBuilder(column: $table.stale, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          FolderRow,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (FolderRow, $$FoldersTableReferences),
          FolderRow,
          PrefetchHooks Function({bool accountId, bool messagesRefs})
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<FolderRole> role = const Value.absent(),
                Value<int?> uidValidity = const Value.absent(),
                Value<int?> uidNext = const Value.absent(),
                Value<int?> highestModSeq = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<bool> stale = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                accountId: accountId,
                path: path,
                name: name,
                role: role,
                uidValidity: uidValidity,
                uidNext: uidNext,
                highestModSeq: highestModSeq,
                totalCount: totalCount,
                unreadCount: unreadCount,
                stale: stale,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountId,
                required String path,
                required String name,
                required FolderRole role,
                Value<int?> uidValidity = const Value.absent(),
                Value<int?> uidNext = const Value.absent(),
                Value<int?> highestModSeq = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<bool> stale = const Value.absent(),
              }) => FoldersCompanion.insert(
                id: id,
                accountId: accountId,
                path: path,
                name: name,
                role: role,
                uidValidity: uidValidity,
                uidNext: uidNext,
                highestModSeq: highestModSeq,
                totalCount: totalCount,
                unreadCount: unreadCount,
                stale: stale,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoldersTable, FolderRow>(table),
                  $$FoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$FoldersTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$FoldersTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData<
                      FolderRow,
                      $FoldersTable,
                      MessageRow
                    >(
                      currentTable: table,
                      referencedTable: $$FoldersTableReferences
                          ._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FoldersTableReferences(db, table, p0).messagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.folderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      FolderRow,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (FolderRow, $$FoldersTableReferences),
      FolderRow,
      PrefetchHooks Function({bool accountId, bool messagesRefs})
    >;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  required String accountId,
  required int folderId,
  required int uid,
  Value<String?> messageIdHeader,
  Value<int?> gmMsgId,
  Value<String?> threadId,
  required String fromEmail,
  Value<String> fromName,
  Value<String> toLine,
  Value<String> subject,
  Value<String> snippet,
  required DateTime date,
  Value<int> size,
  Value<bool> isSeen,
  Value<bool> isFlagged,
  Value<bool> hasAttachments,
  Value<String?> listId,
  Value<String?> listUnsubscribe,
  Value<bool> listUnsubscribePost,
  Value<String?> precedence,
  Value<String?> autoSubmitted,
  Value<bool?> dkimPass,
  Value<String?> gmLabels,
  Value<MailCategory?> category,
  Value<double?> categoryConfidence,
  Value<String?> categoryReason,
  Value<bool> isProtected,
  Value<DateTime?> expiresAt,
  Value<String?> bodyText,
  Value<DateTime> syncedAt,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  Value<String> accountId,
  Value<int> folderId,
  Value<int> uid,
  Value<String?> messageIdHeader,
  Value<int?> gmMsgId,
  Value<String?> threadId,
  Value<String> fromEmail,
  Value<String> fromName,
  Value<String> toLine,
  Value<String> subject,
  Value<String> snippet,
  Value<DateTime> date,
  Value<int> size,
  Value<bool> isSeen,
  Value<bool> isFlagged,
  Value<bool> hasAttachments,
  Value<String?> listId,
  Value<String?> listUnsubscribe,
  Value<bool> listUnsubscribePost,
  Value<String?> precedence,
  Value<String?> autoSubmitted,
  Value<bool?> dkimPass,
  Value<String?> gmLabels,
  Value<MailCategory?> category,
  Value<double?> categoryConfidence,
  Value<String?> categoryReason,
  Value<bool> isProtected,
  Value<DateTime?> expiresAt,
  Value<String?> bodyText,
  Value<DateTime> syncedAt,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, MessageRow> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('messages__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FoldersTable _folderIdTable(_$AppDatabase db) =>
      db.folders.createAlias('messages__folder_id__folders__id');

  $$FoldersTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<int>('folder_id')!;

    final manager = $$FoldersTableTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessageTagsTable, List<MessageTagRow>>
  _messageTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messageTags,
    aliasName: 'messages__id__message_tags__message_id',
  );

  $$MessageTagsTableProcessedTableManager get messageTagsRefs {
    final manager = $$MessageTagsTableTableManager(
      $_db,
      $_db.messageTags,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messageTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LabelsTrainingTable, List<TrainingLabelRow>>
  _labelsTrainingRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.labelsTraining,
    aliasName: 'messages__id__labels_training__message_id',
  );

  $$LabelsTrainingTableProcessedTableManager get labelsTrainingRefs {
    final manager = $$LabelsTrainingTableTableManager(
      $_db,
      $_db.labelsTraining,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_labelsTrainingRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gmMsgId => $composableBuilder(
    column: $table.gmMsgId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromEmail => $composableBuilder(
    column: $table.fromEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toLine => $composableBuilder(
    column: $table.toLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSeen => $composableBuilder(
    column: $table.isSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFlagged => $composableBuilder(
    column: $table.isFlagged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAttachments => $composableBuilder(
    column: $table.hasAttachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listUnsubscribe => $composableBuilder(
    column: $table.listUnsubscribe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get listUnsubscribePost => $composableBuilder(
    column: $table.listUnsubscribePost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get precedence => $composableBuilder(
    column: $table.precedence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autoSubmitted => $composableBuilder(
    column: $table.autoSubmitted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dkimPass => $composableBuilder(
    column: $table.dkimPass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmLabels => $composableBuilder(
    column: $table.gmLabels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MailCategory?, MailCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get categoryConfidence => $composableBuilder(
    column: $table.categoryConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryReason => $composableBuilder(
    column: $table.categoryReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoldersTableFilterComposer get folderId {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messageTagsRefs(
    Expression<bool> Function($$MessageTagsTableFilterComposer f) f,
  ) {
    final $$MessageTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTags,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTagsTableFilterComposer(
            $db: $db,
            $table: $db.messageTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> labelsTrainingRefs(
    Expression<bool> Function($$LabelsTrainingTableFilterComposer f) f,
  ) {
    final $$LabelsTrainingTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labelsTraining,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTrainingTableFilterComposer(
            $db: $db,
            $table: $db.labelsTraining,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gmMsgId => $composableBuilder(
    column: $table.gmMsgId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromEmail => $composableBuilder(
    column: $table.fromEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toLine => $composableBuilder(
    column: $table.toLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSeen => $composableBuilder(
    column: $table.isSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFlagged => $composableBuilder(
    column: $table.isFlagged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAttachments => $composableBuilder(
    column: $table.hasAttachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listUnsubscribe => $composableBuilder(
    column: $table.listUnsubscribe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get listUnsubscribePost => $composableBuilder(
    column: $table.listUnsubscribePost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get precedence => $composableBuilder(
    column: $table.precedence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autoSubmitted => $composableBuilder(
    column: $table.autoSubmitted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dkimPass => $composableBuilder(
    column: $table.dkimPass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmLabels => $composableBuilder(
    column: $table.gmLabels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get categoryConfidence => $composableBuilder(
    column: $table.categoryConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryReason => $composableBuilder(
    column: $table.categoryReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoldersTableOrderingComposer get folderId {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableOrderingComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gmMsgId =>
      $composableBuilder(column: $table.gmMsgId, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get fromEmail =>
      $composableBuilder(column: $table.fromEmail, builder: (column) => column);

  GeneratedColumn<String> get fromName =>
      $composableBuilder(column: $table.fromName, builder: (column) => column);

  GeneratedColumn<String> get toLine =>
      $composableBuilder(column: $table.toLine, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get snippet =>
      $composableBuilder(column: $table.snippet, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<bool> get isSeen =>
      $composableBuilder(column: $table.isSeen, builder: (column) => column);

  GeneratedColumn<bool> get isFlagged =>
      $composableBuilder(column: $table.isFlagged, builder: (column) => column);

  GeneratedColumn<bool> get hasAttachments => $composableBuilder(
    column: $table.hasAttachments,
    builder: (column) => column,
  );

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get listUnsubscribe => $composableBuilder(
    column: $table.listUnsubscribe,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get listUnsubscribePost => $composableBuilder(
    column: $table.listUnsubscribePost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get precedence => $composableBuilder(
    column: $table.precedence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get autoSubmitted => $composableBuilder(
    column: $table.autoSubmitted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dkimPass =>
      $composableBuilder(column: $table.dkimPass, builder: (column) => column);

  GeneratedColumn<String> get gmLabels =>
      $composableBuilder(column: $table.gmLabels, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MailCategory?, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get categoryConfidence => $composableBuilder(
    column: $table.categoryConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryReason => $composableBuilder(
    column: $table.categoryReason,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get bodyText =>
      $composableBuilder(column: $table.bodyText, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoldersTableAnnotationComposer get folderId {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messageTagsRefs<T extends Object>(
    Expression<T> Function($$MessageTagsTableAnnotationComposer a) f,
  ) {
    final $$MessageTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTags,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.messageTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> labelsTrainingRefs<T extends Object>(
    Expression<T> Function($$LabelsTrainingTableAnnotationComposer a) f,
  ) {
    final $$LabelsTrainingTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labelsTraining,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTrainingTableAnnotationComposer(
            $db: $db,
            $table: $db.labelsTraining,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          MessageRow,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (MessageRow, $$MessagesTableReferences),
          MessageRow,
          PrefetchHooks Function({
            bool accountId,
            bool folderId,
            bool messageTagsRefs,
            bool labelsTrainingRefs,
          })
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> folderId = const Value.absent(),
                Value<int> uid = const Value.absent(),
                Value<String?> messageIdHeader = const Value.absent(),
                Value<int?> gmMsgId = const Value.absent(),
                Value<String?> threadId = const Value.absent(),
                Value<String> fromEmail = const Value.absent(),
                Value<String> fromName = const Value.absent(),
                Value<String> toLine = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> snippet = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<bool> isSeen = const Value.absent(),
                Value<bool> isFlagged = const Value.absent(),
                Value<bool> hasAttachments = const Value.absent(),
                Value<String?> listId = const Value.absent(),
                Value<String?> listUnsubscribe = const Value.absent(),
                Value<bool> listUnsubscribePost = const Value.absent(),
                Value<String?> precedence = const Value.absent(),
                Value<String?> autoSubmitted = const Value.absent(),
                Value<bool?> dkimPass = const Value.absent(),
                Value<String?> gmLabels = const Value.absent(),
                Value<MailCategory?> category = const Value.absent(),
                Value<double?> categoryConfidence = const Value.absent(),
                Value<String?> categoryReason = const Value.absent(),
                Value<bool> isProtected = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String?> bodyText = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                accountId: accountId,
                folderId: folderId,
                uid: uid,
                messageIdHeader: messageIdHeader,
                gmMsgId: gmMsgId,
                threadId: threadId,
                fromEmail: fromEmail,
                fromName: fromName,
                toLine: toLine,
                subject: subject,
                snippet: snippet,
                date: date,
                size: size,
                isSeen: isSeen,
                isFlagged: isFlagged,
                hasAttachments: hasAttachments,
                listId: listId,
                listUnsubscribe: listUnsubscribe,
                listUnsubscribePost: listUnsubscribePost,
                precedence: precedence,
                autoSubmitted: autoSubmitted,
                dkimPass: dkimPass,
                gmLabels: gmLabels,
                category: category,
                categoryConfidence: categoryConfidence,
                categoryReason: categoryReason,
                isProtected: isProtected,
                expiresAt: expiresAt,
                bodyText: bodyText,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountId,
                required int folderId,
                required int uid,
                Value<String?> messageIdHeader = const Value.absent(),
                Value<int?> gmMsgId = const Value.absent(),
                Value<String?> threadId = const Value.absent(),
                required String fromEmail,
                Value<String> fromName = const Value.absent(),
                Value<String> toLine = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> snippet = const Value.absent(),
                required DateTime date,
                Value<int> size = const Value.absent(),
                Value<bool> isSeen = const Value.absent(),
                Value<bool> isFlagged = const Value.absent(),
                Value<bool> hasAttachments = const Value.absent(),
                Value<String?> listId = const Value.absent(),
                Value<String?> listUnsubscribe = const Value.absent(),
                Value<bool> listUnsubscribePost = const Value.absent(),
                Value<String?> precedence = const Value.absent(),
                Value<String?> autoSubmitted = const Value.absent(),
                Value<bool?> dkimPass = const Value.absent(),
                Value<String?> gmLabels = const Value.absent(),
                Value<MailCategory?> category = const Value.absent(),
                Value<double?> categoryConfidence = const Value.absent(),
                Value<String?> categoryReason = const Value.absent(),
                Value<bool> isProtected = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String?> bodyText = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                accountId: accountId,
                folderId: folderId,
                uid: uid,
                messageIdHeader: messageIdHeader,
                gmMsgId: gmMsgId,
                threadId: threadId,
                fromEmail: fromEmail,
                fromName: fromName,
                toLine: toLine,
                subject: subject,
                snippet: snippet,
                date: date,
                size: size,
                isSeen: isSeen,
                isFlagged: isFlagged,
                hasAttachments: hasAttachments,
                listId: listId,
                listUnsubscribe: listUnsubscribe,
                listUnsubscribePost: listUnsubscribePost,
                precedence: precedence,
                autoSubmitted: autoSubmitted,
                dkimPass: dkimPass,
                gmLabels: gmLabels,
                category: category,
                categoryConfidence: categoryConfidence,
                categoryReason: categoryReason,
                isProtected: isProtected,
                expiresAt: expiresAt,
                bodyText: bodyText,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, MessageRow>(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                folderId = false,
                messageTagsRefs = false,
                labelsTrainingRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (messageTagsRefs) db.messageTags,
                    if (labelsTrainingRefs) db.labelsTraining,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$MessagesTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$MessagesTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (folderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.folderId,
                            referencedTable: $$MessagesTableReferences
                                ._folderIdTable(db),
                            referencedColumn: $$MessagesTableReferences
                                ._folderIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (messageTagsRefs)
                        await $_getPrefetchedData<
                          MessageRow,
                          $MessagesTable,
                          MessageTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$MessagesTableReferences
                              ._messageTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MessagesTableReferences(
                                db,
                                table,
                                p0,
                              ).messageTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.messageId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (labelsTrainingRefs)
                        await $_getPrefetchedData<
                          MessageRow,
                          $MessagesTable,
                          TrainingLabelRow
                        >(
                          currentTable: table,
                          referencedTable: $$MessagesTableReferences
                              ._labelsTrainingRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MessagesTableReferences(
                                db,
                                table,
                                p0,
                              ).labelsTrainingRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.messageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      MessageRow,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (MessageRow, $$MessagesTableReferences),
      MessageRow,
      PrefetchHooks Function({
        bool accountId,
        bool folderId,
        bool messageTagsRefs,
        bool labelsTrainingRefs,
      })
    >;
typedef $$SendersTableCreateCompanionBuilder = SendersCompanion Function({
  required String email,
  Value<String> name,
  required String domain,
  Value<SenderDecision> decision,
  Value<DateTime?> decidedAt,
  Value<int> rowid,
});
typedef $$SendersTableUpdateCompanionBuilder = SendersCompanion Function({
  Value<String> email,
  Value<String> name,
  Value<String> domain,
  Value<SenderDecision> decision,
  Value<DateTime?> decidedAt,
  Value<int> rowid,
});

class $$SendersTableFilterComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SenderDecision, SenderDecision, int>
  get decision => $composableBuilder(
    column: $table.decision,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SendersTableOrderingComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decision => $composableBuilder(
    column: $table.decision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SendersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SendersTable> {
  $$SendersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SenderDecision, int> get decision =>
      $composableBuilder(column: $table.decision, builder: (column) => column);

  GeneratedColumn<DateTime> get decidedAt =>
      $composableBuilder(column: $table.decidedAt, builder: (column) => column);
}

class $$SendersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SendersTable,
          SenderRow,
          $$SendersTableFilterComposer,
          $$SendersTableOrderingComposer,
          $$SendersTableAnnotationComposer,
          $$SendersTableCreateCompanionBuilder,
          $$SendersTableUpdateCompanionBuilder,
          (SenderRow, BaseReferences<_$AppDatabase, $SendersTable, SenderRow>),
          SenderRow,
          PrefetchHooks Function()
        > {
  $$SendersTableTableManager(_$AppDatabase db, $SendersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SendersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SendersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SendersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> email = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> domain = const Value.absent(),
                Value<SenderDecision> decision = const Value.absent(),
                Value<DateTime?> decidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SendersCompanion(
                email: email,
                name: name,
                domain: domain,
                decision: decision,
                decidedAt: decidedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String email,
                Value<String> name = const Value.absent(),
                required String domain,
                Value<SenderDecision> decision = const Value.absent(),
                Value<DateTime?> decidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SendersCompanion.insert(
                email: email,
                name: name,
                domain: domain,
                decision: decision,
                decidedAt: decidedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SendersTable, SenderRow>(table),
                  BaseReferences<_$AppDatabase, $SendersTable, SenderRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SendersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SendersTable,
      SenderRow,
      $$SendersTableFilterComposer,
      $$SendersTableOrderingComposer,
      $$SendersTableAnnotationComposer,
      $$SendersTableCreateCompanionBuilder,
      $$SendersTableUpdateCompanionBuilder,
      (SenderRow, BaseReferences<_$AppDatabase, $SendersTable, SenderRow>),
      SenderRow,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String key,
  required String name,
  Value<String> colorKey,
  required TagKind kind,
  Value<String?> description,
  Value<bool> isProtected,
  Value<DateTime> createdAt,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> key,
  Value<String> name,
  Value<String> colorKey,
  Value<TagKind> kind,
  Value<String?> description,
  Value<bool> isProtected,
  Value<DateTime> createdAt,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, TagRow> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessageTagsTable, List<MessageTagRow>>
  _messageTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messageTags,
    aliasName: 'tags__id__message_tags__tag_id',
  );

  $$MessageTagsTableProcessedTableManager get messageTagsRefs {
    final manager = $$MessageTagsTableTableManager(
      $_db,
      $_db.messageTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messageTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TagKind, TagKind, int> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> messageTagsRefs(
    Expression<bool> Function($$MessageTagsTableFilterComposer f) f,
  ) {
    final $$MessageTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTagsTableFilterComposer(
            $db: $db,
            $table: $db.messageTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorKey =>
      $composableBuilder(column: $table.colorKey, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TagKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> messageTagsRefs<T extends Object>(
    Expression<T> Function($$MessageTagsTableAnnotationComposer a) f,
  ) {
    final $$MessageTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messageTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessageTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.messageTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          TagRow,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagRow, $$TagsTableReferences),
          TagRow,
          PrefetchHooks Function({bool messageTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorKey = const Value.absent(),
                Value<TagKind> kind = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isProtected = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                key: key,
                name: name,
                colorKey: colorKey,
                kind: kind,
                description: description,
                isProtected: isProtected,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String name,
                Value<String> colorKey = const Value.absent(),
                required TagKind kind,
                Value<String?> description = const Value.absent(),
                Value<bool> isProtected = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                key: key,
                name: name,
                colorKey: colorKey,
                kind: kind,
                description: description,
                isProtected: isProtected,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, TagRow>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messageTagsRefs) db.messageTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messageTagsRefs)
                    await $_getPrefetchedData<
                      TagRow,
                      $TagsTable,
                      MessageTagRow
                    >(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._messageTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).messageTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      TagRow,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagRow, $$TagsTableReferences),
      TagRow,
      PrefetchHooks Function({bool messageTagsRefs})
    >;
typedef $$MessageTagsTableCreateCompanionBuilder =
    MessageTagsCompanion Function({
      required int messageId,
      required int tagId,
      Value<double> confidence,
      required TagSource source,
      Value<int> rowid,
    });
typedef $$MessageTagsTableUpdateCompanionBuilder =
    MessageTagsCompanion Function({
      Value<int> messageId,
      Value<int> tagId,
      Value<double> confidence,
      Value<TagSource> source,
      Value<int> rowid,
    });

final class $$MessageTagsTableReferences
    extends BaseReferences<_$AppDatabase, $MessageTagsTable, MessageTagRow> {
  $$MessageTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MessagesTable _messageIdTable(_$AppDatabase db) =>
      db.messages.createAlias('message_tags__message_id__messages__id');

  $$MessagesTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<int>('message_id')!;

    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('message_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessageTagsTableFilterComposer
    extends Composer<_$AppDatabase, $MessageTagsTable> {
  $$MessageTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TagSource, TagSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$MessagesTableFilterComposer get messageId {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageTagsTable> {
  $$MessageTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$MessagesTableOrderingComposer get messageId {
    final $$MessagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableOrderingComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageTagsTable> {
  $$MessageTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TagSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$MessagesTableAnnotationComposer get messageId {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessageTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageTagsTable,
          MessageTagRow,
          $$MessageTagsTableFilterComposer,
          $$MessageTagsTableOrderingComposer,
          $$MessageTagsTableAnnotationComposer,
          $$MessageTagsTableCreateCompanionBuilder,
          $$MessageTagsTableUpdateCompanionBuilder,
          (MessageTagRow, $$MessageTagsTableReferences),
          MessageTagRow,
          PrefetchHooks Function({bool messageId, bool tagId})
        > {
  $$MessageTagsTableTableManager(_$AppDatabase db, $MessageTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> messageId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<TagSource> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageTagsCompanion(
                messageId: messageId,
                tagId: tagId,
                confidence: confidence,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int messageId,
                required int tagId,
                Value<double> confidence = const Value.absent(),
                required TagSource source,
                Value<int> rowid = const Value.absent(),
              }) => MessageTagsCompanion.insert(
                messageId: messageId,
                tagId: tagId,
                confidence: confidence,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessageTagsTable, MessageTagRow>(table),
                  $$MessageTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$MessageTagsTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$MessageTagsTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$MessageTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$MessageTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessageTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageTagsTable,
      MessageTagRow,
      $$MessageTagsTableFilterComposer,
      $$MessageTagsTableOrderingComposer,
      $$MessageTagsTableAnnotationComposer,
      $$MessageTagsTableCreateCompanionBuilder,
      $$MessageTagsTableUpdateCompanionBuilder,
      (MessageTagRow, $$MessageTagsTableReferences),
      MessageTagRow,
      PrefetchHooks Function({bool messageId, bool tagId})
    >;
typedef $$ActionsLogTableCreateCompanionBuilder = ActionsLogCompanion Function({
  Value<int> id,
  required String batchId,
  required MailActionType type,
  required String accountId,
  Value<int?> messageId,
  Value<String?> messageIdHeader,
  Value<String?> fromFolderPath,
  Value<String?> toFolderPath,
  Value<int?> originalUid,
  Value<int?> newUid,
  required ActionStatus status,
  Value<String> label,
  Value<String?> error,
  Value<DateTime> createdAt,
  Value<DateTime?> undoneAt,
});
typedef $$ActionsLogTableUpdateCompanionBuilder = ActionsLogCompanion Function({
  Value<int> id,
  Value<String> batchId,
  Value<MailActionType> type,
  Value<String> accountId,
  Value<int?> messageId,
  Value<String?> messageIdHeader,
  Value<String?> fromFolderPath,
  Value<String?> toFolderPath,
  Value<int?> originalUid,
  Value<int?> newUid,
  Value<ActionStatus> status,
  Value<String> label,
  Value<String?> error,
  Value<DateTime> createdAt,
  Value<DateTime?> undoneAt,
});

class $$ActionsLogTableFilterComposer
    extends Composer<_$AppDatabase, $ActionsLogTable> {
  $$ActionsLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MailActionType, MailActionType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromFolderPath => $composableBuilder(
    column: $table.fromFolderPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toFolderPath => $composableBuilder(
    column: $table.toFolderPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalUid => $composableBuilder(
    column: $table.originalUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newUid => $composableBuilder(
    column: $table.newUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActionStatus, ActionStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get undoneAt => $composableBuilder(
    column: $table.undoneAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActionsLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ActionsLogTable> {
  $$ActionsLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromFolderPath => $composableBuilder(
    column: $table.fromFolderPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toFolderPath => $composableBuilder(
    column: $table.toFolderPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalUid => $composableBuilder(
    column: $table.originalUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newUid => $composableBuilder(
    column: $table.newUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get undoneAt => $composableBuilder(
    column: $table.undoneAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActionsLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActionsLogTable> {
  $$ActionsLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MailActionType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromFolderPath => $composableBuilder(
    column: $table.fromFolderPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toFolderPath => $composableBuilder(
    column: $table.toFolderPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalUid => $composableBuilder(
    column: $table.originalUid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newUid =>
      $composableBuilder(column: $table.newUid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get undoneAt =>
      $composableBuilder(column: $table.undoneAt, builder: (column) => column);
}

class $$ActionsLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActionsLogTable,
          ActionLogRow,
          $$ActionsLogTableFilterComposer,
          $$ActionsLogTableOrderingComposer,
          $$ActionsLogTableAnnotationComposer,
          $$ActionsLogTableCreateCompanionBuilder,
          $$ActionsLogTableUpdateCompanionBuilder,
          (
            ActionLogRow,
            BaseReferences<_$AppDatabase, $ActionsLogTable, ActionLogRow>,
          ),
          ActionLogRow,
          PrefetchHooks Function()
        > {
  $$ActionsLogTableTableManager(_$AppDatabase db, $ActionsLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionsLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionsLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionsLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> batchId = const Value.absent(),
                Value<MailActionType> type = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int?> messageId = const Value.absent(),
                Value<String?> messageIdHeader = const Value.absent(),
                Value<String?> fromFolderPath = const Value.absent(),
                Value<String?> toFolderPath = const Value.absent(),
                Value<int?> originalUid = const Value.absent(),
                Value<int?> newUid = const Value.absent(),
                Value<ActionStatus> status = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> undoneAt = const Value.absent(),
              }) => ActionsLogCompanion(
                id: id,
                batchId: batchId,
                type: type,
                accountId: accountId,
                messageId: messageId,
                messageIdHeader: messageIdHeader,
                fromFolderPath: fromFolderPath,
                toFolderPath: toFolderPath,
                originalUid: originalUid,
                newUid: newUid,
                status: status,
                label: label,
                error: error,
                createdAt: createdAt,
                undoneAt: undoneAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String batchId,
                required MailActionType type,
                required String accountId,
                Value<int?> messageId = const Value.absent(),
                Value<String?> messageIdHeader = const Value.absent(),
                Value<String?> fromFolderPath = const Value.absent(),
                Value<String?> toFolderPath = const Value.absent(),
                Value<int?> originalUid = const Value.absent(),
                Value<int?> newUid = const Value.absent(),
                required ActionStatus status,
                Value<String> label = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> undoneAt = const Value.absent(),
              }) => ActionsLogCompanion.insert(
                id: id,
                batchId: batchId,
                type: type,
                accountId: accountId,
                messageId: messageId,
                messageIdHeader: messageIdHeader,
                fromFolderPath: fromFolderPath,
                toFolderPath: toFolderPath,
                originalUid: originalUid,
                newUid: newUid,
                status: status,
                label: label,
                error: error,
                createdAt: createdAt,
                undoneAt: undoneAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActionsLogTable, ActionLogRow>(table),
                  BaseReferences<_$AppDatabase, $ActionsLogTable, ActionLogRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActionsLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActionsLogTable,
      ActionLogRow,
      $$ActionsLogTableFilterComposer,
      $$ActionsLogTableOrderingComposer,
      $$ActionsLogTableAnnotationComposer,
      $$ActionsLogTableCreateCompanionBuilder,
      $$ActionsLogTableUpdateCompanionBuilder,
      (
        ActionLogRow,
        BaseReferences<_$AppDatabase, $ActionsLogTable, ActionLogRow>,
      ),
      ActionLogRow,
      PrefetchHooks Function()
    >;
typedef $$RulesTableCreateCompanionBuilder = RulesCompanion Function({
  Value<int> id,
  required String name,
  required String dslJson,
  Value<bool> enabled,
  Value<DateTime> createdAt,
});
typedef $$RulesTableUpdateCompanionBuilder = RulesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> dslJson,
  Value<bool> enabled,
  Value<DateTime> createdAt,
});

class $$RulesTableFilterComposer extends Composer<_$AppDatabase, $RulesTable> {
  $$RulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dslJson => $composableBuilder(
    column: $table.dslJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RulesTable> {
  $$RulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dslJson => $composableBuilder(
    column: $table.dslJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RulesTable> {
  $$RulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dslJson =>
      $composableBuilder(column: $table.dslJson, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RulesTable,
          RuleRow,
          $$RulesTableFilterComposer,
          $$RulesTableOrderingComposer,
          $$RulesTableAnnotationComposer,
          $$RulesTableCreateCompanionBuilder,
          $$RulesTableUpdateCompanionBuilder,
          (RuleRow, BaseReferences<_$AppDatabase, $RulesTable, RuleRow>),
          RuleRow,
          PrefetchHooks Function()
        > {
  $$RulesTableTableManager(_$AppDatabase db, $RulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dslJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RulesCompanion(
                id: id,
                name: name,
                dslJson: dslJson,
                enabled: enabled,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String dslJson,
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RulesCompanion.insert(
                id: id,
                name: name,
                dslJson: dslJson,
                enabled: enabled,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RulesTable, RuleRow>(table),
                  BaseReferences<_$AppDatabase, $RulesTable, RuleRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RulesTable,
      RuleRow,
      $$RulesTableFilterComposer,
      $$RulesTableOrderingComposer,
      $$RulesTableAnnotationComposer,
      $$RulesTableCreateCompanionBuilder,
      $$RulesTableUpdateCompanionBuilder,
      (RuleRow, BaseReferences<_$AppDatabase, $RulesTable, RuleRow>),
      RuleRow,
      PrefetchHooks Function()
    >;
typedef $$LabelsTrainingTableCreateCompanionBuilder =
    LabelsTrainingCompanion Function({
      Value<int> id,
      required int messageId,
      required String label,
      Value<DateTime> createdAt,
    });
typedef $$LabelsTrainingTableUpdateCompanionBuilder =
    LabelsTrainingCompanion Function({
      Value<int> id,
      Value<int> messageId,
      Value<String> label,
      Value<DateTime> createdAt,
    });

final class $$LabelsTrainingTableReferences
    extends
        BaseReferences<_$AppDatabase, $LabelsTrainingTable, TrainingLabelRow> {
  $$LabelsTrainingTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MessagesTable _messageIdTable(_$AppDatabase db) =>
      db.messages.createAlias('labels_training__message_id__messages__id');

  $$MessagesTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<int>('message_id')!;

    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LabelsTrainingTableFilterComposer
    extends Composer<_$AppDatabase, $LabelsTrainingTable> {
  $$LabelsTrainingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MessagesTableFilterComposer get messageId {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabelsTrainingTableOrderingComposer
    extends Composer<_$AppDatabase, $LabelsTrainingTable> {
  $$LabelsTrainingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MessagesTableOrderingComposer get messageId {
    final $$MessagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableOrderingComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabelsTrainingTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabelsTrainingTable> {
  $$LabelsTrainingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MessagesTableAnnotationComposer get messageId {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabelsTrainingTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabelsTrainingTable,
          TrainingLabelRow,
          $$LabelsTrainingTableFilterComposer,
          $$LabelsTrainingTableOrderingComposer,
          $$LabelsTrainingTableAnnotationComposer,
          $$LabelsTrainingTableCreateCompanionBuilder,
          $$LabelsTrainingTableUpdateCompanionBuilder,
          (TrainingLabelRow, $$LabelsTrainingTableReferences),
          TrainingLabelRow,
          PrefetchHooks Function({bool messageId})
        > {
  $$LabelsTrainingTableTableManager(
    _$AppDatabase db,
    $LabelsTrainingTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabelsTrainingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabelsTrainingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabelsTrainingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> messageId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LabelsTrainingCompanion(
                id: id,
                messageId: messageId,
                label: label,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int messageId,
                required String label,
                Value<DateTime> createdAt = const Value.absent(),
              }) => LabelsTrainingCompanion.insert(
                id: id,
                messageId: messageId,
                label: label,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LabelsTrainingTable, TrainingLabelRow>(table),
                  $$LabelsTrainingTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$LabelsTrainingTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$LabelsTrainingTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LabelsTrainingTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabelsTrainingTable,
      TrainingLabelRow,
      $$LabelsTrainingTableFilterComposer,
      $$LabelsTrainingTableOrderingComposer,
      $$LabelsTrainingTableAnnotationComposer,
      $$LabelsTrainingTableCreateCompanionBuilder,
      $$LabelsTrainingTableUpdateCompanionBuilder,
      (TrainingLabelRow, $$LabelsTrainingTableReferences),
      TrainingLabelRow,
      PrefetchHooks Function({bool messageId})
    >;
typedef $$SummariesCacheTableCreateCompanionBuilder =
    SummariesCacheCompanion Function({
      required String key,
      required String summaryJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SummariesCacheTableUpdateCompanionBuilder =
    SummariesCacheCompanion Function({
      Value<String> key,
      Value<String> summaryJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SummariesCacheTableFilterComposer
    extends Composer<_$AppDatabase, $SummariesCacheTable> {
  $$SummariesCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SummariesCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $SummariesCacheTable> {
  $$SummariesCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SummariesCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $SummariesCacheTable> {
  $$SummariesCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SummariesCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SummariesCacheTable,
          SummaryRow,
          $$SummariesCacheTableFilterComposer,
          $$SummariesCacheTableOrderingComposer,
          $$SummariesCacheTableAnnotationComposer,
          $$SummariesCacheTableCreateCompanionBuilder,
          $$SummariesCacheTableUpdateCompanionBuilder,
          (
            SummaryRow,
            BaseReferences<_$AppDatabase, $SummariesCacheTable, SummaryRow>,
          ),
          SummaryRow,
          PrefetchHooks Function()
        > {
  $$SummariesCacheTableTableManager(
    _$AppDatabase db,
    $SummariesCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SummariesCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SummariesCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SummariesCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SummariesCacheCompanion(
                key: key,
                summaryJson: summaryJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String summaryJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SummariesCacheCompanion.insert(
                key: key,
                summaryJson: summaryJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SummariesCacheTable, SummaryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SummariesCacheTable,
                    SummaryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SummariesCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SummariesCacheTable,
      SummaryRow,
      $$SummariesCacheTableFilterComposer,
      $$SummariesCacheTableOrderingComposer,
      $$SummariesCacheTableAnnotationComposer,
      $$SummariesCacheTableCreateCompanionBuilder,
      $$SummariesCacheTableUpdateCompanionBuilder,
      (
        SummaryRow,
        BaseReferences<_$AppDatabase, $SummariesCacheTable, SummaryRow>,
      ),
      SummaryRow,
      PrefetchHooks Function()
    >;
typedef $$AiTransparencyLogTableCreateCompanionBuilder =
    AiTransparencyLogCompanion Function({
      Value<int> id,
      required String purpose,
      required String destination,
      required int bytesSent,
      Value<DateTime> createdAt,
    });
typedef $$AiTransparencyLogTableUpdateCompanionBuilder =
    AiTransparencyLogCompanion Function({
      Value<int> id,
      Value<String> purpose,
      Value<String> destination,
      Value<int> bytesSent,
      Value<DateTime> createdAt,
    });

class $$AiTransparencyLogTableFilterComposer
    extends Composer<_$AppDatabase, $AiTransparencyLogTable> {
  $$AiTransparencyLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytesSent => $composableBuilder(
    column: $table.bytesSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiTransparencyLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AiTransparencyLogTable> {
  $$AiTransparencyLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytesSent => $composableBuilder(
    column: $table.bytesSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiTransparencyLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiTransparencyLogTable> {
  $$AiTransparencyLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bytesSent =>
      $composableBuilder(column: $table.bytesSent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AiTransparencyLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiTransparencyLogTable,
          TransparencyLogRow,
          $$AiTransparencyLogTableFilterComposer,
          $$AiTransparencyLogTableOrderingComposer,
          $$AiTransparencyLogTableAnnotationComposer,
          $$AiTransparencyLogTableCreateCompanionBuilder,
          $$AiTransparencyLogTableUpdateCompanionBuilder,
          (
            TransparencyLogRow,
            BaseReferences<
              _$AppDatabase,
              $AiTransparencyLogTable,
              TransparencyLogRow
            >,
          ),
          TransparencyLogRow,
          PrefetchHooks Function()
        > {
  $$AiTransparencyLogTableTableManager(
    _$AppDatabase db,
    $AiTransparencyLogTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiTransparencyLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiTransparencyLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiTransparencyLogTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<int> bytesSent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AiTransparencyLogCompanion(
                id: id,
                purpose: purpose,
                destination: destination,
                bytesSent: bytesSent,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String purpose,
                required String destination,
                required int bytesSent,
                Value<DateTime> createdAt = const Value.absent(),
              }) => AiTransparencyLogCompanion.insert(
                id: id,
                purpose: purpose,
                destination: destination,
                bytesSent: bytesSent,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiTransparencyLogTable, TransparencyLogRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AiTransparencyLogTable,
                    TransparencyLogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiTransparencyLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiTransparencyLogTable,
      TransparencyLogRow,
      $$AiTransparencyLogTableFilterComposer,
      $$AiTransparencyLogTableOrderingComposer,
      $$AiTransparencyLogTableAnnotationComposer,
      $$AiTransparencyLogTableCreateCompanionBuilder,
      $$AiTransparencyLogTableUpdateCompanionBuilder,
      (
        TransparencyLogRow,
        BaseReferences<
          _$AppDatabase,
          $AiTransparencyLogTable,
          TransparencyLogRow
        >,
      ),
      TransparencyLogRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$SendersTableTableManager get senders =>
      $$SendersTableTableManager(_db, _db.senders);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$MessageTagsTableTableManager get messageTags =>
      $$MessageTagsTableTableManager(_db, _db.messageTags);
  $$ActionsLogTableTableManager get actionsLog =>
      $$ActionsLogTableTableManager(_db, _db.actionsLog);
  $$RulesTableTableManager get rules =>
      $$RulesTableTableManager(_db, _db.rules);
  $$LabelsTrainingTableTableManager get labelsTraining =>
      $$LabelsTrainingTableTableManager(_db, _db.labelsTraining);
  $$SummariesCacheTableTableManager get summariesCache =>
      $$SummariesCacheTableTableManager(_db, _db.summariesCache);
  $$AiTransparencyLogTableTableManager get aiTransparencyLog =>
      $$AiTransparencyLogTableTableManager(_db, _db.aiTransparencyLog);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';
