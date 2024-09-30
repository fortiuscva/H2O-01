page 50155 "Location Stops"
{
    ApplicationArea = All;
    Caption = 'Location Stops';
    PageType = List;
    SourceTable = "Location Stop";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Route No."; Rec."Route No.")
                {
                    ApplicationArea = All;
                    caption = 'Route';
                    ToolTip = 'Specifies the value of the Route field.';
                }
                field("Location Stop"; Rec."Location Stop")
                {
                    ApplicationArea = All;
                    caption = 'Location Stops';
                    ToolTip = 'Specifies the value of the Location Stop field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
