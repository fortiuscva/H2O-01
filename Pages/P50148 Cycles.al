page 50148 Cycles
{
    ApplicationArea = All;
    Caption = 'Cycles';
    PageType = List;
    SourceTable = Cycle;
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
