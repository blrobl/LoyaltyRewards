page 50101 "Reward Card"
{
    PageType = Card;
    UsageCategory = Tasks;
    SourceTable = Reward;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Reward)
            {
                field("Reward Id"; Rec."Reward ID")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of the reward.';
                }

                field(Description; Rec.Description)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the reward.';
                }

                field("Discount Percentage"; Rec."Discount Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount that will be applied for the reward.';
                }

                field("Minimum Purchase"; Rec."Minimum Purchase")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum purchase needed to apply the reward.';
                }

                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last modified date of the reward.';
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

            part(Workflow; "Word Templates Related FactBox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
            }
        }
    }
}