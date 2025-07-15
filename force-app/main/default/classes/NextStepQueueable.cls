/*
 * NextStepQueueable Class Description:
 * 
 * Implement the Queueable interface to process records asynchronously.
 * This example processes up to 10 accounts at a time.
 * It removes the Next Step from the accounts and related opportunities.
 *  
 * Benefits of using Queueable methods:
 * 
 * 1. Chaining Jobs: Allows for the chaining of jobs, meaning you can add another job to the queue from a running job.
 * 2. Stateful Execution: Supports stateful execution, which allows member variables to retain their values between job invocations.
 * 3. High Concurrency: Processes large sets of data without hitting governor limits.
 * 4. Flexibility: Useful for operations that need more flexibility in execution, especially when there's a possibility of chaining or performing related async operations.
 * 5. Enhanced Integration Capabilities: Useful for making asynchronous callouts to external systems, allowing for more extended processing times.
 * 
 * For more detailed information, refer to the official Salesforce documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_queueing_jobs.htm
 * 
 * Note: The class below contains placeholders for implementing a queueable job to update accounts and opportunities.
 */

public with sharing class NextStepQueueable implements Queueable {

    // Member Variable to store the Accounts that get passed into the Job
    private Map<Id, Account> accounts;

    // Constructor to accept the Accounts and stores them for use in execute()
    public NextStepQueueable(Map<Id, Account> accounts) {
        // Store the Accounts in a Member Variable
        this.accounts = accounts;
    }

    // Method to Queue the Job
    public static void enqueueJob() {
        // Get 10 Accounts with Next Step populated
        List<Account> accountList = [
            SELECT Id, Next_Step__c
            FROM Account
            WHERE Next_Step__c != null
            LIMIT 10
        ];

        // If there are any Accounts, Queue the Job using System.enqueueJob
        if (!accountList.isEmpty()) {
            Map<Id, Account> accountMap = new Map<Id, Account>(accountList); // Convert List to Map<Id, Account>
            System.enqueueJob(new NextStepQueueable(accountMap)); // Queue the job with those accounts
        }
    }

    /*
     * Update/Uncomment the template code to create a Method
     * Method to execute the Queueable Job
     */

    public void execute(QueueableContext context) {
        // Get the Accounts from the Member Variable
        if (accounts == null || accounts.isEmpty()) return;

        // Remove the Next Step using the Helper Method
        for (Account acc : accounts.values()) {
            removeNextStep(acc);
        }

        // Update the Accounts
        update accounts.values();

        // Get the Opportunities Related to the Accounts
        Set<Id> accountIds = accounts.keySet();

        List<Opportunity> oppList = [
            SELECT Id, NextStep, AccountId
            FROM Opportunity
            WHERE AccountId IN :accountIds
        ];

        // Remove the Next Step using the Helper Method
        for (Opportunity opp : oppList) {
            removeNextStep(opp);
        }

        // Update the Opportunities
        update oppList;

        // Call the enqueueJob Method to Queue another Job to process more Records.
        enqueueJob();
    }

    // Helper Method to remove the Next Step
    // Overloaded Method to accept an Opportunity
    private static void removeNextStep(Opportunity opp) {
        opp.NextStep = null;
    }

    // Helper Method to remove the Next Step
    // Overloaded Method to accept an Account
    private static void removeNextStep(Account acc) {
        acc.Next_Step__c = null;
    }
}