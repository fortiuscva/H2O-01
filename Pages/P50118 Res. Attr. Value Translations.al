page 50118 "Res. Attr. Value Translations"
{
    Caption = 'Resource Attribute Value Translations';
    DataCaptionExpression = DynamicCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Res. Attr. Value Translation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = Languages;
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as a resource description on an order confirmation.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the translated name of the resource attribute value.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateWindowCaption();
    end;

    var
        DynamicCaption: Text;

    local procedure UpdateWindowCaption()
    var
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        if ResAttributeValue.Get(rec."Attribute ID", rec.ID) then
            DynamicCaption := ResAttributeValue.Value
        else
            DynamicCaption := '';
    end;
}

