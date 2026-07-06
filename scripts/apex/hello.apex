// Upsert portfolio Account for Jayant Mohan Mishra
List<Account> existing = Database.query(
    'SELECT Id FROM Account WHERE Is_Portfolio_Account__c = TRUE LIMIT 1',
    AccessLevel.SYSTEM_MODE
);
Account acc = existing.isEmpty() ? new Account() : existing[0];
acc.Name = 'Jayant Mohan Mishra';
acc.Professional_Title__c = 'SDE Intern';
acc.Phone = '+91-9876543210';
acc.Is_Portfolio_Account__c = true;
Database.upsert(acc, AccessLevel.SYSTEM_MODE);
System.debug('Portfolio account upserted: ' + acc.Id);
