pageextension 50130 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Archive Return Orders")
        {
            field("Archive Batch Invoices"; rec."Archive Batch Invoices")
            {
                caption = 'Archive Batch Invoices';
                ToolTip = 'If checked, this will archive all batch invoices becure posting them.';
                ApplicationArea = All;
            }
            field("Auto-Delete Work Orders"; rec."Auto-Delete Work Order")
            {
                caption = 'Auto-Delete Work Orders';
                ToolTip = 'If checked, this will automatically delete work orders after they have been batch invoiced.';
                ApplicationArea = All;
            }
            field("Batch Invoice Testing"; rec."Batch Invoice Testing")
            {
                caption = 'Batch Invoice Testing';
                ToolTip = 'This should only be checked during the testing of the batch sales invoice process. Once "live", this should never be checked.';
                ApplicationArea = All;
            }
        }
    }
}