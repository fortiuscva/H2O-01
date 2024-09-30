page 50111 "Meter Prices"
{
    ApplicationArea = All;
    Caption = 'Meter Prices';
    PageType = List;
    SourceTable = "Meter Price";
    AccessByPermission = TableData Resource = R;
    DataCaptionFields = "No.";
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    Caption = 'Meter Price Type';
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Sales Type"; rec."Sales Type")
                {
                    ToolTip = 'Specifies the value of the Sales Type field.';
                    ApplicationArea = All;
                }
                field("Sales Code"; rec."Sales Code")
                {
                    ToolTip = 'Specifies the value of the Sales Code field.';
                    ApplicationArea = All;
                }
                field("Meter Activity Code"; Rec."Meter Activity Code")
                {
                    ToolTip = 'Specifies the value of the Meter Activity Code field.';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
