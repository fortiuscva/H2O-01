codeunit 50122 "Get Batch Invoice Lines"
{
    TableNo = "Sales Header";
    Permissions = TableData "Sales Shipment Header" = rm;


    var
        Text50007: TextConst ENU = 'Sell-to Customer No. cannot be blank for Sales Invoice No. %2"';
        Text50008: Textconst ENU = 'Status must be Open for Sales Invoice No. %1';
        Text50009: TextConst ENU = 'Include in Batch Invoicing must be false for Sales Invoice No. %1';
        Text50010: TextConst ENU = 'Batch Invoice must be true for Sales Invoice %1';


    trigger OnRun()
    begin

    end;


    procedure GetBatchInvLines(var SH: record "Sales Header")
    var
        SalesHeader2: record "Sales Header";
        //SalesHead: record "Sales Header";
        SalesLine2: record "Sales Line";
        SalesLine3: record "Sales Line";
        SalesSetup: record "Sales & Receivables Setup";
        SalesShptHeader: record "Sales Shipment Header";
        SalesShptLine: record "Sales Shipment Line";
        ILE: record "Item Ledger Entry";
        Item: record Item;
        MtrAct: record "Meter Activity";
        Mtr: record meter;
        LineNo: integer;
        LastEntryNo: integer;
        CntrCreate: integer;
        CntrDelete: integer;
        ArchMgt: codeunit ArchiveManagement;
        OrigLineNo: integer;
        OrigDocNo: code[20];
        OrigShipTo: code[10];
        OrigCompDate: date;
        OrigNo: code[20];
    begin
        SalesSetup.get;
        IF SH."Sell-to Customer No." = '' then
            error(Text50007, SH."No.");
        IF SH.Status <> SH.Status::Open then
            error(Text50008, SH."No.");
        IF SH."Include in Batch Invoicing" = true then
            error(Text50009, SH."No.");
        IF SH."Batch Invoice" = false then
            error(Text50010, SH."No.");


        //pull in all posted sales shipments of meter items
        SalesShptHeader.reset;
        SalesShptHeader.setrange("Sell-to Customer No.", SH."Sell-to Customer No.");
        SalesShptHeader.setrange("Include In Batch Invoicing", true);
        SalesShptHeader.setrange(Invoiced, false);
        IF SalesShptHeader.findset then begin
            repeat
                SalesShptLine.reset;
                SalesShptLine.setrange("Document No.", SalesShptHeader."No.");
                SalesShptLine.setrange(Type, SalesShptLine.Type::Item);
                IF SalesShptLine.findset then begin
                    LineNo := 10000;
                    repeat
                        IF Item.get(SalesShptLine."No.") then
                            IF Item.Meter then begin
                                ILE.reset;
                                ILE.setrange("Document No.", SalesShptLine."Document No.");
                                ILE.setrange("Item No.", SalesShptLine."No.");
                                ILE.setrange("Entry Type", ILE."Entry Type"::Sale);
                                ILE.setrange(Meter, true);
                                ILE.setrange("Meter Created", true);
                                IF ILE.findfirst then
                                    repeat
                                        SalesLine3.init;
                                        SalesLine3."Document Type" := SH."Document Type";
                                        SalesLine3."Document No." := SH."No.";
                                        SalesLine3."Line No." := LineNo;
                                        SalesLine3.insert;

                                        SalesLine3.Type := SalesLine3.Type::Meter;
                                        SalesLine3."No." := ILE."Meter No.";
                                        SalesLine3.Description := Item.Description;
                                        SalesLine3."Location Code" := ILE."Location Code";
                                        IF SalesLine3."Meter Activity Code" = '' then begin
                                            MtrAct.reset;
                                            MtrAct.setrange(Sale, true);
                                            IF MtrAct.findfirst then
                                                SalesLine3."Meter Activity Code" := MtrAct.Code;
                                        end else
                                            SalesLine3."Meter Activity Code" := SalesShptLine."Meter Activity Code";
                                        SalesLine3."Meter Serial No." := ILE."Serial No.";
                                        SalesLine3."Unit of Measure Code" := ILE."Unit of Measure Code";
                                        SalesLine3.validate(Quantity, Abs(ILE.Quantity));
                                        SalesLine3.validate("Qty. to Invoice", Abs(ILE.Quantity));
                                        SalesLine3.validate("Unit Price", SalesShptLine."Unit Price");
                                        SalesLine3."Amount Including VAT" := SalesLine3."Unit Price" * SalesLine3.Quantity;
                                        SalesLine3."Shortcut Dimension 1 Code" := SalesShptLine."Shortcut Dimension 1 Code";
                                        SalesLine3."Shortcut Dimension 2 Code" := SalesShptLine."Shortcut Dimension 2 Code";
                                        If Mtr.get(ILE."Meter No.") then begin
                                            Mtr.testfield("Gen. Prod. Posting Group");
                                            SalesLine3."Gen. Prod. Posting Group" := Mtr."Gen. Prod. Posting Group";
                                        end;

                                        SalesLine3."Sell-to Customer No." := SalesShptHeader."Sell-to Customer No.";
                                        SalesLine3."Original Document No." := SalesShptLine."Document No.";
                                        SalesLine3."Original Line No." := SalesShptLine."Line No.";
                                        SalesLine3."Original Ship-to Code" := SalesShptHeader."Ship-to Code";
                                        SalesLine3."Original Completed Date" := SalesShptHeader."Completed Date";
                                        SalesLine3."Original No." := SalesShptLine."No.";

                                        SalesLine3."VAT Calculation Type" := SalesShptLine."VAT Calculation Type"::"Sales Tax";
                                        SalesLine3."Material Amount" := SalesShptLine."Material Amount";
                                        SalesLine3."Equipment Amount" := SalesShptLine."Equipment Amount";
                                        SalesLine3."Labor Amount" := SalesShptLine."Labor Amount";

                                        SalesLine3.modify;
                                        LineNo += 10000;

                                        //Add ship-to address or bill-to line
                                        SalesLine3.init;
                                        SalesLine3."Document Type" := SH."Document Type";
                                        SalesLine3."Document No." := SH."No.";
                                        SalesLine3."Line No." := LineNo;
                                        SalesLine3.insert;
                                        SalesLine3.Type := SalesLine3.Type::" ";
                                        If SalesShptHeader."Ship-to Address" <> '' then
                                            SalesLine3.Description := SalesShptHeader."Ship-to Address"
                                        else
                                            SalesLine3.Description := SalesShptHeader."Bill-to Address";
                                        SalesLine3."Original Document No." := OrigDocNo;
                                        SalesLine3."Original Ship-to Code" := OrigShipTo;
                                        SalesLine3."Original Line No." := OrigLineNo;
                                        SalesLine3."Original Completed Date" := OrigCompDate;
                                        SalesLine3."Location Comment" := true;
                                        SalesLine3."Original No." := OrigNo;

                                        SalesLine3.modify;
                                        LineNo += 10000;

                                        //Add purpose as a comment line
                                        If SalesHeader2.Purpose <> '' then begin
                                            SalesLine3.init;
                                            SalesLine3."Document Type" := SH."Document Type";
                                            SalesLine3."Document No." := SH."No.";
                                            SalesLine3."Line No." := LineNo;
                                            SalesLine3.insert;
                                            SalesLine3.Type := SalesLine3.Type::" ";
                                            IF SalesShptHeader.Purpose <> '' then begin
                                                SalesLine3.Description := SalesShptHeader.Purpose;
                                                SalesLine3."WO Purpose" := true;
                                            end;
                                            SalesLine3."Original Document No." := OrigDocNo;
                                            SalesLine3."Original Ship-to Code" := OrigShipTo;
                                            SalesLine3."Original Line No." := OrigLineNo;
                                            SalesLine3."Original Completed Date" := OrigCompDate;
                                            SalesLine3."Original No." := OrigNo;
                                            SalesLine3.Modify;
                                            LineNo += 10000;
                                        end;

                                        //Add blank line between detail lines for detail report
                                        SalesLine3.init;
                                        SalesLine3."Document Type" := SH."Document Type";
                                        SalesLine3."Document No." := SH."No.";
                                        SalesLine3."Line No." := LineNo;
                                        SalesLine3.insert;
                                        SalesLine3.Type := SalesLine3.Type::" ";
                                        SalesLine3."Original Document No." := OrigDocNo;
                                        SalesLine3."Original Ship-to Code" := OrigShipTo;
                                        SalesLine3."Original Line No." := OrigLineNo;
                                        SalesLine3."Original Completed Date" := OrigCompDate;
                                        SalesLine3."Original No." := OrigNo;

                                        SalesLine3.Modify;
                                        LineNo += 10000;
                                    until ILE.next = 0;
                            end;

                    until SalesShptLine.next = 0;
                end;

                IF SalesSetup."Batch Invoice Testing" then begin
                    SalesShptHeader.Invoiced := false;
                    SalesShptHeader.modify;
                end else begin
                    SalesShptHeader.Invoiced := true;
                    SalesShptHeader.modify;
                end;
            until SalesShptHeader.next = 0;
        end;


        //pull in all work orders (sales invoices)
        SalesHeader2.reset;
        SalesHeader2.setrange("Document Type", SalesHeader2."Document Type"::Invoice);
        SalesHeader2.setrange("Work Order Status", SalesHeader2."Work Order Status"::"Ready For Invoicing");
        SalesHeader2.setrange("Sell-to Customer No.", SH."Sell-to Customer No.");
        SalesHeader2.setrange(Status, SalesHeader2.Status::Released);
        SalesHeader2.setrange("Include In Batch Invoicing", true);
        IF SalesHeader2.findset then begin
            repeat
                SalesLine2.reset;
                SalesLine2.setrange("Document Type", SalesHeader2."Document Type");
                SalesLine2.setrange("Document No.", SalesHeader2."No.");
                If SalesLine2.findset then begin
                    LineNo += 10000;
                    repeat //build the batch invoice lines
                        OrigLineNo := SalesLine2."Original Line No.";
                        OrigDocNo := SalesLine2."Original Document No.";
                        OrigShipTo := SalesLine2."Original Ship-to Code";
                        OrigCompDate := SalesHeader2."Completed Date";
                        OrigNo := SalesLine2."Original No.";

                        SalesLine3.init;
                        SalesLine3 := SalesLine2;
                        SalesLine3."Document Type" := SH."Document Type";
                        SalesLine3."Document No." := SH."No.";
                        SalesLine3."Line No." := LineNo;
                        SalesLine3.insert;
                        SalesLine3."Original Document No." := SalesLine2."Original Document No.";
                        SalesLine3."Original Line No." := SalesLine2."Original Line No.";
                        SalesLine3."Sell-to Customer No." := SalesHeader2."Sell-to Customer No.";
                        SalesLine3."Original Ship-to Code" := SalesHeader2."Ship-to Code";
                        SalesLine3."Original Completed Date" := SalesHeader2."Completed Date";
                        SalesLine3."Original No." := SalesLine3."No.";
                        SalesLine3."VAT Calculation Type" := SalesLine3."VAT Calculation Type"::"Sales Tax";
                        SalesLine3."Material Amount" := SalesLine2."Material Amount";
                        SalesLine3."Equipment Amount" := SalesLine2."Equipment Amount";
                        SalesLine3."Labor Amount" := SalesLine2."Labor Amount";

                        SalesLine3.modify;

                        LineNo += 10000;
                        //Add ship-to address or bill-to line
                        SalesLine3.init;
                        SalesLine3."Document Type" := SH."Document Type";
                        SalesLine3."Document No." := SH."No.";
                        SalesLine3."Line No." := LineNo;
                        SalesLine3.insert;
                        SalesLine3.Type := SalesLine3.Type::" ";
                        If SalesHeader2."Ship-to Address" <> '' then
                            SalesLine3.Description := SalesHeader2."Ship-to Address"
                        else
                            SalesLine3.Description := SalesHeader2."Bill-to Address";
                        SalesLine3."Original Document No." := OrigDocNo;
                        SalesLine3."Original Ship-to Code" := OrigShipTo;
                        SalesLine3."Original Line No." := OrigLineNo;
                        SalesLine3."Original Completed Date" := OrigCompDate;
                        SalesLine3."Location Comment" := true;
                        SalesLine3."Original No." := OrigNo;
                        SalesLine3.modify;
                        LineNo += 10000;
                        //Add purpose as a comment line
                        If SalesHeader2.Purpose <> '' then begin
                            SalesLine3.init;
                            SalesLine3."Document Type" := SH."Document Type";
                            SalesLine3."Document No." := SH."No.";
                            SalesLine3."Line No." := LineNo;
                            SalesLine3.insert;
                            SalesLine3.Type := SalesLine3.Type::" ";
                            IF SalesHeader2.Purpose <> '' then begin
                                SalesLine3.Description := SalesHeader2.Purpose;
                                SalesLine3."WO Purpose" := true;
                            end;
                            SalesLine3."Original Document No." := OrigDocNo;
                            SalesLine3."Original Ship-to Code" := OrigShipTo;
                            SalesLine3."Original Line No." := OrigLineNo;
                            SalesLine3."Original Completed Date" := OrigCompDate;
                            SalesLine3."Original No." := OrigNo;
                            SalesLine3.Modify;
                            LineNo += 10000;
                        end;
                        //Add blank line between detail lines for detail report
                        SalesLine3.init;
                        SalesLine3."Document Type" := SH."Document Type";
                        SalesLine3."Document No." := SH."No.";
                        SalesLine3."Line No." := LineNo;
                        SalesLine3.insert;
                        SalesLine3.Type := SalesLine3.Type::" ";
                        SalesLine3."Original Document No." := OrigDocNo;
                        SalesLine3."Original Ship-to Code" := OrigShipTo;
                        SalesLine3."Original Line No." := OrigLineNo;
                        SalesLine3."Original Completed Date" := OrigCompDate;
                        SalesLine3."Original No." := OrigNo;
                        SalesLine3.Modify;
                        LineNo += 10000;
                    until SalesLine2.next = 0;
                end;
                CntrCreate += 1;
                SalesHeader2."OK To Delete" := true;

                IF SalesSetup."Batch Invoice Testing" then begin
                    SalesHeader2.Invoiced := false;
                    SalesHeader2.modify;
                end else begin
                    SalesHeader2.Invoiced := true;
                    SalesHeader2.modify;
                end;

                Commit;
                If SalesHeader2."OK To Delete" then begin
                    If SalesSetup."Archive Batch Invoices" then ArchMgt.StoreSalesDocument(SalesHeader2, false);
                    If SalesSetup."Auto-Delete Work Order" then begin
                        SalesHeader2.delete(true);
                        CntrDelete += 1;
                    end;
                end;
            until SalesHeader2.next = 0;
        end;
    end;


}
