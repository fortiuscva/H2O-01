page 50121 "Select Res. Attribute Value"
{
    Caption = 'Select Resource Attribute Value';
    DataCaptionExpression = '';
    PageType = StandardDialog;
    SourceTable = "Resource Attribute Value";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(Value; rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the option.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Clear(DummySelectedResAttributeValue);
        CurrPage.SetSelectionFilter(DummySelectedResAttributeValue);
    end;

    var
        DummySelectedResAttributeValue: Record "Resource Attribute Value";

    procedure GetSelectedValue(var ResAttributeValue: Record "Resource Attribute Value")
    begin
        ResAttributeValue.Copy(DummySelectedResAttributeValue);
    end;
}

