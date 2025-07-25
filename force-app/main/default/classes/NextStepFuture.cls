    /*
    * NextStepFuture Class Description:
    * 
    * Question 1: Create a future method that updates all account and opportunities next step to 'Meeting in the future'
    * Question 2: Create a method that inserts a big deal opportunity and updates the user role name to 'CRO'
    * 
    * Benefits of using future methods:
    * 
    * 1. Asynchronous Processing: Allows long-running operations to be handled in the background, freeing up resources.
    * 2. Governor Limit Management: Asynchronous methods have a separate set of limits, providing more flexibility.
    * 3. User Experience Enhancement: Improves responsiveness in user interfaces by offloading processes to the background.
    * 4. Mixed DML Operations Handling: Helps overcome Mixed DML errors by allowing updates on setup and non-setup objects.
    * 5. Enhanced Integration Capabilities: Useful for making callouts to external systems without blocking the user interaction.
    * 
    * For more detailed information, refer to the official Salesforce documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_invoking_future_methods.htm
    * 
    * Note: The class below contains placeholders for implementing a future method to update accounts and opportunities.
    *       The accompanying test class 'AsynchronousTest' should also be updated to test this method.
    */

    /* Code Notes from 1:1
    * Q1 - Queried twice, but can query once for Accounts and Opptys via a nested For Loop.
    * Final (String) Variables - Can declare as a Class Variable vs. a Method Variable.  Would be added on Line 27 to be referenced throughout the NextStepFuture Class.
    */

    public with sharing class NextStepFuture {

        /* 
        * Question 1
        * Update/Uncomment the template code to create a method
        * Create a future method that updates all account and opportunities next step to 'Meeting in the future'
        * Account Next Step field is a custom field
        * Opportunity Next Step field is a standard field
        * Update the corresponding test class AsynchronousTest and test method nextStepFuture_testUpdateAllNextStep to cover test this method
        */

        @future
        public static void updateAllNextSteps() {
            //  The body of the Method
            final String FUTURE_NEXT_STEP = 'Meeting in the future';

            // Query and update Accounts
            List<Account> accountsToUpdate = [
                SELECT Id, Next_Step__c
                FROM Account
            ];
            for (Account acc : accountsToUpdate) {
                acc.Next_Step__c = FUTURE_NEXT_STEP;
            }
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }

            // Query and update Opportunities
            List<Opportunity> oppsToUpdate = [
                SELECT Id, NextStep
                FROM Opportunity
            ];
            for (Opportunity opp : oppsToUpdate) {
                opp.NextStep = FUTURE_NEXT_STEP;
            }
            if (!oppsToUpdate.isEmpty()) {
                update oppsToUpdate;
            }
        }

        /*
        * Question 2
        * Update/Uncomment the template code to create a method
        * Create a method that inserts a big deal opportunity and updates the user role name to 'CRO'
        * Update the corresponding test class AsynchronousTest and test method nextStepFuture_testCreateDealAndUpdateRole to cover test this method
        */

        // Mix DML Error happens when you try to perform DML operations on setup and non-setup Objects in a single transaction.

        // Insert Big Deal and update UserRole
        public static void createDealAndUpdateRole() {
            insertBigDeal();
            updateUserRoleName();
        }

        // Helper Method to insert big deal
        private static void insertBigDeal() {
            Opportunity opp = new Opportunity();
            opp.Amount = 1000000;
            opp.Name = 'Big Deal';
            opp.StageName = 'Closed Won'; 
            opp.CloseDate = Date.today();
            insert opp;
        }

        // Helper Method to update role name
        @future // Added @future to ensure the code runs asynchronously, which resolves the mixed DML issue... 
        // This forces it into its own transaction.
        private static void updateUserRoleName(){
            List<UserRole> roles = [
                SELECT Id, Name
                FROM UserRole
                WHERE Id = :UserInfo.getUserRoleId() OR Name = 'CRO'
                LIMIT 1
            ];

            UserRole role;

            if (roles.isEmpty()) {
                role = new UserRole();
                role.portalType = 'None'; 
                role.CaseAccessForAccountOwner = 'Edit'; 
                role.OpportunityAccessForAccountOwner = 'Edit'; 
                // This may need to be uncommented depending on your orgs Organization Wide Defaults(OWD) settings. If you are receiving FIELD_INTEGRITY_EXCEPTION, field integrity exception: unknown (Opportunity access level below organization default): [unknown], uncomment this line.
            } else {
                role = roles[0];
            }
            role.Name = 'CRO';
            upsert role;
        }
    }