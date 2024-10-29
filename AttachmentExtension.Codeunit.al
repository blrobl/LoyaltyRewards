codeunit 50123 "Attachment Extension"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        Reward: Record Reward;
    begin
        if DocumentAttachment."Table ID" <> Database::"Reward" then
            exit;

        RecRef.Open(Database::Reward);
        if Reward.Get(DocumentAttachment."No.") then
            RecRef.GetTable(Reward);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', true, true)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        if RecRef.Number <> Database::"Reward" then
            exit;

        FieldRef := RecRef.Field(1);
        RecNo := FieldRef.Value;
        DocumentAttachment.SetRange("No.", RecNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', true, true)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        if RecRef.Number <> Database::"Reward" then
            exit;

        FieldRef := RecRef.Field(1);
        RecNo := FieldRef.Value;
        DocumentAttachment.Validate("No.", RecNo);
    end;
}