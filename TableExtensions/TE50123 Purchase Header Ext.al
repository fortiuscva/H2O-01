tableextension 50123 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50100; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = filter(Invoice));
        }
    }



    procedure DropShptInvoiceExists(SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        // returns TRUE if sales invoice is either Drop Shipment of Special Order
        SalesLine2.Reset();
        SalesLine2.SetRange("Document Type", SalesLine2."Document Type"::Invoice);
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        SalesLine2.SetRange("Drop Shipment 2", true);
        exit(not SalesLine2.IsEmpty());
    end;

}
