pageextension 50142 "Serial No. Info. Card Ext" extends "Serial No. Information Card"
{
    layout
    {
        addafter("Serial No.")
        {
            field("EID No."; rec."EID No.")
            {
                caption = 'Meter EID No.';
                ToolTip = 'Specifies the meter''s EID No.';
                ApplicationArea = All;
            }
        }
    }
}
