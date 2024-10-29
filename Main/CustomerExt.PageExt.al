pageextension 50107 "Customer Page Ext" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("Reward ID"; Rec."Reward ID")
            {
                ShowMandatory = true;
                ApplicationArea = All;
                Lookup = true;
                ToolTip = 'Specifies the level of reward that the customer has at this point.';
                LookupPageId = "Reward List";
            }
        }
    }
    actions
    {
        addfirst("&Customer")
        {
            action("Add Mock customers")
            {
                ApplicationArea = All;
                Caption = 'Add mock customers';
                Image = Add;
                Promoted = true;
                PromotedCategory = "Process";
                ToolTip = 'Assigns a reward level to the selected customer based on their number of orders.';

                trigger OnAction()
                begin
                    AddMockCustomers();
                    Message('Done!');
                end;
            }
        }
        addfirst("&Customer")
        {
            action("Set Rewards Level")
            {
                ApplicationArea = All;
                Caption = 'Assign Reward Level';
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = "Process";
                ToolTip = 'Assigns a reward level to the selected customer based on their number of orders.';

                trigger OnAction()
                var
                    AssignRewardLevelCodeunit: Codeunit AssignRewardLevel;
                begin
                    AssignRewardLevelCodeunit.AssignRewardLevelToCustomers();
                    Message('Done!');
                end;
            }
        }
    }

    procedure AddMockCustomers()
    var
        Customer: Record Customer;
        i: Integer;
        RandomNumber: Decimal;
    begin
        for i := 1 to 10000 do begin
            Customer.Init();
            if not Customer.Get('C' + Format(i, 0)) then begin
                Customer."No." := 'C' + Format(i, 0); // Generate customer number like C0001, C0002, etc.
                Customer.Name := 'Mock Customer ' + Format(i, 0);
                Customer.Address := '123 Mock Street';
                Customer.City := 'Mock City';
                Customer."Phone No." := '123-456-7890';

                // Generate a random number for "Inv. Amounts (LCY)"
                RandomNumber := Random(100000) + Random(100) / 100; // Random number between 0 and 99999.99
                Customer."Inv. Amounts (LCY)" := RandomNumber;

                Customer.Insert();
            end;
        end;
    end;
}