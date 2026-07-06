/**
 * Controller for the `portfolio` LWC.
 * Retrieves the single Account record flagged as the portfolio record.
 */
public with sharing class PortfolioController {
    @AuraEnabled(cacheable=true)
    public static Account getPortfolioAccount() {
        List<Account> accounts = [
            SELECT Id, Name, Phone, Website, Description, Professional_Title__c,
                   Email__c, Skills__c, LinkedIn_URL__c, GitHub_URL__c, Photo_URL__c
            FROM Account
            WHERE Is_Portfolio_Account__c = TRUE
            WITH USER_MODE
            LIMIT 1
        ];
        return accounts.isEmpty() ? null : accounts[0];
    }

    @AuraEnabled
    public static Account upsertPortfolioAccount(
        String name,
        String professionalTitle,
        String description,
        String skills,
        String email,
        String phone,
        String website,
        String linkedInUrl,
        String gitHubUrl,
        String photoUrl
    ) {
        List<Account> existing = [
            SELECT Id FROM Account
            WHERE Is_Portfolio_Account__c = TRUE
            WITH USER_MODE
            LIMIT 1
        ];

        Account acc = existing.isEmpty() ? new Account() : existing[0];
        acc.Name                    = name;
        acc.Professional_Title__c   = professionalTitle;
        acc.Description             = description;
        acc.Skills__c               = skills;
        acc.Email__c                = email;
        acc.Phone                   = phone;
        acc.Website                 = website;
        acc.LinkedIn_URL__c         = linkedInUrl;
        acc.GitHub_URL__c           = gitHubUrl;
        acc.Photo_URL__c            = photoUrl;
        acc.Is_Portfolio_Account__c = true;

        upsert as user acc;
        return acc;
    }
}
