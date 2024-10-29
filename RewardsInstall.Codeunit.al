codeunit 50105 RewardsInstall
{
    // Set the codeunit to be an install codeunit. 
    Subtype = Install;

    // This trigger includes code for company-related operations. 
    trigger OnInstallAppPerCompany();
    var
        Reward: Record Reward;
    begin
        // If the "Reward" table is empty, insert the default rewards.
        if Reward.IsEmpty() then begin
            InsertDefaultRewards();
        end;
    end;

    // Insert the GOLD, SILVER, BRONZE reward levels
    procedure InsertDefaultRewards();
    begin
        InsertRewardLevel('GOLD', 'Gold Level', 20, 2000);
        InsertRewardLevel('SILVER', 'Silver Level', 10, 1000);
        InsertRewardLevel('BRONZE', 'Bronze Level', 5, 500);
    end;

    // Create and insert a reward level in the "Reward" table.
    procedure InsertRewardLevel(ID: Code[30]; Description: Text[2048]; Discount: Decimal; MinimumPruchase: Decimal);
    var
        Reward: Record Reward;
    begin
        Reward.Init();
        Reward."Reward ID" := ID;
        Reward.Description := Description;
        Reward."Discount Percentage" := Discount;
        Reward."Minimum Purchase" := MinimumPruchase;
        Reward.Insert();
    end;

    /*procedure AssignRewardLevelToCustomer(CustomerNo: Code[20]; RewardLevel: Code[30]);
    var
        Customer: Record Customer;
        Reward: Record Reward;
    begin
        // Find the customer record
        if Customer.Get(CustomerNo) then begin
            // Lock the customer table for modification
            Customer.LockTable();

            // Find the reward level record
            if Reward.Get(RewardLevel) then begin
                // Assign the reward level to the customer based on their number of orders
                if Customer."No. of Orders" >= Reward."Minimum Purchase" then begin
                    Customer."Reward ID" := Reward."Reward ID";
                    Customer.Modify();
                end;
            end;
        end;
    end;


    procedure AssignRewardLevelToCustomers();
    var
        Customer: Record Customer;
        Reward: Record Reward;
    begin
        // Lock the customer table for modification before any checks
        Customer.LockTable();

        // Loop through all customers
        if Customer.FindSet() then begin
            repeat
                // Find the reward level record
                if Reward.Get(Customer."Reward ID") then begin
                    // Assign the reward level to the customer based on their number of orders
                    if Customer."No. of Orders" >= Reward."Minimum Purchase" then begin
                        Customer."Reward ID" := Reward."Reward ID";
                        Customer.Modify();
                    end;
                end;
            until Customer.Next() = 0;
        end;
    end;

    /*procedure AssignRewardLevelToCustomersEfficient();
    var
        Customer: Record Customer;
        Reward: Record Reward;
    begin
        // Loop through all customers
        if Customer.FindSet() then begin
            repeat
                // Find the reward level record
                if Reward.Get(Customer."Reward Level") then begin
                    // Check if the customer meets the minimum purchase requirement
                    if Customer."No. of Orders" >= Reward."Minimum Purchase" then begin
                        // Lock the customer table for modification
                        Customer.LockTable();

                        // Assign the reward level to the customer
                        Customer."Reward Level" := Reward."Reward ID";
                        Customer.Modify();
                    end;
                end;
            until Customer.Next() = 0;
        end;
    end;*/

}