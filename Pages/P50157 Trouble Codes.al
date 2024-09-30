page 50157 "Trouble Codes"
{
    ApplicationArea = All;
    Caption = 'Trouble Codes';
    PageType = List;
    SourceTable = "Trouble Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    caption = 'Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    caption = 'Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Replace; rec.Replace)
                {
                    caption = 'Replace';
                    ApplicationArea = all;
                    ToolTip = 'If checked, the meter must be replaced.';
                }
            }
        }
    }
}
