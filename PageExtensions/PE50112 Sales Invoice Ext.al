pageextension 50112 "Sales Invoice Ext" extends "Sales Invoice"
{
    caption = 'Work Order';

    layout
    {
        //------------------------------------
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
                field(Comment; rec.Comment)
                {
                    caption = 'Comment';
                    ToolTip = 'Identifies there are header comments associated with this invoice.';
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
                field("Auto-Generated"; Rec."Auto-Generated")
                {
                    caption = 'Auto-Generated';
                    ToolTip = 'If checked, this work order was auto-generated from a template.';
                    ApplicationArea = All;
                }
                field("Generated From Source No."; Rec."Generated From Source No.")
                {
                    caption = 'Generated From Source No.';
                    ToolTip = 'If auto-generated, Source Template Document No.';
                    ApplicationArea = All;
                }
                field("Generated from Meter Read Opp."; Rec."Generated from Meter Read Opp.")
                {
                    caption = 'Generated From Meter Reading Opportunity';
                    ToolTip = 'If check, the work order was created as a result of reading a meter';
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
        moveafter(Interfaces; SalesLines)



        //-------------------------------------
        modify("No.")
        {
            visible = true;
        }
        modify("Work Description")
        {
            Visible = false;
        }

        addafter(Status)
        {
            field(Emergency; rec.Emergency)
            {
                caption = 'Emergency';
                ToolTip = 'Identifies if this Sales Invoice is an emergency.';
                ApplicationArea = All;
                StyleExpr = StatusStyleTxt;
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
            field(Purpose; rec.Purpose)
            {
                caption = 'Task';
                ToolTip = 'Identifies the purpose of the work order.';
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Contact")
        {
            field("No. of Archived Versions"; Rec."No. of Archived Versions")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies the number of archived versions for this document.';
            }
            field("Work Order Status"; rec."Work Order Status")
            {
                caption = 'Work Order Status';
                ToolTip = 'Specifies the status of the Work Order.';
                ApplicationArea = All;
            }
            field("Batch Invoice"; rec."Batch Invoice")
            {
                caption = 'Batch Invoice';
                ToolTip = 'If checked, this invoice is a monthly batch invoice.';
                ApplicationArea = All;
            }
            field("Include In Batch Invoicing"; rec."Include In Batch Invoicing")
            {
                caption = 'Include In Batch Invoicing';
                ToolTip = 'If checked, this invoice will be included in the monthly batch invoicing to this customer.';
                ApplicationArea = All;
            }
            field(Invoiced; rec.Invoiced)
            {
                caption = 'Invoiced';
                ToolTip = 'If checked, this invoice was posted as parted of a batch invoice and cannot be poted individually.';
                ApplicationArea = All;
            }
        }
        addafter(Control1901314507)
        {
            part(ItemInvFactBox; "Resource Invoicing FactBox")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }


    actions
    {
        addafter("Move Negative Lines")
        {
            action("Archive Document")
            {
                ApplicationArea = Suite;
                Caption = 'Archi&ve Document';
                Image = Archive;
                ToolTip = 'Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.';

                trigger OnAction()
                begin
                    ArchiveManagement.ArchiveSalesDocument(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }


    var
        StatusStyleTxt: Text;
        ArchiveManagement: Codeunit ArchiveManagement;




    trigger OnAfterGetCurrRecord()
    begin
        StatusStyleTxt := rec.GetStatusStyleText2();
    end;
}
