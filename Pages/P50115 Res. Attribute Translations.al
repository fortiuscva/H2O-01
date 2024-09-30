page 50115 "Res. Attribute Translations"
{
    Caption = 'Resource Attribute Translations';
    DataCaptionFields = "Attribute ID";
    PageType = List;
    SourceTable = "Resource Attribute Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = Languages;
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as a resource description on an order confirmation.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the translated name of the resource attribute.';
                }
            }
        }
    }

    actions
    {
    }
}

