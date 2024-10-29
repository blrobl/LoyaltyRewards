codeunit 50107 "Rewards Events"
{

    [ExternalBusinessEvent('OnCustomerGetsGoldRewardLevel', 'Customer gets Gold Reward Level', 'Event is raised when a given customer reaches Gold Reward Level', Enum::EventCategory::Rewards, '1.0')]
    local procedure OnCustomerGetsGoldRewardLevel(CustomerId: Guid; CustomerNo: Code[20]; CustomerName: Text[250]; CustomerEmail: Text[250])
    begin
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnCustomerReachedGoldLevel', '', false, false)]
    local procedure OnCustomerReachedGoldLevel(Customer: Record Customer)
    begin
        OnCustomerGetsGoldRewardLevel(Customer.SystemId, Customer."No.", Customer.Name, Customer."E-Mail");
    end;
}