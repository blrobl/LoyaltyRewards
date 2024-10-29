codeunit 50100 AssignRewardLevel
{
    trigger OnRun()
    var
    // declare your variables
    begin
        DisAllowedDays.Add(7);
        AssignRewardLevelToCustomers();
    end;

    procedure AssignRewardLevelToCustomers();
    var
        Customer: Record Customer;
        Reward: Record Reward;
        LatestRewardLevel: Code[30];
        Date: Date;
    begin
        // Reschedule the job if not allowed to run this day
        Date := Today();
        if DisAllowedDays.Contains(Date.DayOfWeek()) then
            ReSchedueleJob(Date);

        // Lock the customer table for modification before any checks
        Customer.LockTable();

        // Loop through all customers
        if Customer.FindSet() then begin
            repeat
                DoSomeProcessing();
                // Loop through all reward records ordered by minimum purchase
                if Reward.FindSet(true) then begin
                    Reward.SetCurrentKey("Minimum Purchase");
                    LatestRewardLevel := Reward."Reward ID";
                    repeat
                        // Compare the minimum purchase with the customer's number of orders
                        if Customer."Inv. Amounts (LCY)" <= Reward."Minimum Purchase" then
                            // Return the latest reward level
                            break;
                        // Update the latest reward level
                        LatestRewardLevel := Reward."Reward ID";
                    until Reward.Next() = 0;
                end;
                // Return the latest reward level if no match found
                Customer."Reward ID" := LatestRewardLevel;
                Customer.Modify();
            until Customer.Next() = 0;
        end;
    end;

    procedure ReSchedueleJob(Date: Date);
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::AssignRewardLevel;
        JobQueueEntry.Description := 'Assign Reward Level to Customers';
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry.Insert(true);
    end;

    procedure DoSomeProcessing()
    begin
        Sleep(100);
    end;

    var
        DisAllowedDays: List of [Integer];

}