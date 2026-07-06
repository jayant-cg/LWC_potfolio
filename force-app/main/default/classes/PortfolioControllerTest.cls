@isTest
private class PortfolioControllerTest {
    @TestSetup
    static void makeData() {
        insert new Account(
            Name = 'Jane Doe',
            Phone = '555-123-4567',
            Website = 'https://example.com',
            Description = 'Salesforce Developer building great things.',
            Professional_Title__c = 'Salesforce Developer',
            Email__c = 'jane.doe@example.com',
            Skills__c = 'Apex, LWC, JavaScript',
            LinkedIn_URL__c = 'https://linkedin.com/in/janedoe',
            GitHub_URL__c = 'https://github.com/janedoe',
            Photo_URL__c = 'https://example.com/photo.png',
            Is_Portfolio_Account__c = true
        );

        insert new Account(Name = 'Other Account', Is_Portfolio_Account__c = false);
    }

    @isTest
    static void testGetPortfolioAccount_returnsFlaggedRecord() {
        Test.startTest();
        Account result = PortfolioController.getPortfolioAccount();
        Test.stopTest();

        System.assertNotEquals(null, result, 'Expected a portfolio account to be returned.');
        System.assertEquals('Jane Doe', result.Name);
        System.assertEquals('Salesforce Developer', result.Professional_Title__c);
    }

    @isTest
    static void testGetPortfolioAccount_returnsNullWhenNoneFlagged() {
        delete [SELECT Id FROM Account WHERE Is_Portfolio_Account__c = TRUE];

        Test.startTest();
        Account result = PortfolioController.getPortfolioAccount();
        Test.stopTest();

        System.assertEquals(null, result, 'Expected null when no account is flagged as the portfolio account.');
    }
}
