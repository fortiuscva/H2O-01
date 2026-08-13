pageextension 50133 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addbefore(Status)
        {
            field("Work Order No."; Rec."Work Order No.")
            {
                caption = 'Work Order No.';
                ToolTip = 'Identifies the associated Work Order No.';
                ApplicationArea = All;
            }
            field("Sell-to Customer No.1"; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;
            }

        }
        moveafter(Prepayment; PurchLines)
    }


    actions
    {
        addafter(Functions_GetSalesOrder)
        {
            //Caption = 'Dr&op Shipment';
            //Image = Delivery;
            action(Functions_GetSalesInvoice)
            {
                ApplicationArea = Suite;
                Caption = 'Get &Work Order';
                Image = "Order";
                RunObject = Codeunit "Purch.-Get Drop Shpt. 2";
                ToolTip = 'Select the work order that must be linked to the purchase order, for drop shipment or special order. ';
            }
        }
    }
}
