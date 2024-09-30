page 50150 "Meter Template List"
{
    ApplicationArea = All;
    Caption = 'Meter Templates';
    PageType = List;
    SourceTable = "Meter Template";
    CardPageId = "Meter Template Card";
    Editable = false;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = all;
                }
            }
        }
    }
}
