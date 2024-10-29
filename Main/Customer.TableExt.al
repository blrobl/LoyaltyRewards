tableextension 50103 "Customer Ext" extends Customer
{
    fields
    {
        field(50100; "Reward ID"; Code[30])
        {
            TableRelation = Reward."Reward ID";
            ToolTip = 'Specifies the level of reward that the customer has at this point.';

            trigger OnValidate();
            var
                Cust: Record Customer;
            begin// 
                // If the "Reward ID" changed and the new record is blocked, an error is thrown. 
                if (Rec."Reward ID" <> xRec."Reward ID") then begin
                    if (Rec.Blocked <> Blocked::" ") then
                        Error('Cannot update the rewards status of a blocked customer.');

                    Cust.LockTable();
                    if Cust.FindSet() then begin
                        repeat
                            if (Cust."Reward ID" = Rec."Reward ID") then
                                Error('The reward level is already assigned to another customer.');
                        until Cust.Next() = 0;
                    end;
                end;
            end;
        }
    }

    fieldgroups
    {
        // The Brick field group specifies which fields of the table will display in a Teams card.
        // Except media data type fields, the order of fields on the teams card is determined by the field order in the Brick field group
        // addlast(Brick; "Reward ID")
        // {
        // }
    }
}