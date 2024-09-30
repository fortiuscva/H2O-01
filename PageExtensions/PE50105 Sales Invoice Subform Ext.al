pageextension 50105 "Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        modify(Type)
        {
            ApplicationArea = All;
        }
        modify("Work Type Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify("Location Code")
        {
            ApplicationArea = All;
            Editable = true;
        }

        addbefore("Location Code")
        {
            field("Drop Shipment 2"; rec."Drop Shipment 2")
            {
                caption = 'Drop Shipment';
                ToolTip = 'Specifies whether or not the line is a drop shipment.';
                ApplicationArea = All;
            }
            field("Purchase Order No. 2"; rec."Purchase Order No. 2")
            {
                caption = 'Drop Shipment PO No.';
                ToolTip = 'Specifies the Drop Shipment Purchase Order No.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Purch. Order Line No. 2"; rec."Purch. Order Line No. 2")
            {
                caption = 'Drop Shipment PO Line No.';
                ToolTip = 'Specifies the Drop Shipment Purchase Order Line No.';
                ApplicationArea = All;
                Editable = false;
                BlankZero = true;
            }
            field(Rental; rec.Rental)
            {
                caption = 'Rental';
                ToolTip = 'Specifies whether or not the resource is a rental.';
                ApplicationArea = All;
            }
            field("Meter Activity Code"; rec."Meter Activity Code")
            {
                caption = 'Meter Activity Type';
                ToolTip = 'Specifies the value of the Meter Activity Type field.';
                ApplicationArea = All;
            }
            field("Meter Serial No."; rec."Meter Serial No.")
            {
                caption = 'Meter Serial No.';
                Tooltip = 'A lookup to the Meter Serial No.';
                ApplicationArea = all;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Rental Start Date"; rec."Rental Start Date")
            {
                caption = 'Rental Start Date';
                Tooltip = 'Specifies the start date of a rental resource period.';
                ApplicationArea = all;
            }
            field("Rental End Date"; rec."Rental End Date")
            {
                caption = 'Rental End Date';
                Tooltip = 'Specifies the end date of a rental resource period.';
                ApplicationArea = all;
            }
            field("Rental Days"; rec."Rental Days")
            {
                caption = 'Rental Days';
                Tooltip = 'Specifies the number of days the resource will be on rent.';
                ApplicationArea = all;
            }
            field("On Rent"; rec."On Rent")
            {
                caption = 'On Rent';
                Tooltip = 'Specifies if the rental resource is currently on rent.';
                ApplicationArea = all;
            }
            //field("Work Order Type Code"; rec."Work Order Type Code")
            //{
            //    caption = 'Work Order Type Code';
            //    Tooltip = 'Specifies the the Work Order Type Code.';
            //    ApplicationArea = all;
            //}
            field("Start Date"; rec."Start Date")
            {
                caption = 'Work Order Start Date';
                Tooltip = 'Specifies the Start Date of a multi-day work order.';
                ApplicationArea = all;
            }
            field("Start Time"; rec."Start Time")
            {
                caption = 'Work Order Start Time';
                Tooltip = 'Specifies the Start Time of the work order line.';
                ApplicationArea = all;
            }
            field("End Date"; rec."End Date")
            {
                caption = 'Work Order End Date';
                Tooltip = 'Specifies the End Date of a multi-day work order.';
                ApplicationArea = all;
            }
            field("End Time"; rec."End Time")
            {
                caption = 'Work Order End Time';
                Tooltip = 'Specifies the End Time of the work order line.';
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    CurrPage.update(false);
                end;
            }
            field("WO Supervisor"; rec."WO Supervisor")
            {
                caption = 'Work Order Supervisor';
                Tooltip = 'Specifies the technician''s supervisor for THIS work order.';
                ApplicationArea = all;
            }
            field("Original Document No."; rec."Original Document No.")
            {
                caption = 'Original Document No.';
                Tooltip = 'Specifies the original Work Order No.';
                ApplicationArea = all;
                //Visible = Batch;
            }
            field("Original Line No."; rec."Original Line No.")
            {
                caption = 'Original Document Line No.';
                Tooltip = 'Specifies the original Work Order Line No.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
            }
            field("Original Ship-to Code"; rec."Original Ship-to Code")
            {
                caption = 'Original Ship-to Code';
                Tooltip = 'Specifies the original Ship-to Code of the Work Order Line.';
                ApplicationArea = all;
            }
            field("Original Completed Date"; rec."Original Completed Date")
            {
                caption = 'Original Completed Date';
                Tooltip = 'Specifies the original Work Order Completed Date';
                ApplicationArea = all;
                Editable = false;
                //Visible = Batch;
            }
            field("Material Amount"; rec."Material Amount")
            {
                caption = 'Material Amount';
                Tooltip = 'Specifies the Amount of a Material line.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
            }
            field("Labor Amount"; rec."Labor Amount")
            {
                caption = 'Labor Amount';
                Tooltip = 'Specifies the Amount of a Labor line.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
            }
            field("Equipment Amount"; rec."Equipment Amount")
            {
                caption = 'Equipment Amount';
                Tooltip = 'Specifies the Amount of an Equipment line.';
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                //Visible = Batch;
            }
        }
    }



    actions
    {
        addafter(GetShipmentLines)
        {
            action("Get Batch Invoice Lines")
            {
                //AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = all;
                Caption = 'Get Batch Invoice Lines';
                Ellipsis = true;
                Image = Shipment;
                ToolTip = 'Select multiple sales orders / work orders to the same customer because you want to combine them on one invoice.';

                trigger OnAction()
                var
                    SalesHeader: record "Sales Header";
                begin
                    SalesHeader.setrange("Document Type", SalesHeader."Document Type"::Invoice);
                    SalesHeader.setrange("No.", rec."Document No.");
                    IF SalesHeader.findfirst then begin
                        IF SalesHeader.Invoiced = false then
                            GetBatchLines.GetBatchInvLines(SalesHeader);
                    end;
                end;
            }
        }
        addafter("&Line")
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action("Purchase &Order")
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header" = R;
                        ApplicationArea = Suite;
                        Caption = 'Purchase &Order';
                        Image = Document;
                        ToolTip = 'View the purchase order that is linked to the sales order, for drop shipment or special order.';

                        trigger OnAction()
                        begin
                            OpenPurchOrderForm();
                        end;
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action(OpenSpecialPurchaseOrder)
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase &Order';
                        Image = Document;
                        ToolTip = 'View the purchase order that is linked to the sales order, for drop shipment or special order.';

                        trigger OnAction()
                        begin
                            OpenSpecialPurchOrderForm();
                        end;
                    }
                }
            }
        }
    }


    var
        Batch: boolean;
        SalesHeader: record "Sales Header";
        GetBatchLines: codeunit "Get Batch Invoice Lines";



    trigger OnAfterGetCurrRecord()
    begin
        If SalesHeader.get(rec."Document Type", rec."Document No.") then
            BatchSet(SalesHeader)
    end;


    procedure BatchSet(SalesHeader: record "Sales Header")
    begin
        Batch := SalesHeader."Batch Invoice";
        CurrPage.update(false);
    end;



    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
        IsHandled: Boolean;
        PageEditable: Boolean;
    begin
        IsHandled := false;
        //OnBeforeOpenPurchOrderForm(Rec, PageEditable, IsHandled);
        if IsHandled then
            exit;

        rec.TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", rec."Purchase Order No.");
        PurchOrder.SetTableView(PurchHeader);
        PurchOrder.Editable := PageEditable;
        PurchOrder.Run();
    end;

    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
        IsHandled: Boolean;
        PageEditable: Boolean;
    begin
        IsHandled := false;
        //OnBeforeOpenSpecialPurchOrderForm(Rec, PageEditable, IsHandled);
        if IsHandled then
            exit;

        rec.TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.", rec."Special Order Purchase No.");
        if not PurchHeader.IsEmpty() then begin
            PurchOrder.SetTableView(PurchHeader);
            PurchOrder.Editable := PageEditable;
            PurchOrder.Run();
        end else begin
            PurchRcptHeader.SetRange("Order No.", rec."Special Order Purchase No.");
            if PurchRcptHeader.Count = 1 then
                PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            else
                PAGE.Run(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        end;
    end;

}
