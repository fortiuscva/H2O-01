page 50159 "Meter Read Opportunities"
{
    ApplicationArea = All;
    Caption = 'Meter Read Opportunities';
    PageType = List;
    SourceTable = "Meter Read Opportunity";
    UsageCategory = Lists;
    //Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    caption = 'Customer No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    caption = 'Property No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Property No. field.';
                }
                field("Meter No."; Rec."Meter No.")
                {
                    caption = 'Meter No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Meter No. field.';
                }
                field("Date Read"; Rec."Date Read")
                {
                    caption = 'Date Read';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Read field.';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    caption = 'Resource No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Resource No. field.';
                }
                field("Trouble Code"; Rec."Trouble Code")
                {
                    caption = 'Trouble Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Trouble Code field.';
                }
                field(Replace; Rec.Replace)
                {
                    caption = 'Replace';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Replace field.';
                }
                field("Skip Code"; Rec."Skip Code")
                {
                    caption = 'Skip Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Skip Code field.';
                }
                field("Work Order Created"; Rec."Work Order Created")
                {
                    caption = 'Work Order Created';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Work Order Created field.';
                }
            }
        }
    }
}
