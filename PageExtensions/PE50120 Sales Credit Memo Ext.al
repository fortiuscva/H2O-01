pageextension 50120 "Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field(Emergency; rec.Emergency)
            {
                caption = 'Emergency';
                ToolTip = 'Identifies if this Sales Invoice is an emergency.';
                ApplicationArea = All;
            }
            field(Priority; rec.Priority)
            {
                caption = 'Priority';
                ToolTip = 'Identifies the priority of the Sales Invoice.';
                ApplicationArea = All;
                StyleExpr = StatusStyleTxt;
            }
            field("Work Order Due Date"; rec."Work Order Due Date")
            {
                caption = 'Work Order Due Date';
                ToolTip = 'Identifies the date the work order must be completed.';
                ApplicationArea = All;
            }
        }
        addlast(content)
        {
            group(H2O)
            {
                field("Requested By"; rec."Requested By")
                {
                    caption = 'Requested By';
                    ToolTip = 'Identifies who is the person requesting the work order.';
                    ApplicationArea = All;
                }
                field("Field Coordinator"; rec."Field Coordinator")
                {
                    caption = 'Field Coordinator';
                    ToolTip = 'Identifies who is the person who is coordinating activities in the field.';
                    ApplicationArea = All;
                }
                field("Work Order Type Code"; rec."Work Order Type Code")
                {
                    caption = 'Work Order Type Code';
                    ToolTip = 'Specifies the Work Order Type code of the sales invoice.';
                    ApplicationArea = All;
                }
                field("Work Order Status"; rec."Work Order Status")
                {
                    caption = 'Work Order Status';
                    ToolTip = 'Specifies the status of the Work Order.';
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
                field("Material Amount"; rec."Material Amount")
                {
                    caption = 'Material Amount';
                    ToolTip = 'Identifies the sum of all the material amounts.';
                    ApplicationArea = All;
                }
                field("Labor Amount"; rec."Labor Amount")
                {
                    caption = 'Labor Amount';
                    ToolTip = 'Identifies the sum of all the labor acounts.';
                    ApplicationArea = All;
                }
                field("Equipment Amount"; rec."Equipment Amount")
                {
                    caption = 'Equipment Amount';
                    ToolTip = 'Identifies the sum of all the equipment amounts.';
                    ApplicationArea = All;
                }
            }
            group(Interfaces)
            {
                field("Must Send To Mendix"; rec."Must Send To Mendix")
                {
                    caption = 'Must Send To Mendix';
                    ToolTip = 'Identifies if this Sales Invoice must be sent to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix"; rec."Sent To Mendix")
                {
                    caption = 'Sent To Mendix';
                    ToolTip = 'Identifies if this Sales Invoice has been snet to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix Date"; rec."Sent To Mendix Date")
                {
                    caption = 'Sent To Mendix Date';
                    ToolTip = 'Identifies the date this Sales Invoice has been sent to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix Time"; rec."Sent To Mendix Time")
                {
                    caption = 'Sent To Mendix Time';
                    ToolTip = 'Identifies the time this Sales Invoice has been sent to Mendix.';
                    ApplicationArea = All;
                }
                field("Received From Mendix"; rec."Received From Mendix")
                {
                    caption = 'Received From Mendix';
                    ToolTip = 'Identifies if this Sales Invoice has been received from Mendix.';
                    ApplicationArea = All;
                }
                field("Received From Mendix Date"; rec."Received From Mendix Date")
                {
                    caption = 'Received From Mendix Date';
                    ToolTip = 'Identifies the date this Sales Invoice has been received from Mendix.';
                    ApplicationArea = All;
                }
                field("Received From Mendix Time"; rec."Received From Mendix Time")
                {
                    caption = 'Received From Mendix Time';
                    ToolTip = 'Identifies the time this Sales Invoice has been received from Mendix.';
                    ApplicationArea = All;
                }
            }
        }
        moveafter(Interfaces; saleslines)
    }


    var
        StatusStyleTxt: Text;



    trigger OnAfterGetCurrRecord()
    begin
        StatusStyleTxt := rec.GetStatusStyleText2();

    end;

}
