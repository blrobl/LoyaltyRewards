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

        // Update the Reward table with external rewards. Doesn't use the Customer
        ImportExternalRewards();

        // Loop through all customers
        if Customer.FindSet() then begin
            repeat
                ProcessCustomer();
                // Assign the reward level to the customer based on their number of orders
                LatestRewardLevel := GetCustomerRewardLevel(Customer);

                // Lock and modify the customer record only when necessary
                Customer.LockTable();
                Customer.Get(Customer."No.");
                Customer."Reward ID" := LatestRewardLevel;
                Customer.Modify();
            until Customer.Next() = 0;
        end;
    end;

    procedure GetCustomerRewardLevel(Customer: Record Customer): Code[30];
    var
        Reward: Record Reward;
        LatestRewardLevel: Code[30];
    begin
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

        exit(LatestRewardLevel);
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

    procedure ProcessCustomer()
    begin
        Sleep(10);
    end;

    procedure ImportExternalRewards()
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        JsonResponse: Text;
        JsonArray: JsonArray;
        JsonObject: JsonToken;
        RewardCode: Code[20];
        RewardDescription: Text[100];
        ApiEndpoint: Text;
        RewardRecord: Record "Reward";
        Execute: Boolean;
    begin

        ApiEndpoint := 'https://api.example.com/rewards';
        Sleep(1000);

        if Execute then begin
            // Make the API call
            HttpClient.Get(ApiEndpoint, HttpResponseMessage);
            if not HttpResponseMessage.IsSuccessStatusCode() then
                Error('Failed to retrieve rewards from external API.');

            // Read the response content
            HttpResponseMessage.Content().ReadAs(JsonResponse);

            // Parse the JSON response
            if not JsonArray.ReadFrom(JsonResponse) then
                Error('Failed to parse JSON response.');

            // Process each reward in the JSON array
            foreach JsonObject in JsonArray do begin
                Sleep(100);
            end;
        end;
    end;

    var
        DisAllowedDays: List of [Integer];

}