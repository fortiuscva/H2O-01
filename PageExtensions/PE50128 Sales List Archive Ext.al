pageextension 50128 "Sales List Archive Ext" extends "Sales List Archive"
{
    actions
    {
        addafter(ShowDocument)
        {
            action(ShowDocument2)
            {
                ApplicationArea = Suite;
                Caption = 'Show Document - Invoice';
                Image = EditLines;
                ShortCutKey = 'Return';
                ToolTip = 'View or change detailed information about the record on the document or journal line.';

                trigger OnAction()
                var
                    SalesInvArchives: page "Sales Invoice Archive";
                    SalesHeaderArchive: record "Sales Header Archive";
                begin
                    SalesHeaderArchive.setrange("Document Type", SalesHeaderArchive."Document Type"::Invoice);
                    SalesHeaderArchive.setrange("No.", rec."No.");
                    SalesInvArchives.SetTableView(SalesHeaderArchive);
                    SalesInvArchives.run;
                end;
            }

        }
    }
}
