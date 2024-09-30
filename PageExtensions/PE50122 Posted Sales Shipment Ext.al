pageextension 50122 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(content)
        {
            group(Administration)
            {
                field("Sent To Mendix"; rec."Sent To Mendix")
                {
                    caption = 'Sent To Mendix';
                    ToolTip = 'Identifies if this Sales Order has been transmitted to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix Date"; rec."Sent To Mendix Date")
                {
                    caption = 'Sent To Mendix Date';
                    ToolTip = 'Identifies the date this Sales Order has been transmitted to Mendix.';
                    ApplicationArea = All;
                }
                field("Received From Mendix"; rec."Received From Mendix")
                {
                    caption = 'Received From Mendix';
                    ToolTip = 'Identifies if this Sales Order has been received from Mendix.';
                    ApplicationArea = All;
                }
                field("Received From Mendix Date"; rec."Received From Mendix Date")
                {
                    caption = 'Received From Mendix Date';
                    ToolTip = 'Identifies the date this Sales Order has been received from Mendix.';
                    ApplicationArea = All;
                }
                field("Received From Mendix Time"; rec."Received From Mendix Time")
                {
                    caption = 'Received From Mendix Time';
                    ToolTip = 'Identifies the time this Sales Order has been received from Mendix.';
                    ApplicationArea = All;
                }
            }
            group(H2O)
            {
                field("Requested By"; rec."Requested By")
                {
                    caption = 'Requested By';
                    ToolTip = 'Identifies who is the person requesting the work order.';
                    ApplicationArea = All;
                }
                field("Completed Date"; rec."Completed Date")
                {
                    caption = 'Completed Date';
                    ToolTip = 'Identifies the date when the work order is completed.';
                    ApplicationArea = All;
                }
                field(Flushed; rec.Flushed)
                {
                    caption = 'Flushed';
                    ToolTip = 'Identifies if the service address required the lines to be flushed.';
                    ApplicationArea = All;
                }
                field("Back Charged"; rec."Back Charged")
                {
                    caption = 'Back Charged';
                    ToolTip = 'Identifies if the customer is backcharged for the work performed.';
                    ApplicationArea = All;
                }
                field("Work Order Due Date"; rec."Work Order Due Date")
                {
                    caption = 'Work Order Due Date';
                    ToolTip = 'Identifies the date the work order must be completed.';
                    ApplicationArea = All;
                }
            }
        }
        addafter(SellToEmail)
        {
            field("Include In Batch Invoicing"; rec."Include In Batch Invoicing")
            {
                caption = 'Include In Batch Invoicing';
                ToolTip = 'Identifies if this shipment should be included in the monthly batch invoicing.';
                ApplicationArea = All;
            }
            field(Invoiced; rec.Invoiced)
            {
                caption = 'Invoiced';
                ToolTip = 'Identifies if this shipment has already been invoiced via the monthly batch invoicing.';
                ApplicationArea = All;
                Editable = true;
            }
        }
        moveafter(H2O; SalesShipmLines)
    }
}