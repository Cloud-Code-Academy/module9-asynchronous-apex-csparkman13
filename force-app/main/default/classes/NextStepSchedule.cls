/*
 * NextStepSchedule Class Description:
 * 
 * The NextStepSchedule Class is tailored to schedule the execution of the NextStepBatch Class in Salesforce.
 * By implementing the Schedulable interface, it allows Administrators or Developers to define specific intervals at which the Batch Job should run, automating the process of updating the Next Step Field for Account and Opportunity Objects.
 * Helpful Link: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
 * 
 * Benefits of using Scheduled Apex:
 * 
 * 1. Automated Execution: Scheduled Apex allows for automatic execution of Classes at specified intervals, eliminating the need for manual Triggers.
 * 2. CRON Expressions: Provides the ability to define complex schedules using CRON expressions, catering to almost any scheduling requirement.
 * 3. Resource Management: Running tasks during off-peak hours can help in balancing the load on Salesforce servers, ensuring smoother operations during business hours.
 * 4. Recurring Jobs: Suitable for tasks that need to occur daily, weekly, monthly, or based on any other consistent interval.
 * 5. Chain Jobs: After one Scheduled Job finishes, it can be set to trigger another Job, allowing for chaining of operations.
 * 6. Monitoring & Control: Administrators can monitor, pause, or stop Scheduled Jobs via the Salesforce interface.
 * 
 * For a deeper understanding and best practices, refer to the official Salesforce documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
 * Trailhead Module: https://trailhead.salesforce.com/content/learn/modules/asynchronous_apex/async_apex_scheduled
 * 
 * Note: To make full use of this Class, ensure that the NextStepBatch Class is implemented and operational.
 */

public with sharing class NextStepSchedule {

    /*
     * Update/Uncomment the template code to create a method
     * Execute the batch job NextStepBatch using the Database.executeBatch method
     * Configure and schedule the job using the Apex Scheduler in Salesforce Setup
     * Code to execute the batch job should not need to change other than uncommenting the code
     */

    public void execute (SchedulableContext sc) {
        NextStepBatch batch = new NextStepBatch(); 
        Database.executeBatch(batch);
    }
}