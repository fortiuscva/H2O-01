page 50149 "H2O Calendar"
{
    ApplicationArea = All;
    Caption = 'H2O Calendar';
    PageType = List;
    SourceTable = "H2O Calendar";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Day of Week"; Rec."Day of Week")
                {
                    ToolTip = 'Specifies the value of the Day of Week field.';
                }
                field("Nonworking Day"; Rec."Nonworking Day")
                {
                    ToolTip = 'Specifies the value of the Nonworking Day field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Contract Start Time"; Rec."Contract Start Time")
                {
                    ToolTip = 'Specifies the value of the Contract Start Time field.';
                }
                field("Contract End Time"; Rec."Contract End Time")
                {
                    ToolTip = 'Specifies the value of the Contract End Time field.';
                }
            }
        }
    }
}
