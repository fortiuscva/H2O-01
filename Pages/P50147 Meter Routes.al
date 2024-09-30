page 50147 "Meter Routes"
{
    ApplicationArea = All;
    Caption = 'Routes';
    PageType = List;
    SourceTable = Route;
    UsageCategory = Lists;
    DataCaptionFields = "Customer No.";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; rec."Customer No.")
                {
                    caption = 'Customer No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("No."; Rec."No.")
                {
                    caption = 'Route No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Route No. field.';
                }
                field(Description; Rec.Description)
                {
                    caption = 'Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(LocStops)
            {
                ApplicationArea = All;
                Caption = 'Location Stops';
                Image = Statistics;
                RunObject = Page "Location Stops";
                RunPageLink = "Route No." = FIELD("No.");
                //ShortCutKey = 'F7';
                ToolTip = 'View Location Stops for Route';
            }
        }
    }
}