page 50102 "Reward List"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Reward;
    CardPageId = "Reward Card";
    Caption = 'Rewards';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Rewards)
            {
                field("Reward ID"; Rec."Reward ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of the reward that the customer has at this point.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the reward that the customer has at this point.';
                }

                field("Discount Percentage"; Rec."Discount Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of the reward that the customer has at this point.';
                }
            }
        }
        area(factboxes)
        {
            part(RewardPicture; "Reward Picture")
            {
                ApplicationArea = All;
                Caption = 'Reward Picture';
                SubPageLink = "Reward ID" = FIELD("Reward ID");
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::Reward),
                              "No." = FIELD("Reward ID");
            }
        }
    }
}
