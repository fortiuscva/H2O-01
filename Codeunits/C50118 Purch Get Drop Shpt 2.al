codeunit 50118 "Purch.-Get Drop Shpt. 2"
{
    Permissions = TableData "Sales Header" = rm,
                  TableData "Sales Line" = rm;
    TableNo = "Purchase Header";

    trigger OnRun()
    begin
        PurchHeader.Copy(Rec);
        OnRunOnBeforeCode(Rec, PurchHeader);
        Code();
        Rec := PurchHeader;
    end;



    var
        Text000: Label 'There were no lines to be retrieved from work order %1.';
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
        Text001: Label 'The %1 for %2 %3 has changed from %4 to %5 since the Sales Order was created. Adjust the %6 on the Sales Order or the %1.';
        Text002: Label 'The %1 for %2 %3 has changed from %4 to %5 since the Sales Invoice was created. Adjust the %6 on the Sales Invoice or the %1.';
        SelltoCustomerBlankErr: Label 'The Sell-to Customer No. field must have a value.';



    local procedure "Code"()
    var
        PurchLine2: Record "Purchase Line";
        IsHandled: Boolean;
    begin
        //with PurchHeader do begin
        PurchHeader.TestField("Document Type", PurchHeader."Document Type"::Order);

        if PurchHeader."Sell-to Customer No." = '' then
            Error(SelltoCustomerBlankErr);

        IsHandled := false;
        OnCodeOnBeforeSelectSalesHeader(PurchHeader, SalesHeader, IsHandled);
        if not IsHandled then begin
            SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.");
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
            SalesHeader.SetRange("Sell-to Customer No.", PurchHeader."Sell-to Customer No.");
            if (PAGE.RunModal(PAGE::"Sales List", SalesHeader) <> ACTION::LookupOK) or
               (SalesHeader."No." = '')
            then
                exit;
        end;

        PurchHeader.LockTable();
        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Invoice);
        PurchHeader.TestField("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        PurchHeader.TestField("Ship-to Code", SalesHeader."Ship-to Code");
        if PurchHeader.DropShptInvoiceExists(SalesHeader) then
            PurchHeader.AddShipToAddress(SalesHeader, true);

        PurchLine.LockTable();
        SalesLine.LockTable();

        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then
            NextLineNo := PurchLine."Line No." + 10000
        else
            NextLineNo := 10000;

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Drop Shipment 2", true);
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        //SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.Setfilter(type, '%1|%2', SalesLine.Type::Item, SalesLine.Type::Resource);
        SalesLine.SetFilter("No.", '<>%1', '');
        SalesLine.SetRange("Purch. Order Line No.", 0);
        OnCodeOnAfterSalesLineSetFilters(SalesLine, PurchHeader);

        if SalesLine.Find('-') then
            repeat
                CheckSalesLineQtyPerUnitOfMeasure();
                IsHandled := false;
                //OnCodeOnBeforeProcessPurchaseLine(SalesLine, IsHandled, PurchHeader, NextLineNo);
                if not IsHandled then begin
                    PurchLine.Init();
                    PurchLine."Document Type" := PurchLine."Document Type"::Order;
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := NextLineNo;
                    CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine, PurchLine);
                    GetDescription(PurchLine, SalesLine);
                    PurchLine."Sales Invoice No." := SalesLine."Document No.";
                    PurchLine."Sales Invoice Line No." := SalesLine."Line No.";
                    PurchLine."Drop Shipment" := true;
                    PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
                    Evaluate(PurchLine."Inbound Whse. Handling Time", '<0D>');
                    PurchLine.Validate("Inbound Whse. Handling Time");
                    OnBeforePurchaseLineInsert(PurchLine, SalesLine);
                    PurchLine.Insert();
                    OnAfterPurchaseLineInsert(PurchLine, SalesLine, NextLineNo);

                    NextLineNo := NextLineNo + 10000;

                    UpdateSalesLineUnitCostLCY();
                    SalesLine."Purchase Order No. 2" := PurchLine."Document No.";
                    SalesLine."Purch. Order Line No. 2" := PurchLine."Line No.";
                    OnBeforeSalesLineModify(SalesLine, PurchLine, SalesHeader);
                    SalesLine.Modify();
                    OnAfterSalesLineModify(SalesLine, PurchLine);
                    ItemTrackingMgt.CopyItemTracking(SalesLine.RowID1(), PurchLine.RowID1(), true);

                    if TransferExtendedText.PurchCheckIfAnyExtText(PurchLine, false) then begin
                        TransferExtendedText.InsertPurchExtText(PurchLine);
                        PurchLine2.SetRange("Document Type", PurchHeader."Document Type");
                        PurchLine2.SetRange("Document No.", PurchHeader."No.");
                        if PurchLine2.FindLast() then
                            NextLineNo := PurchLine2."Line No.";
                        NextLineNo := NextLineNo + 10000;
                    end;
                    OnCodeOnAfterInsertPurchExtText(SalesLine, PurchHeader, NextLineNo);
                end;
            until SalesLine.Next() = 0
        else
            Error(
              Text000,
              SalesHeader."No.");

        OnCodeOnBeforeModify(PurchHeader, SalesHeader);

        PurchHeader.Modify(); // Only version check
        SalesHeader.Modify(); // Only version check
    end;
    //OnAfterCode(PurchHeader, SalesHeader);
    //end;

    local procedure CheckSalesLineQtyPerUnitOfMeasure()
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ResUnitofMeasure: record "Resource Unit of Measure";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckSalesLineQtyPerUnitOfMeasure(PurchHeader, SalesLine, IsHandled);
        if IsHandled then
            exit;

        if (SalesLine.Type = SalesLine.Type::Item) and ItemUnitofMeasure.Get(SalesLine."No.", SalesLine."Unit of Measure Code") then
            if SalesLine."Qty. per Unit of Measure" <> ItemUnitofMeasure."Qty. per Unit of Measure" then
                Error(Text002,
                  SalesLine.FieldCaption("Qty. per Unit of Measure"),
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine."Unit of Measure Code",
                  SalesLine."Qty. per Unit of Measure",
                  ItemUnitofMeasure."Qty. per Unit of Measure",
                  SalesLine.FieldCaption(Quantity));

        //Added Resource UOM Checking >>
        if (SalesLine.Type = SalesLine.Type::Resource) and ResUnitofMeasure.Get(SalesLine."No.", SalesLine."Unit of Measure Code") then
            if SalesLine."Qty. per Unit of Measure" <> ResUnitofMeasure."Qty. per Unit of Measure" then
                Error(Text002,
                  SalesLine.FieldCaption("Qty. per Unit of Measure"),
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine."Unit of Measure Code",
                  SalesLine."Qty. per Unit of Measure",
                  ItemUnitofMeasure."Qty. per Unit of Measure",
                  SalesLine.FieldCaption(Quantity));
        //Added Resource UOM Checking <<

    end;


    local procedure UpdateSalesLineUnitCostLCY()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateSalesLineUnitCostLCY(PurchHeader, SalesLine, IsHandled);
        if IsHandled then
            exit;

        SalesLine."Unit Cost (LCY)" := PurchLine."Unit Cost (LCY)";
        SalesLine.Validate("Unit Cost (LCY)");
    end;


    procedure GetDescription(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        Res: record Resource;
    begin
        case SalesLine.Type of
            SalesLine.Type::Item:
                begin
                    Item.Get(SalesLine."No.");

                    if GetDescriptionFromItemReference(PurchaseLine, SalesLine, Item) then
                        exit;
                    if GetDescriptionFromItemTranslation(PurchaseLine, SalesLine) then
                        exit;
                    if GetDescriptionFromSalesLine(PurchaseLine, SalesLine) then
                        exit;
                    if GetDescriptionFromItemVariant(PurchaseLine, SalesLine, Item) then
                        exit;
                    GetDescriptionFromItem(PurchaseLine, Item);

                end;
            SalesLine.Type::Resource:
                begin
                    Res.Get(SalesLine."No.");

                    //if GetDescriptionFromItemReference(PurchaseLine, SalesLine, Item) then
                    //    exit;
                    //if GetDescriptionFromItemTranslation(PurchaseLine, SalesLine) then
                    //    exit;
                    if GetDescriptionFromSalesLine(PurchaseLine, SalesLine) then
                        exit;
                    //if GetDescriptionFromItemVariant(PurchaseLine, SalesLine, Item) then
                    //    exit;
                    GetDescriptionFromRes(PurchaseLine, Res);
                end;
        end;

        //if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
        //    exit;
    end;


    local procedure GetDescriptionFromItemReference(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line"; Item: Record Item): Boolean
    var
        ItemReference: Record "Item Reference";
    begin
        if PurchHeader."Buy-from Vendor No." = '' then
            exit(false);

        exit(
            ItemReference.FindItemDescription(
                PurchaseLine.Description, PurchaseLine."Description 2", Item."No.", SalesLine."Variant Code",
                SalesLine."Unit of Measure Code", SalesLine."Posting Date", "Item Reference Type"::Vendor, PurchHeader."Buy-from Vendor No."));
    end;


    local procedure GetDescriptionFromItemTranslation(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line"): Boolean
    var
        Vend: Record Vendor;
        ItemTranslation: Record "Item Translation";
    begin
        if PurchHeader."Buy-from Vendor No." <> '' then begin
            Vend.Get(PurchHeader."Buy-from Vendor No.");
            if Vend."Language Code" <> '' then
                if ItemTranslation.Get(SalesLine."No.", SalesLine."Variant Code", Vend."Language Code") then begin
                    PurchaseLine.Description := ItemTranslation.Description;
                    PurchaseLine."Description 2" := ItemTranslation."Description 2";
                    OnGetDescriptionFromItemTranslation(PurchaseLine, ItemTranslation);
                    exit(true);
                end;
        end;
        exit(false)
    end;


    local procedure GetDescriptionFromItemVariant(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line"; Item: Record Item): Boolean
    var
        ItemVariant: Record "Item Variant";
    begin
        if SalesLine."Variant Code" <> '' then begin
            ItemVariant.Get(Item."No.", SalesLine."Variant Code");
            PurchaseLine.Description := ItemVariant.Description;
            PurchaseLine."Description 2" := ItemVariant."Description 2";
            OnGetDescriptionFromItemVariant(PurchaseLine, ItemVariant);
            exit(true);
        end;
        exit(false)
    end;


    local procedure GetDescriptionFromItem(var PurchaseLine: Record "Purchase Line"; Item: Record Item)
    begin
        PurchaseLine.Description := Item.Description;
        PurchaseLine."Description 2" := Item."Description 2";
        OnGetDescriptionFromItem(PurchaseLine, Item);
    end;


    local procedure GetDescriptionFromRes(var PurchaseLine: Record "Purchase Line"; Res: Record Resource)
    begin
        PurchaseLine.Description := Res.Name;
        PurchaseLine."Description 2" := Res."Name 2";
        OnGetDescriptionFromRes(PurchaseLine, Res);
    end;


    local procedure GetDescriptionFromSalesLine(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line"): Boolean
    begin
        if (SalesLine.Description <> '') or (SalesLine."Description 2" <> '') then begin
            PurchaseLine.Description := SalesLine.Description;
            PurchaseLine."Description 2" := SalesLine."Description 2";
            OnGetDescriptionFromSalesLine(PurchaseLine, SalesLine);
            exit(true);
        end;
        exit(false);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterCode(PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchaseLineInsert(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line"; var NextLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesLineModify(var SalesLine: Record "Sales Line"; var PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckSalesLineQtyPerUnitOfMeasure(var PurchaseHeader: Record "Purchase Header"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnBeforeCode(var PurchaseHeaderRec: Record "Purchase Header"; var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchaseLineInsert(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesLineModify(var SalesLine: Record "Sales Line"; PurchaseLine: Record "Purchase Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateSalesLineUnitCostLCY(var PurchaseHeader: Record "Purchase Header"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnAfterSalesLineSetFilters(var SalesLine: Record "Sales Line"; var PurchHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnAfterInsertPurchExtText(SalesLine: Record "Sales Line"; PurchaseHeader: Record "Purchase Header"; var NextLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnBeforeModify(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnBeforeSelectSalesHeader(var PurchaseHeader: Record "Purchase Header"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDescriptionFromItemTranslation(var PurchaseLine: Record "Purchase Line"; ItemTranslation: Record "Item Translation")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDescriptionFromItemVariant(var PurchaseLine: Record "Purchase Line"; ItemVariant: Record "Item Variant")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDescriptionFromItem(var PurchaseLine: Record "Purchase Line"; Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDescriptionFromSalesLine(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnBeforeProcessPurchaseLine(SalesLine: Record "Sales Line"; var IsHandled: Boolean; PurchHeader: Record "Purchase Header"; var NextLineNo: Integer)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnGetDescriptionFromRes(var PurchaseLine: Record "Purchase Line"; Res: Record Resource)
    begin
    end;

}
