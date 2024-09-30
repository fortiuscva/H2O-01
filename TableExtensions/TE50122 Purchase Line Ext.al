tableextension 50122 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50100; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Sales Header"."No." WHERE("Document Type" = CONST(Invoice));

            trigger OnValidate()
            var
                PurchWhseMgt: codeunit "Purchases Warehouse Mgt.";
            begin
                if (xRec."Sales Invoice No." <> "Sales Invoice No.") and (Quantity <> 0) then begin
                    PurchLineReserve.VerifyChange(Rec, xRec);
                    PurchWhseMgt.PurchaseLineVerifyChange(Rec, xRec);
                end;
            end;
        }
        field(50105; "Sales Invoice Line No."; Integer)
        {
            Caption = 'Sales Invoice Line No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Sales Line"."Line No." WHERE("Document Type" = CONST(Invoice),
                                                                                            "Document No." = FIELD("Sales Invoice No."));

            trigger OnValidate()
            var
                PurchWhseMgt: codeunit "Purchases Warehouse Mgt.";
            begin
                if (xRec."Sales Invoice Line No." <> "Sales Invoice Line No.") and (Quantity <> 0) then begin
                    PurchLineReserve.VerifyChange(Rec, xRec);
                    PurchWhseMgt.PurchaseLineVerifyChange(Rec, xRec);
                end;
            end;
        }
    }


    var
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        CatalogItemMgt: Codeunit "Catalog Item Management";
        Text1020001: Label 'This operation will remove the Tax Differences that were previously entered. Are you sure you want to continue?';
        Text1020000: Label 'You must reopen the document since this will affect Sales Tax.';



    trigger OnBeforeDelete()
    var
        PurchCommentLine: Record "Purch. Comment Line";
        SalesOrderLine: Record "Sales Line";
        SalesInvoiceLine: record "Sales Line";
        PurchLine2: record "Purchase Line";
        IsHandled: Boolean;
        ShouldModifySalesOrderLine: Boolean;
        ShouldModifySalesInvoiceLine: boolean;
        PurchWhseMgt: codeunit "Purchases Warehouse Mgt.";
    begin
        IsHandled := false;
        //OnDeleteOnBeforeTestStatusOpen(Rec, IsHandled);
        if not IsHandled then
            TestStatusOpen();

        CheckForTaxDifferences();

        if (Quantity <> 0) and ItemExists("No.") then begin
            PurchLineReserve.DeleteLine(Rec);
            IsHandled := false;
            //OnDeleteOnBeforeCheckQtyNotInvoiced(Rec, IsHandled);
            if not IsHandled then begin
                if "Receipt No." = '' then
                    TestField("Qty. Rcd. Not Invoiced", 0);
                if "Return Shipment No." = '' then
                    TestField("Return Qty. Shipped Not Invd.", 0);
            end;

            IsHandled := false;
            //OnDeleteOnBeforePurchaseLineDelete(Rec, IsHandled);
            if not IsHandled then begin
                CalcFields("Reserved Qty. (Base)");
                TestField("Reserved Qty. (Base)", 0);
                PurchWhseMgt.PurchaseLineDelete(Rec);
            end;
        end;

        if ("Document Type" = "Document Type"::Order) and (Quantity <> "Quantity Invoiced") then
            TestField("Prepmt. Amt. Inv.", "Prepmt Amt Deducted");

        If "Sales Order Line No." <> 0 then begin
            ShouldModifySalesOrderLine := "Sales Order Line No." <> 0;
            //OnDeleteOnAfterCalcShouldModifySalesOrderLine(Rec, ShouldModifySalesOrderLine);
            if ShouldModifySalesOrderLine then begin
                LockTable();
                SalesOrderLine.LockTable();
                SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, "Sales Order No.", "Sales Order Line No.");
                SalesOrderLine."Purchase Order No." := '';
                SalesOrderLine."Purch. Order Line No." := 0;
                SalesOrderLine.Modify();
            end;
        end;

        If "Sales Invoice Line No." <> 0 then begin
            ShouldModifySalesInvoiceLine := "Sales Invoice Line No." <> 0;
            //OnDeleteOnAfterCalcShouldModifySalesOrderLine(Rec, ShouldModifySalesOrderLine);
            if ShouldModifySalesInvoiceLine then begin
                LockTable();
                SalesInvoiceLine.LockTable();
                SalesInvoiceLine.Get(SalesOrderLine."Document Type"::Invoice, "Sales Invoice No.", "Sales Invoice Line No.");
                SalesInvoiceLine."Purchase Order No." := '';
                SalesInvoiceLine."Purch. Order Line No." := 0;
                SalesInvoiceLine.Modify();
            end;
        end;

        UpdateSpecialSalesOrderLineFromOnDelete(SalesOrderLine);

        CatalogItemMgt.DelNonStockPurch(Rec);

        if "Document Type" = "Document Type"::"Blanket Order" then begin
            PurchLine2.Reset();
            PurchLine2.SetCurrentKey("Document Type", "Blanket Order No.", "Blanket Order Line No.");
            PurchLine2.SetRange("Blanket Order No.", "Document No.");
            PurchLine2.SetRange("Blanket Order Line No.", "Line No.");
            //OnDeleteOnAfterSetPurchLineFilters(PurchLine2);
            if PurchLine2.FindFirst() then
                PurchLine2.TestField("Blanket Order Line No.", 0);
        end;

        if Type = Type::Item then
            DeleteItemChargeAssignment("Document Type", "Document No.", "Line No.");

        if Type = Type::"Charge (Item)" then
            DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");

        if "Line No." <> 0 then begin
            PurchLine2.Reset();
            PurchLine2.SetRange("Document Type", "Document Type");
            PurchLine2.SetRange("Document No.", "Document No.");
            PurchLine2.SetRange("Attached to Line No.", "Line No.");
            PurchLine2.SetFilter("Line No.", '<>%1', "Line No.");
            //OnDeleteOnBeforePurchLineDeleteAll(PurchLine2);
            PurchLine2.DeleteAll(true);
            //OnDeleteOnAfterPurchLineDeleteAll(Rec, PurchLine2);
        end;

        PurchCommentLine.SetRange("Document Type", "Document Type");
        PurchCommentLine.SetRange("No.", "Document No.");
        PurchCommentLine.SetRange("Document Line No.", "Line No.");
        if not PurchCommentLine.IsEmpty() then
            PurchCommentLine.DeleteAll();

        // In case we have roundings on VAT or Sales Tax, we should update some other line
        if (Type <> Type::" ") and ("Line No." <> 0) and not IsExtendedText() and
           (Quantity <> 0) and (Amount <> 0) and (Amount <> "Amount Including VAT") and not StatusCheckSuspended
        then begin
            Quantity := 0;
            "Quantity (Base)" := 0;
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
            "Line Discount Amount" := 0;
            "Inv. Discount Amount" := 0;
            "Inv. Disc. Amount to Invoice" := 0;
            //OnDeleteOnBeforeUpdateAmounts(Rec);
            UpdateAmounts();
            //OnDeleteOnAfterUpdateAmounts(Rec);
        end;

        //if "Deferral Code" <> '' then
        //DeferralUtilities.DeferralCodeOnDelete(
        //"Deferral Document Type"::Purchase.AsInteger(), '', '',
        //"Document Type".AsInteger(), "Document No.", "Line No.");

        IsHandled := true;
    end;



    internal procedure IsExtendedText(): Boolean
    begin
        exit((Type = Type::" ") and ("Attached to Line No." <> 0) and (Quantity = 0));
    end;


    local procedure CheckForTaxDifferences()
    var
        SalesTaxDifference: Record "Sales Tax Amount Difference";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeCheckForTaxDifferences(Rec, IsHandled);
        if IsHandled then
            exit;

        if "Tax Area Code" = '' then
            exit;

        if SalesTaxDifference.AnyTaxDifferenceRecords(
             "Sales Tax Document Area"::Purchase.AsInteger(), "Document Type".AsInteger(), "Document No.")
        then begin
            if Confirm(Text1020001, false) then
                SalesTaxDifference.ClearDocDifference(
                  "Sales Tax Document Area"::Purchase.AsInteger(), "Document Type".AsInteger(), "Document No.")
            else
                Error(Text1020000);
        end;
    end;


    local procedure UpdateSpecialSalesOrderLineFromOnDelete(SalesOrderLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeUpdateSpecialSalesOrderLineFromOnDelete(Rec, SalesOrderLine, IsHandled);
        if IsHandled then
            exit;

        if ("Special Order Sales Line No." <> 0) and ("Quantity Invoiced" = 0) then begin
            LockTable();
            SalesOrderLine.LockTable();
            if SalesOrderLine.Get(
                 SalesOrderLine."Document Type"::Order, "Special Order Sales No.", "Special Order Sales Line No.")
            then begin
                SalesOrderLine."Special Order Purchase No." := '';
                SalesOrderLine."Special Order Purch. Line No." := 0;
                SalesOrderLine.Modify();
            end;
        end;
    end;

}