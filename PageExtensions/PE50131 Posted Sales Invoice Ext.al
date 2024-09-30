pageextension 50131 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        addbefore("Sell-to Customer No.")
        {
            field("Pre-Assigned No."; rec."Pre-Assigned No.")
            {
                caption = 'Sales Invoice No.';
                ToolTip = 'Identified the original Sales Invoice No.';
                ApplicationArea = All;
            }
        }
    }
}
