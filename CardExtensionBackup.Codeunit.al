// codeunit 50124 "Card Extension Backup"
// {
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Summary Provider", 'OnAfterGetSummaryFields', '', false, false)]
//     local procedure OnAfterGetSummaryFields(PageId: Integer; RecId: RecordId; var FieldList: List of [Integer])
//     var
//         Customer: Record Customer;
//     begin
//         if PageId <> Page::"Customer Card" then
//             exit;

//         // Remove Balance  details 
//         if (FieldList.Contains(Customer.FieldNo("Balance Due (LCY)"))) then
//             FieldList.Remove(Customer.FieldNo("Balance Due (LCY)"));

//         if (FieldList.Contains(Customer.FieldNo("Balance (LCY)"))) then
//             FieldList.Remove(Customer.FieldNo("Balance (LCY)"));

//         // Add RewardID
//         FieldList.Add((Customer.FieldNo("Reward ID")));

//         // Add City, Phone number and Email
//         FieldList.Add(Customer.FieldNo("City"));
//         FieldList.Add(Customer.FieldNo("Mobile Phone No."));
//         FieldList.Add(Customer.FieldNo("E-Mail"));

//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Summary Provider", 'OnBeforeGetPageSummary', '', false, false)]
//     local procedure OnBeforeGetPageSummary(PageId: Integer; RecId: RecordId; FieldsJsonArray: JsonArray; var Handled: Boolean)
//     var
//         Customer: Record Customer;
//     begin
//         if PageId <> Page::"Customer Card" then
//             exit;

//         if not Customer.Get(RecId) then
//             exit;

//         AddField(FieldsJsonArray, 'Name', Customer.Name, 'Text');
//         AddField(FieldsJsonArray, 'Phone No.', Customer."Phone No.", 'Text');
//         If Customer."Reward ID" = 'Gold' then
//             AddField(FieldsJsonArray, 'Priority', 'Very High', 'Text');
//         AddField(FieldsJsonArray, 'Address', Customer.Address, 'Text');

//         Handled := true;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Summary Provider", 'OnAfterGetPageSummary', '', false, false)]
//     local procedure OnAfterGetPageSummary(PageId: Integer; RecId: RecordId; var FieldsJsonArray: JsonArray)
//     var
//         FieldJsonToken: JsonToken;
//         CaptionToken: JsonToken;
//         ValueToken: JsonToken;
//         RewardID: Code[50];
//         fieldNo: Integer;
//     begin
//         if PageId <> Page::"Customer Card" then
//             exit;

//         // find Reward Id and change it to corresponding discount percentage
//         for fieldNo := 0 to FieldsJsonArray.Count() - 1 do begin
//             FieldsJsonArray.Get(fieldNo, FieldJsonToken);
//             FieldJsonToken.AsObject().Get('caption', CaptionToken);
//             if CaptionToken.AsValue().AsText() = 'Reward ID' then begin
//                 FieldJsonToken.AsObject().Get('fieldValue', ValueToken);
//                 RewardID := ValueToken.AsValue().AsText();
//                 AddDiscountPercentage(FieldJsonToken, RewardID);
//                 exit;
//             end;
//         end;
//     end;

//     local procedure AddDiscountPercentage(var FieldJsonToken: JsonToken; RewardID: Code[30])
//     var
//         Reward: Record Reward;
//     begin
//         if not Reward.Get(RewardID) then
//             exit;

//         FieldJsonToken.AsObject().Replace('caption', 'Loyalty Discount %');
//         FieldJsonToken.AsObject().Replace('fieldValue', Reward."Discount Percentage");
//     end;

//     local procedure AddField(var FieldsJsonArray: JsonArray; Caption: Text; FieldValue: Text; FieldType: Text)
//     var
//         FieldsJsonObject: JsonObject;
//     begin
//         FieldsJsonObject.Add('caption', Caption);
//         FieldsJsonObject.Add('fieldValue', FieldValue);
//         FieldsJsonObject.Add('fieldType', FieldType);
//         FieldsJsonArray.Add(FieldsJsonObject);
//     end;
// }