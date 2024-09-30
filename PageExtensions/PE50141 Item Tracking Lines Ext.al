pageextension 50141 "Item Tracking Lines Ext" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Serial No.")
        {
            field("EID No."; rec."EID No.")
            {
                caption = 'EID No.';
                ToolTip = 'Specifies the meter'' EID No.';
                ApplicationArea = All;
            }
        }
    }
}
