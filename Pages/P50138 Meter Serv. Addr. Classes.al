page 50138 "Meter Service Address Classes"
{
    ApplicationArea = All;
    Caption = 'Meter Service Address Classes';
    PageType = List;
    SourceTable = "Meter Service Address Class";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; rec.Code)
                {
                    Caption = 'Code';
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Descriptin';
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
