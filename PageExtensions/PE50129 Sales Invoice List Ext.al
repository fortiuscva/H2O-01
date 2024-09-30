pageextension 50129 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    caption = 'Work Orders';

    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(Purpose; Rec.Purpose)
            {
                Caption = 'Task';
                ToolTip = 'The task for this Work Order';
                ApplicationArea = All;
            }
            field("Auto-Generated"; rec."Auto-Generated")
            {
                Caption = 'Auto-Generated';
                ToolTip = 'If checked, this work order was auto-generated from a template.';
                ApplicationArea = All;
            }
            field("Generated From Source No."; rec."Generated From Source No.")
            {
                Caption = 'Generated From Source No.';
                ToolTip = 'If auto-generated, Source Template Document No.';
                ApplicationArea = All;
            }

            field("Batch Invoice"; rec."Batch Invoice")
            {
                Caption = 'Batch Invoice';
                ToolTip = 'Indicates if the invoice is a monthly batch invoice.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Work Order Status"; rec."Work Order Status")
            {
                Caption = 'Work Order Status';
                ToolTip = 'Identifies the status of the Work Order';
                ApplicationArea = All;
            }
            field(Emergency; Rec.Emergency)
            {
                Caption = 'Emergency';
                ToolTip = 'Identifies if the work order is an emergency.';
                ApplicationArea = All;
                Editable = false;
            }
            field(Priority; Rec.Priority)
            {
                Caption = 'Priority';
                ToolTip = 'Specifies the priority of the work order.';
                ApplicationArea = All;
                Editable = false;
                StyleExpr = StatusStyleTxt;

            }
            field("Include In Batch Invoicing"; rec."Include In Batch Invoicing")
            {
                Caption = 'Include In Batch Invoicing';
                ToolTip = 'If checked, this work order is to be included in the monthly batch invoicing.';
                ApplicationArea = All;
            }
            field(Invoiced; Rec.Invoiced)
            {
                Caption = 'Invoiced';
                ToolTip = 'If checked, this work order has been invoiced, and cannot be invoiced again.';
                ApplicationArea = All;
            }
        }

        modify("No.")
        {
            StyleExpr = StyleTxt;
        }
        modify("Sell-to Customer No.")
        {
            StyleExpr = StyleTxt;
        }
        modify("Sell-to Customer Name")
        {
            StyleExpr = StyleTxt;
        }
    }


    actions
    {
        //addafter("Posted Sales Invoices")
        //{
        //    action(SalesInvLines)
        //    {
        //        ApplicationArea = All;
        //        Caption = 'Show Invoice Lines';
        //        Image = EditLines;
        //        ShortCutKey = 'Return';
        //        ToolTip = 'View or change detailed information about the customer.';
        //        RunObject = page "Sales Invoice Lines";
        //    }
        //}
    }

    var
        StyleTxt: Text;
        StatusStyleTxt: Text;




    trigger OnAfterGetRecord()
    begin
        StyleTxt := rec.SetStyle();
        StatusStyleTxt := rec.GetStatusStyleText2();
    end;
}
