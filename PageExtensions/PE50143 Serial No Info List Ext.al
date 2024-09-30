pageextension 50143 "Serial No. Info List Ext" extends "Serial No. Information List"
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
