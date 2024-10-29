page 50104 Rewards
{
    PageType = API;
    APIGroup = 'Demo';
    APIPublisher = 'BCTechDays';
    APIVersion = 'v1.0';
    EntityCaption = 'Reward';
    EntitySetCaption = 'Rewards';
    EntityName = 'reward';
    EntitySetName = 'rewards';
    SourceTable = Reward;
    Extensible = false;
    ApplicationArea = All;
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(rewardId; Rec."Reward ID")
                {
                    Caption = 'Reward ID';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    ShowMandatory = true;
                }
                field(minimumPurchase; Rec."Minimum Purchase")
                {
                    Caption = 'Minimum Purchase';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Minimum Purchase"));
                    end;
                }
                field(discountPercentage; Rec."Discount Percentage")
                {
                    Caption = 'Discount Percentage';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Discount Percentage"));
                    end;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Reward: Record Reward;
        RewardRecordRef: RecordRef;
    begin
        Reward.SetRange("Reward ID", Rec."Reward ID");
        if not Reward.IsEmpty() then
            Rec.Insert();

        Rec.Insert(true);

        RewardRecordRef.GetTable(Rec);
        GraphMgtGeneralTools.ProcessNewRecordFromAPI(RewardRecordRef, TempFieldSet, CurrentDateTime());
        RewardRecordRef.SetTable(Rec);

        Rec.Modify(true);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Reward: Record Reward;
    begin
        Reward.GetBySystemId(Rec.SystemId);

        if Rec."Reward ID" = Reward."Reward ID" then
            Rec.Modify(true)
        else begin
            Reward.TransferFields(Rec, false);
            Reward.Rename(Rec."Reward ID");
            Rec.TransferFields(Reward);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(Rec.SystemId);
        TempFieldSet.DeleteAll();
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(Database::Customer, FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::Customer;
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;

    var
        TempFieldSet: Record 2000000041 temporary;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
}

