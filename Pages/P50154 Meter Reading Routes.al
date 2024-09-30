page 50154 "Meter Reading Routes"
{
    ApplicationArea = All;
    Caption = 'Meter Reading Routes';
    PageType = List;
    SourceTable = "Meter Reading Route";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    caption = 'Line No.';
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    caption = 'Customer No.';
                }
                field("Route No."; Rec."Route No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Route No. field.';
                    caption = 'Route No.';
                }
                field("Location Stop"; rec."Location Stop")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Stop field.';
                    caption = 'Location Stop';
                }
                field("Smart Meter"; rec."Smart Meter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Stop field.';
                    caption = 'Smart Meter';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resource No. field.';
                    Caption = 'Technician No.';
                }
                field("Reading Date"; rec."Reading Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meter Reading Date field.';
                    Caption = 'Meter Reading Date';
                }
                field("Meter No."; Rec."Meter No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meter No. field.';
                    Caption = 'Meter No.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Caption = 'Serial No.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Address field.';
                    Caption = 'Address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Address 2 field.';
                    Caption = 'Address 2';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to City field.';
                    Caption = 'City';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Property No. field.';
                    Caption = 'Property No.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to State field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to ZIP Code field.';
                }
            }
        }
    }
}
