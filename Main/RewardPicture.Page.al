page 50100 "Reward Picture"
{
    Caption = 'Reward Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Reward";

    layout
    {
        area(content)
        {
            field(Image; Rec."Reward Image")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the reward.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                begin
                    ImportFromDevice;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    DeleteItemPicture;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    local procedure ImportFromDevice();
    var
        PicInStream: InStream;
        FromFileName: Text;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
    begin
        if Rec."Reward Image".HasValue then
            if not Confirm(OverrideImageQst) then
                exit;
        if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, PicInStream) then begin
            Clear(Rec."Reward Image");
            Rec."Reward Image".ImportStream(PicInStream, FromFileName);
            Rec.Modify(true);
        end;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteEnabled := Rec."Reward Image".HasValue;
    end;

    procedure DeleteItemPicture()
    begin
        Rec.TestField("Reward ID");

        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Rec."Reward Image");
        Rec.Modify(true);
    end;

    var
        DeleteEnabled: Boolean;
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
}

