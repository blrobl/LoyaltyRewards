table 50100 Reward
{
    fields
    {
        field(1; "Reward ID"; Code[30])
        {
        }

        field(2; Description; Text[2048])
        {
            NotBlank = true;
        }

        field(3; "Discount Percentage"; Decimal)
        {
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 2;
        }

        field(4; "Reward Image"; Media)
        {
        }

        field(5; "Minimum Purchase"; Decimal)
        {
            MinValue = 0;
            DecimalPlaces = 2;
        }

        field(6; "Last Modified Date"; Date)
        {

            Editable = false;
        }

    }

    keys
    {
        key(PK; "Reward ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // The Brick field group specifies which fields of the table will display in a Teams card.
        fieldgroup(Brick; "Reward Id", Description, "Discount Percentage", "Minimum Purchase", "Reward Image")
        {
        }
    }

    trigger OnInsert();
    begin
        SetLastModifiedDate();
    end;


    trigger OnModify();
    begin
        SetLastModifiedDate();
    end;

    trigger OnRename();
    begin
        SetLastModifiedDate();
    end;

    local procedure SetLastModifiedDate();
    begin
        Rec."Last Modified Date" := Today();
    end;
}