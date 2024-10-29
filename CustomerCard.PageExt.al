pageextension 50104 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Reward ID"; Rec."Reward ID")
            {
                ApplicationArea = All;
                Lookup = true;
                ToolTip = 'Specifies the level of reward that the customer has at this point.';
                LookupPageId = "Reward List";
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    If Rec."Reward ID" = 'GOLD' then
                        OnCustomerReachedGoldLevel(Rec);
                end;
            }
        }
    }

    actions
    {
        addfirst(Navigation)
        {
            action("Rewards")
            {
                ApplicationArea = All;
                RunObject = page "Reward List";
            }
        }
    }

    [IntegrationEvent(false, false)]
    local procedure OnCustomerReachedGoldLevel(Customer: Record Customer)
    begin
    end;


}

