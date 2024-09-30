page 50158 "Skip Codes"
{
    ApplicationArea = All;
    Caption = 'Skip Codes';
    PageType = List;
    SourceTable = "Skip Code";
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
            }
        }
    }
}
