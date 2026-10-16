import 'package:ai_smart_mail/core/database/app_database.dart';
import 'package:ai_smart_mail/core/domain/enums.dart';
import 'package:ai_smart_mail/features/onboarding/presentation/providers/add_account_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('createDemoAccounts seeds exactly the 3 demo accounts, idempotently', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container
        .read(addAccountControllerProvider.notifier)
        .createDemoAccounts();

    final accounts = await db.select(db.accounts).get();
    expect(accounts, hasLength(3));
    expect(
      accounts.map((a) => a.authKind).toSet(),
      {AuthKind.none},
    );
    expect(
      accounts.map((a) => a.provider).toSet(),
      {MailProviderType.gmail, MailProviderType.outlook, MailProviderType.icloud},
    );

    // Calling it again must not create duplicates.
    await container
        .read(addAccountControllerProvider.notifier)
        .createDemoAccounts();
    final accountsAfterSecondCall = await db.select(db.accounts).get();
    expect(accountsAfterSecondCall, hasLength(3));

    final state = container.read(addAccountControllerProvider);
    expect(state.createdAccountIds, hasLength(3));
    expect(state.isConnecting, isFalse);
  });

  test('defaultHostFor returns the right IMAP host per provider', () {
    expect(defaultHostFor(AddAccountOption.gmail), 'imap.gmail.com');
    expect(defaultHostFor(AddAccountOption.outlook), 'outlook.office365.com');
    expect(defaultHostFor(AddAccountOption.icloud), 'imap.mail.me.com');
    expect(defaultHostFor(AddAccountOption.imap), '');
  });
}
