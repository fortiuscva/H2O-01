page 50135 "Resource Customer Prices"
{
    ApplicationArea = All;
    Caption = 'Resource Customer Prices';
    PageType = List;
    SourceTable = "Resource Customer Price";
    UsageCategory = Administration;
    AccessByPermission = TableData Resource = R;
    DataCaptionFields = "No.";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; rec.type)
                {
                    Caption = 'Resource Type';
                    ToolTip = 'Specifies the value of the Resource Type field.';
                    ApplicationArea = All;
                }
                field("No."; rec."No.")
                {
                    Caption = 'No.';
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Resource Name"; rec."Resource Name")
                {
                    Caption = 'Resource Name';
                    ToolTip = 'Specifies the name of the No. field, either a resource name or a resource group name.';
                    ApplicationArea = All;
                }
                field("Sales Type"; rec."Sales Type")
                {
                    Caption = 'Sales Type';
                    ToolTip = 'Specifies the value of the Sales Type field.';
                    ApplicationArea = All;
                }
                field("Sales Code"; rec."Sales Code")
                {
                    Caption = 'Sales Code';
                    ToolTip = 'Specifies the value of the Sales Code field.';
                    ApplicationArea = All;
                }
                field("Sales Name"; rec."Sales Name")
                {
                    Caption = 'Sales Name';
                    ToolTip = 'Specifies the Name of the Sales Code value, either a customer name or a customer price group name.';
                    ApplicationArea = All;
                }
                field("Work Type Code"; rec."Work Type Code")
                {
                    Caption = 'Work Type Code';
                    ToolTip = 'Specifies the value of the Work Type Code field.';
                    ApplicationArea = All;
                }
                field(Rental; rec.Rental)
                {
                    Caption = 'Rental';
                    ToolTip = 'If checked, the resource is a rental.';
                    ApplicationArea = All;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    Visible = false;
                    Caption = 'Currency Code';
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field("Unit Of Measure Code"; rec."Unit Of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';
                    ToolTip = 'Specifies the value of the Unit Of Measure Code field.';
                    ApplicationArea = All;
                }
                field("Unit Price"; rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
                field("Starting Date"; rec."Starting Date")
                {
                    Caption = 'Starting Date';
                    ToolTip = 'Specifies the value of the Starting Date field.';
                    ApplicationArea = All;
                }
                field("Ending Date"; rec."Ending Date")
                {
                    Caption = 'Ending Date';
                    ToolTip = 'Specifies the value of the Ending Date field.';
                    ApplicationArea = All;
                }

                /*
                field("Starting Time"; rec."Starting Time")
                {
                    Caption = 'Starting Time';
                    ToolTip = 'Specifies the value of the Starting Time field.';
                    ApplicationArea = All;
                }
                field("Ending Time"; rec."Ending Time")
                {
                    Caption = 'Ending Time';
                    ToolTip = 'Specifies the value of the Ending Tiem field.';
                    ApplicationArea = All;
                }
                */

            }
        }
    }
}
