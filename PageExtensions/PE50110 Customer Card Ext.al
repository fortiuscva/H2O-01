pageextension 50110 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter("Customer Posting Group")
        {
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ToolTip = 'Specifies the Global Dimension 1 Code.';
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ToolTip = 'Specifies the Global Dimension 1 Code.';
                ApplicationArea = All;
            }
        }
        addafter("Invoice Disc. Code")
        {
            field("Meter Reading Day"; rec."Meter Reading Day")
            {
                caption = 'Meter Reading Day';
                ToolTip = 'Specifies the day of the month that meters will be read for this customer.';
                ApplicationArea = All;
            }
            field("Meter Reading Threshold"; rec."Meter Reading Threshold")
            {
                caption = 'Meter Reading Threshold';
                ToolTip = 'IF meter readings from one month to the next exceeds this percentage threshold, a re-read is triggered.';
                ApplicationArea = All;
            }
            field("Batch Invoice Day"; rec."Batch Invoice Day")
            {
                caption = 'Batch Invoice Day';
                ToolTip = 'Specifies the day of the month that batch invoices will be created for this customer.';
                ApplicationArea = All;
            }
            field("Opus Transmission Day"; rec."Opus Transmission Day")
            {
                caption = 'Opus Transmission Day';
                ToolTip = 'Specifies the day of the month that results will be transmitted to Opus.';
                ApplicationArea = All;
            }
            field("Min. Location Stop"; rec."Min. Location Stop")
            {
                caption = 'Min. Location Stop';
                ToolTip = 'Specifies the lowest Location Stop for this customer.';
                ApplicationArea = All;
            }
            field("Max. Location Stop"; rec."Max. Location Stop")
            {
                caption = 'Max. Location Stop';
                ToolTip = 'Specifies the highest Location Stop for this customer.';
                ApplicationArea = All;
            }

        }
        addafter(Blocked)
        {
            field("No. of Ship-to Addresses"; rec."No. of Ship-to Addresses")
            {
                caption = 'No. of Properties';
                ToolTip = 'Total number of Properties assigned to this customer.';
                ApplicationArea = All;
                //Editable = false;
            }
            field("No. of Meters"; rec."No. of Meters")
            {
                caption = 'No. of Meters';
                ToolTip = 'Total number of Meters assigned / owned by this customer.';
                ApplicationArea = All;
                //Editable = false;
            }
            field("No. of Open Work Orders"; rec."No. of Open Work Orders")
            {
                caption = 'No. of Open Work Orders';
                ToolTip = 'Total No. of Open Work Orders for this customer.';
                ApplicationArea = All;
                //Editable = false;
            }
        }
        addafter("Disable Search by Name")
        {
            field("Report ID"; rec."Report ID")
            {
                caption = 'Sales Invoice Report ID';
                ToolTip = 'Special layout of the sales invoice report.';
                ApplicationArea = All;
            }
        }
        addlast(content)
        {
            group(Interfaces)
            {
                field("Must Send To Opus"; rec."Must Send To Opus")
                {
                    caption = 'Must Send To Opus';
                    ToolTip = 'If this is checked, the customer record must be send to Opus.';
                    ApplicationArea = All;
                }
                field("Sent To Opus"; rec."Sent To Opus")
                {
                    caption = 'Sent To Opus';
                    ToolTip = 'If this is checked, the customer record was sent to Opus.';
                    ApplicationArea = All;
                }
                field("Sent To Opus Date"; rec."Sent To Opus Date")
                {
                    caption = 'Sent To Opus Date';
                    ToolTip = 'The date the customer record was sent to Opus.';
                    ApplicationArea = All;
                }
                field("Sent To Opus Time"; rec."Sent To Opus Time")
                {
                    caption = 'Sent To Opus Time';
                    ToolTip = 'The time the customer record was sent to Opus.';
                    ApplicationArea = All;
                }
                field("Must Send To Mendix"; rec."Must Send To Mendix")
                {
                    caption = 'Must Send To Mendix';
                    ToolTip = 'If this is checked, the customer record must be send to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix"; rec."Sent To Mendix")
                {
                    caption = 'Sent To Mendis';
                    ToolTip = 'If this is checked, the customer record was sent to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix Date"; rec."Sent To Mendix Date")
                {
                    caption = 'Sent To Mendix Date';
                    ToolTip = 'The date the customer record was sent to Mendix.';
                    ApplicationArea = All;
                }
                field("Sent To Mendix Time"; rec."Sent To Mendix Time")
                {
                    caption = 'Sent To Mendix Time';
                    ToolTip = 'The time the customer record was sent to Mendix.';
                    ApplicationArea = All;
                }
            }
        }
        addafter("Shipping Advice")
        {
            field("No Ship-to Name"; rec."No Ship-to Name")
            {
                caption = 'No Ship-to Name';
                ToolTip = 'If checked, this will not transfer the Customer Name to the Ship-to Name on the Ship-to Address Card.';
                ApplicationArea = All;
            }
        }

        modify("Ship-to Code")
        {
            caption = 'Service Address Code';
        }
    }


    actions
    {
        modify(ShipToAddresses)
        {
            caption = 'Service Addresses';
        }
        addafter(ShipToAddresses)
        {
            action(MeterRoutes)
            {
                ApplicationArea = All;
                Caption = 'Meter Routes';
                Image = ShipAddress;
                RunObject = Page "Meter Routes";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'View or edit Meter Routes for this customer.';
            }
            action(Meters)
            {
                ApplicationArea = All;
                Caption = 'Meters';
                Image = ShipAddress;
                RunObject = Page "Meter List";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'View or edit Meters for this customer.';
            }
        }
    }
}
