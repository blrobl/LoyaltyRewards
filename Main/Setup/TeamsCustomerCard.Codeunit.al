codeunit 50122 "Teams Customer Card"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Summary Provider", 'OnAfterGetSummaryFields', '', false, false)]
    local procedure OnAfterGetSummaryFields(PageId: Integer; RecId: RecordId; var FieldList: List of [Integer])
    var
        Customer: Record Customer;
    begin
        if PageId <> Page::"Customer Card" then
            exit;

        // Remove Contact details 
        if (FieldList.Contains(Customer.FieldNo(Contact))) then
            FieldList.Remove(Customer.FieldNo(Contact));

        // Remove Balance  details 
        if (FieldList.Contains(Customer.FieldNo("Balance Due (LCY)"))) then
            FieldList.Remove(Customer.FieldNo("Balance Due (LCY)"));
        if (FieldList.Contains(Customer.FieldNo("Balance (LCY)"))) then
            FieldList.Remove(Customer.FieldNo("Balance (LCY)"));

        // Add RewardID
        FieldList.Add((Customer.FieldNo("Reward ID")));

        // Add Contact, City and Email
        FieldList.Add(Customer.FieldNo(Contact));
        FieldList.Add(Customer.FieldNo("City"));
        FieldList.Add(Customer.FieldNo("E-Mail"));

    end;


    local procedure AddField(var FieldsJsonArray: JsonArray; Caption: Text; FieldValue: Text; FieldType: Text)
    var
        FieldsJsonObject: JsonObject;
    begin
        FieldsJsonObject.Add('caption', Caption);
        FieldsJsonObject.Add('fieldValue', FieldValue);
        FieldsJsonObject.Add('fieldType', FieldType);
        FieldsJsonArray.Add(FieldsJsonObject);
    end;
}