page 50123 "Res. Attribute Value Editor"
{
    Caption = 'Resource Attribute Values';
    PageType = StandardDialog;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            part(ResAttributeValueList; "Res. Attribute Value List")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.ResAttributeValueList.PAGE.LoadAttributes(rec."No.");
    end;
}