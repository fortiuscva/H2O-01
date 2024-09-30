codeunit 50110 Subscribers
{
    trigger OnRun()
    begin
    end;


    //To add Ship-to Address and Meter flag to Item Ledger Entry
    [EventSubscriber(ObjectType::codeunit, codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    PROCEDURE OnAfterInitItemLedgEntry(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: record "Item Journal Line"; ItemLedgEntryNo: integer)
    BEGIN
        NewItemLedgEntry."Source Sub No." := ItemJournalLine."Source Sub No.";
        NewItemLedgEntry.Meter := ItemJournalLine.Meter;
        NewItemLedgEntry."EID No." := ItemJournalLine."EID No.";
    END;


    //To add Meter flag to sales line from item master
    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
    PROCEDURE OnAfterAssignItemValues(VAR SalesLine: Record "Sales Line"; Item: record Item; SalesHeader: record "Sales Header")
    BEGIN
        SalesLine.Meter := Item.Meter;
    END;


    //To add Meter, Ship-to Code and Meter Activity Code from Sales Line to Item Journal Line.
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnBeforeItemJnlPostLine', '', true, true)]
    PROCEDURE OnBeforeItemJnlPostLine(VAR ItemJournalLine: Record "Item Journal Line"; SalesLine: record "Sales Line"; SalesHeader: record "Sales Header";
        CommitIsSuppressed: Boolean; IsHandled: Boolean; TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary)
    BEGIN
        ItemJournalLine.Meter := SalesLine.Meter;
        ItemJournalLine."Source Sub No." := SalesHeader."Ship-to Code";
        ItemJournalLine."Meter Activity Code" := SalesLine."Meter Activity Code";
    END;


    //To add Resource Rental fields from Sales Line to Resource Journal Line
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnPostResJnlLineOnAfterInit', '', true, true)]
    procedure OnPostResJnlLineOnAfterInit(var ResJnlLine: Record "Res. Journal Line"; var SalesLine: Record "Sales Line")
    begin
        ResJnlLine.Rental := SalesLine.Rental;
        ResJnlLine."On Rent" := SalesLine."On Rent";
        ResJnlLine."Rental Start Date" := SalesLine."Rental Start Date";
        ResJnlLine."Rental End Date" := SalesLine."Rental End Date";
        ResJnlLine."Rental Days" := SalesLine."Rental Days";
        IF ResJnlLine."On Rent" then
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Rent;
    end;


    //To add Meter flag from Item master to Item Journal Line for non "meter reading" sales activity
    [EventSubscriber(ObjectType::table, database::"Item Journal Line", 'OnValidateItemNoOnAfterGetItem', '', true, true)]
    PROCEDURE OnValidateItemNoOnAfterGetItem(VAR ItemJournalLine: Record "Item Journal Line"; Item: record Item)
    BEGIN
        ItemJournalLine.Meter := Item.Meter;
    END;


    //Upon releasing sales document, checks to see if the Ship-to Code is required from Meter Setup.
    [EventSubscriber(ObjectType::codeunit, codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    PROCEDURE OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; SkipCheckReleaseRestrictions: Boolean)
    var
        MtrSetup: record "Meter Setup";
        SalesLine: record "Sales Line";
        GLSetup: record "General Ledger Setup";
        Text001: TextConst ENU = 'Task cannot be blank.';
        Text002: TextConst ENU = 'Ship-to Code cannot be blank on the header.';
        Text003: TextConst ENU = 'Ship-to Code cannot be blank on Line No. %1.';
        Text004: TextConst ENU = 'For all sales orders, Batch Invoice must be checked.';
        Text005: TextConst ENU = 'District Code cannot be blank in Sales Header.';
        Text006: TextConst ENU = 'Revenue Type Code cannot be blank in Sales Header.';
        Text007: TextConst ENU = 'District Code cannot be blank on Line No. %1.';
        Text008: TextConst ENU = 'Revenue Type Code cannot be blank on Line No. %1.';

    BEGIN
        MtrSetup.get;
        GLSetup.get;

        //for sales quotes
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) then begin
            If SalesHeader.Purpose = '' then
                error(Text001);
        end;

        //for sales orders
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            If SalesHeader.Purpose = '' then
                error(Text001);

            If SalesHeader."Batch Invoice" = false then
                error(Text004);

            IF MtrSetup."Req. Ship-to Code Sale" then
                If SalesHeader."Ship-to Code" = '' then
                    error(Text002);

            IF GLSetup."Global Dim. 1 Code Required" then begin
                IF SalesHeader."Shortcut Dimension 1 Code" = '' then
                    error(Text005);

                SalesLine.reset;
                SalesLine.setrange("Document No.", SalesHeader."No.");
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                IF SalesLine.findset then
                    repeat
                        IF SalesLine."Shortcut Dimension 1 Code" = '' then
                            error(Text007, SalesLine."Line No.");
                    until SalesLine.next = 0;
            end;

            IF GLSetup."Global Dim. 2 Code Required" then begin
                IF SalesHeader."Shortcut Dimension 2 Code" = '' then
                    error(Text006);

                SalesLine.reset;
                SalesLine.setrange("Document No.", SalesHeader."No.");
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                IF SalesLine.findset then
                    repeat
                        IF SalesLine."Shortcut Dimension 2 Code" = '' then
                            error(Text008, SalesLine."Line No.");
                    until SalesLine.next = 0;
            end;
        end;

        //for sales invoices
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
            If SalesHeader.Purpose = '' then
                error(Text001);

            //If SalesHeader."Batch Invoice" = false then
            //    error(Text004);

            IF MtrSetup."Req. Ship-to Code Inv" then
                If SalesHeader."Ship-to Code" = '' then
                    error(Text002);

            IF GLSetup."Global Dim. 1 Code Required" then begin
                IF SalesHeader."Shortcut Dimension 1 Code" = '' then
                    error(Text005);

                SalesLine.reset;
                SalesLine.setrange("Document No.", SalesHeader."No.");
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                IF SalesLine.findset then
                    repeat
                        IF SalesHeader."Shortcut Dimension 1 Code" = '' then
                            error(Text007, SalesLine."Line No.");
                    until SalesLine.next = 0;
            end;

            IF GLSetup."Global Dim. 2 Code Required" then begin
                IF SalesHeader."Shortcut Dimension 2 Code" = '' then
                    error(Text006);

                SalesLine.reset;
                SalesLine.setrange("Document No.", SalesHeader."No.");
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                IF SalesLine.findset then
                    repeat
                        IF SalesHeader."Shortcut Dimension 2 Code" = '' then
                            error(Text008, SalesLine."Line No.");
                    until SalesLine.next = 0;
            end;
        end;
    end;



    //To move custom fields from Sales Line to Sales Invoice Line
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', true, true)]
    procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; PostingSalesLine: Record "Sales Line"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; var ReturnReceiptHeader: Record "Return Receipt Header")
    begin
        SalesInvLine."Meter Activity Code" := SalesLine."Meter Activity Code";
        SalesInvLine.Rental := SalesLine.Rental;
        SalesInvLine."On Rent" := SalesLine."On Rent";
        SalesInvLine."Rental Start Date" := SalesLine."Rental Start Date";
        SalesInvLine."Rental End Date" := SalesLine."Rental End Date";
        SalesInvLine."Material Amount" := SalesLine."Material Amount";
        SalesInvLine."Equipment Amount" := SalesLine."Equipment Amount";
        SalesInvLine."Labor Amount" := SalesLine."Labor Amount";
        SalesInvLine."Location Comment" := SalesLine."Location Comment";
    end;


    //To move custom fields from Sales Line to Sales Credit Memo Line
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnBeforeSalesCrMemoLineInsert', '', true, true)]
    procedure OnBeforeSalesCrMemoLineInsert(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header"; var ReturnRcptHeader: Record "Return Receipt Header"; var PostingSalesLine: Record "Sales Line")
    begin
        SalesCrMemoLine."Meter Activity Code" := SalesLine."Meter Activity Code";
        SalesCrMemoLine.Rental := SalesLine.Rental;
        SalesCrMemoLine."On Rent" := SalesLine."On Rent";
        SalesCrMemoLine."Rental Start Date" := SalesLine."Rental Start Date";
        SalesCrMemoLine."Rental End Date" := SalesLine."Rental End Date";
        SalesCrMemoLine."Material Amount" := SalesLine."Material Amount";
        SalesCrMemoLine."Equipment Amount" := SalesLine."Equipment Amount";
        SalesCrMemoLine."Labor Amount" := SalesLine."Labor Amount";
        SalesCrMemoLine."Location Comment" := SalesLine."Location Comment";
    end;


    //To move custom fields from Sales Line to Sales Shipment Line
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', true, true)]
    procedure OnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; ItemLedgShptEntryNo: Integer; xSalesLine: record "Sales Line"; var TempSalesLineGlobal: record "Sales Line" temporary; var IsHandled: Boolean)
    begin
        SalesShptLine."Meter Activity Code" := SalesLine."Meter Activity Code";
        SalesShptLine.Rental := SalesLine.Rental;
        SalesShptLine."On Rent" := SalesLine."On Rent";
        SalesShptLine."Rental Start Date" := SalesLine."Rental Start Date";
        SalesShptLine."Rental End Date" := SalesLine."Rental End Date";
        SalesShptLine."Material Amount" := SalesLine."Material Amount";
        SalesShptLine."Equipment Amount" := SalesLine."Equipment Amount";
        SalesShptLine."Labor Amount" := SalesLine."Labor Amount";
        SalesShptLine."Location Comment" := SalesLine."Location Comment";
    end;


    //To create Meter Journal Line from Sales Header and Sales Line
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', true, true)]
    procedure OnRunOnBeforeFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; GenJnlLineExtDocNo: Code[35]; var EverythingInvoiced: Boolean; GenJnlLineDocNo: Code[20]; SrcCode: Code[10])
    var
        SalesLine: record "Sales Line";
        SalesInvHeader: record "Sales Invoice Header";
        SalesInvLine: record "Sales Invoice Line";
        MtrJnlLine: record "Meter Journal Line";
        MtrSetup: record "Meter Setup";
        Mtr: record Meter;
        LineNo: integer;
        IsHandled: Boolean;
        MtrJnlPostLine: codeunit "Meter Jnl.-Post Line";
    begin
        //SalesLine.reset;
        //SalesLine.setrange("Document Type", SalesHeader."Document Type");
        //SalesLine.setrange("Document No.", SalesHeader."No.");

        If SalesInvHeader.get(SalesInvoiceHeader."No.") then begin
            SalesInvLine.reset;
            SalesInvLine.setrange("Document No.", SalesInvHeader."No.");
            SalesInvLine.setrange(Type, SalesInvLine.type::Meter);
            SalesInvLine.setfilter(Quantity, '<>%1', 0);
            If SalesInvLine.findset then begin
                LineNo := 10000;
                MtrJnlLine.DeleteAll;
                MtrJnlLine.LockTable;
                SalesInvLine.calcfields("Meter Serial No.");
                repeat
                    MtrJnlLine.init;

                    MtrSetup.get;
                    MtrJnlLine."Journal Template Name" := MtrSetup."Def. Jnl Templ. for Mtr Read";
                    MtrJnlLine."Journal Batch Name" := MtrSetup."Def. Jnl Batch for Mtr Read";

                    MtrJnlLine."Line No." := LineNo;
                    MtrJnlLine."Posting Date" := SalesInvHeader."Posting Date";
                    MtrJnlLine."Document Date" := SalesInvHeader."Document Date";
                    MtrJnlLine."Document No." := SalesInvHeader."No.";
                    MtrJnlLine."External Document No." := SalesInvHeader."External Document No.";
                    MtrJnlLine."Customer No." := SalesInvHeader."Sell-to Customer No.";
                    //MtrJnlLine."Ship-to Code" := SalesInvHeader."Ship-to Code";
                    MtrJnlLine."Source Code" := SalesInvHeader."Source Code";

                    MtrJnlLine."Meter No." := SalesInvLine."No.";
                    MtrJnlLine.Description := SalesInvLine.Description;
                    MtrJnlLine."Description 2" := SalesInvLine."Description 2";
                    MtrJnlLine."Serial No." := SalesInvLine."Meter Serial No.";
                    MtrJnlLine."Meter Activity Code" := SalesInvLine."Meter Activity Code";
                    MtrJnlLine."Shortcut Dimension 1 Code" := SalesInvLine."Shortcut Dimension 1 Code";
                    MtrJnlLine."Shortcut Dimension 2 Code" := SalesInvLine."Shortcut Dimension 2 Code";
                    MtrJnlLine."Dimension Set ID" := SalesInvLine."Dimension Set ID";
                    MtrJnlLine."Gen. Prod. Posting Group" := SalesInvLine."Gen. Prod. Posting Group";
                    MtrJnlLine."Ship-to Code" := SalesInvLine."Original Ship-to Code";

                    MtrJnlLine.insert(true);

                    If Mtr.get(SalesInvLine."No.") then begin
                        Mtr.validate("Customer No.", SalesInvHeader."Sell-to Customer No.");
                        Mtr.validate("Ship-to Code", SalesInvLine."Original Ship-to Code");
                        Mtr.modify;
                    end;

                    LineNo += 10000;

                    //IsHandled := false;
                    //if IsHandled then
                    //    exit
                    //else
                    MtrJnlPostLine.RunWithCheck(MtrJnlLine);

                until SalesInvLine.next = 0;
            end;
        end;
    end;


    //To Include Meters in Find Ledger Entries Navigate functions
    [EventSubscriber(ObjectType::page, page::Navigate, 'OnAfterFindLedgerEntries', '', true, true)]
    procedure OnAfterFindLedgerEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    var
        IsHandled: Boolean;
        Nav: page Navigate;
    begin
        if MtrLedgEntry.ReadPermission() and (not IsHandled) then begin
            MtrLedgEntry.Reset();
            MtrLedgEntry.SetCurrentKey("Document No.", "Posting Date");
            MtrLedgEntry.SetFilter("Document No.", DocNoFilter);
            MtrLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            MtrLedgEntry.SetFilter("External Document No.", ExtDocNo);
            Nav.InsertIntoDocEntry2(DocumentEntry, DATABASE::"Meter Ledger Entry", MtrLedgEntry.TableCaption(), MtrLedgEntry.Count);
        end;
    end;


    //To include Meters in Show Records Navigate function
    [EventSubscriber(ObjectType::page, page::Navigate, 'OnAfterNavigateShowRecords', '', true, true)]
    procedure OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ExtDocNo: Code[250])
    var
        MeterLedgEntry: record "Meter Ledger Entry";
    begin
        case TempDocumentEntry."Table ID" of
            DATABASE::"Meter Ledger Entry":
                begin
                    MeterLedgEntry.reset;
                    MeterLedgEntry.setrange("Document No.", DocNoFilter);
                    MeterLedgEntry.setfilter("Posting Date", PostingDateFilter);
                    PAGE.Run(0, MeterLedgEntry);
                end;
        end;

    end;


    //To post custom resource fields from resource journal to resouce ledger.
    [EventSubscriber(ObjectType::table, database::"Res. Ledger Entry", 'OnAfterCopyFromResJnlLine', '', true, true)]
    procedure OnAfterCopyFromResJnlLine(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    begin
        ResLedgerEntry."Entry Type" := ResJournalLine."Entry Type";
        ResLedgerEntry.Rental := ResJournalLine.Rental;
        ResLedgerEntry."On Rent" := ResJournalLine."On Rent";
        ResLedgerEntry."Rental Start Date" := ResJournalLine."Rental Start Date";
        ResLedgerEntry."Rental End Date" := ResJournalLine."Rental End Date";
        ResLedgerEntry."Rental Days" := ResJournalLine."Rental Days";
    end;


    //checks if the work order or sales order has been previously invoiced
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    var
        Text001: TextConst ENU = 'Sales Order %1 was already posted as part of a batch invoice and cannot be posted individually.';
        Text002: TextConst ENU = 'Work Order %1 was already posted as part of a batch invoice and cannot be posted individually.';
        Text003: TextConst ENU = 'Sales Order Status is not Ready For Invoicing for Sales Order %1.';
        Text004: TextConst ENU = 'Sales Orders cannot be invoiced from here. They must be pulled into the monthly batch invoice and invoiced from there.';
        Text005: TextConst ENU = 'Work Order Status is not Ready For Invoicing for Work Order %1.';


    begin
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and
            (SalesHeader.Invoiced = true) then
            error(Text001, SalesHeader."No.");

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) AND
            (SalesHeader.Invoiced = true) then
            error(Text002, SalesHeader."No.");

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and
            (SalesHeader."Work Order Status" <> SalesHeader."Work Order Status"::"Ready For Invoicing") then
            error(Text003, SalesHeader."No.");

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) and
            (SalesHeader."Work Order Status" <> SalesHeader."Work Order Status"::"Ready For Invoicing") and
            (SalesHeader."Include In Batch Invoicing" = true) then
            error(Text005, SalesHeader."No.");

        //IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and
        //    (SalesHeader.Invoice = true) and (SalesHeader."Include In Batch Invoicing" = true) then
        //    error(Text004, SalesHeader."No.");
    end;


    //If the sales invoice is reopened, set the work order status back to Completed
    [EventSubscriber(ObjectType::codeunit, codeunit::"Release Sales Document", 'OnBeforeManualReOpenSalesDoc', '', true, true)]
    procedure OnBeforeManualReOpenSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        If (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then
            If SalesHeader."Work Order Status" = SalesHeader."Work Order Status"::"Ready For Invoicing" then
                SalesHeader.validate("Work Order Status", SalesHeader."Work Order Status"::Completed);
    end;


    //Calculates Qty. on Sales Invoice for Resource Availabitlity
    [EventSubscriber(ObjectType::page, page::"Res. Availability Lines", 'OnAfterCalcLine', '', true, true)]
    procedure OnAfterCalcLine(var Resource: Record Resource; var CapacityAfterOrders: Decimal; var CapacityAfterQuotes: Decimal; var NetAvailability: Decimal; var ResAvailabilityBuffer: Record "Res. Availability Buffer")
    begin
        Resource.CalcFields(Capacity, "Qty. on Sales Invoice");
        NetAvailability := Resource.Capacity - Resource."Qty. on Sales Invoice";
        ResAvailabilityBuffer."Qty. on Sales Invoice" := Resource."Qty. on Sales Invoice";
        ResAvailabilityBuffer."Net Availability" := NetAvailability;
    end;



    //run after meter sales shipment, once ILE has been updated to run Create Meters report
    [EventSubscriber(ObjectType::codeunit, codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', true, true)]
    procedure OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer; GlobalValueEntry: Record "Value Entry"; TransferItem: Boolean; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; var OldItemLedgerEntry: Record "Item Ledger Entry")
    var
        CreateMeters: report "Create Meters";
        IsHandled: boolean;
    begin
        IF IsHandled then
            exit;

        IF IsHandled = false then begin
            IF (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale) OR
            (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Negative Adjmt.") then
                if ItemLedgerEntry.meter then begin
                    CreateMeters.SetManual((false));
                    CreateMeters.runmodal;
                end;
            IsHandled := true;
        end;
    end;


    //Add EID No. to Serial No. Information
    [EventSubscriber(ObjectType::codeunit, codeunit::"Item Tracking Management", 'OnAfterCreateSNInformation', '', true, true)]
    procedure OnAfterCreateSNInformation(var SerialNoInfo: Record "Serial No. Information"; TrackingSpecification: Record "Tracking Specification")
    begin
        SerialNoInfo.Validate("EID No.", TrackingSpecification."EID No.");
        SerialNoInfo.modify;
    end;


    //Copy EID No. from Item Journal Line to Item Ledger Entry
    [EventSubscriber(ObjectType::codeunit, codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', true, true)]
    procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
    begin
        ItemLedgerEntry."EID No." := ItemJournalLine."EID No.";
    end;



    [EventSubscriber(ObjectType::table, database::"Sales Invoice Header", 'OnBeforePrintRecords', '', true, true)]
    procedure OnBeforePrintRecords(var ReportSelections: Record "Report Selections"; var SalesInvoiceHeader: Record "Sales Invoice Header"; ShowRequestPage: Boolean; var IsHandled: Boolean)
    begin
        SelectionDialog(ReportSelections);
        //IsHandled := true;
    end;


    //bypass checking the quantity to ship, because the shipment occurred earlier with the SO was shipped
    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnTestSalesLineOnBeforeTestFieldQtyToShip', '', true, true)]
    local procedure OnTestSalesLineOnBeforeTestFieldQtyToShip(SalesLine: Record "Sales Line"; var ShouldTestQtyToShip: Boolean)
    begin
        ShouldTestQtyToShip := false;
    end;


    //added this so the quantities shipped are not checked 
    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnBeforeCheckNotInvoicedQty', '', true, true)]
    local procedure OnBeforeCheckNotInvoicedQty(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;



    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnPostItemTrackingForShipmentOnBeforeShipmentInvoiceErr', '', true, true)]
    local procedure OnPostItemTrackingForShipmentOnBeforeShipmentInvoiceErr(SalesLine: Record "Sales Line"; var IsHandled: Boolean; SalesHeader: Record "Sales Header"; var ItemJnlRollRndg: Boolean; TrackingSpecificationExists: Boolean; var TempTrackingSpecification: Record "Tracking Specification" temporary; var RemQtyToBeInvoiced: Decimal; var RemQtyToBeInvoicedBase: Decimal)
    begin
        IsHandled := true;
    end;



    [EventSubscriber(ObjectType::codeunit, codeunit::"Sales-Post", 'OnBeforePostItemTrackingCheckShipment', '', true, true)]
    local procedure OnBeforePostItemTrackingCheckShipment(SalesLine: Record "Sales Line"; RemQtyToBeInvoiced: Decimal; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;




    //when the print button is clicked on Posted Sales Invoic, pop up a string menu dialog
    local procedure SelectionDialog(VAR ReportSelections: record "Report Selections");
    var
        Cust: record customer;
        OptionStr: text;
        Selection: integer;
        x: integer;
    begin
        OptionStr := '';

        ReportSelections.setrange(Usage, ReportSelections.Usage::"S.Invoice");
        If ReportSelections.findset then
            If ReportSelections.count < 2 then
                exit
            else
                repeat
                    ReportSelections.calcfields("Report Caption");
                    OptionStr += ReportSelections.sequence + ' ' + ReportSelections."Report caption" + ',';
                until ReportSelections.next = 0;

        Selection := StrMenu(OptionStr, 1);
        If Selection = 0 then
            error('');

        ReportSelections.findfirst;
        For x := 2 to Selection do begin
            ReportSelections.next;
        end;

        ReportSelections.setrange(Sequence, ReportSelections.Sequence);
    end;





    var
        //MtrJnlPostLine: codeunit "Meter Jnl.-Post Line";
        MtrLedgEntry: record "Meter Ledger Entry";
        ExtDocNo: text;
}