page 50151 "Virtual Date"
{
    ApplicationArea = All;
    Caption = 'Virtual Date';
    PageType = List;
    SourceTable = "date";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Type"; Rec."Period Type")
                {
                    ToolTip = 'Specifies the value of the Period Type field.';
                }
                field("Period No."; Rec."Period No.")
                {
                    ToolTip = 'Specifies the value of the Period No. field.';
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the name of the period shown in the line.';
                }
                field("Period Start"; Rec."Period Start")
                {
                    ToolTip = 'Specifies the starting date of the period that you want to view.';
                }
                field("Period End"; Rec."Period End")
                {
                    ToolTip = 'Specifies the value of the Period End field.';
                }
                field("Period Invariant Name"; Rec."Period Invariant Name")
                {
                    ToolTip = 'Specifies the value of the Period Invariant Name field.';
                }
            }
        }
    }
}
