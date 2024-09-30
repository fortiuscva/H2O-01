pageextension 50144 "General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addbefore("Background Posting")
        {
            group(H2O)
            {
                caption = 'H2O Specific';

                field("Global Dim. 1 Code Required"; rec."Global Dim. 1 Code Required")
                {
                    caption = 'Dim. 1 Code Required on Sales Headers';
                    ToolTip = 'Specifies whether The Global Dimension 1 Code is required on Sales Invoices, Credot Memos, etc.';
                    ApplicationArea = All;
                }
                field("Global Dim. 2 Code Required"; rec."Global Dim. 2 Code Required")
                {
                    caption = 'Dim. 2 Code Required on Sales Lines';
                    ToolTip = 'Specifies whether The Global Dimension 2 Code is required on Salss Invoice Lines, Sales Credit Memo Lines, etc.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
