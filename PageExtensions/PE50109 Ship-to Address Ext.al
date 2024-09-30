pageextension 50109 "Ship-to Address Ext" extends "Ship-to Address"
{
    caption = 'Service Address';

    layout
    {
        modify(Code)
        {
            Caption = 'Property No.';
        }
        addbefore(Name)
        {
            field("Opus Account No."; rec."Opus Account No.")
            {
                caption = 'Opus Account No.';
                ToolTip = 'Specifies the value of the Opus Account No. field.';
                ApplicationArea = All;
            }
        }

        addafter(Name)
        {
            field("Name 2"; rec."Name 2")
            {
                caption = 'Name 2';
                ToolTip = 'Specifies the value of the Meter Activity Type field.';
                ApplicationArea = All;
            }
        }
        addafter("Tax Area Code")
        {
            field("Route No."; rec."Route No.")
            {
                caption = 'Route No.';
                ToolTip = 'Specifies the value of the Route No. field.';
                ApplicationArea = All;
            }
            field("Location Stop"; rec."Location Stop")
            {
                caption = 'Location Stop';
                ToolTip = 'Specifies the value of the Location Stop field.';
                ApplicationArea = All;
            }
            field("No. of Units"; rec."No. of Units")
            {
                caption = 'No. of Units';
                ToolTip = 'Specifies the value of the No. of Units field.';
                ApplicationArea = All;
            }
            field(Blocked; rec.Blocked)
            {
                caption = 'Blocked';
                ToolTip = 'If checked, the address is inactive.';
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
    }


    actions
    {
        addafter("&Address")
        {
            group("&Meter")
            {
                Caption = '&Meter';
                Image = Addresses;
                action("Meter")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Meter';
                    Image = ShipAddress;
                    RunObject = Page "Meter Card";
                    RunPageLink = "Customer No." = field("Customer No."), "Ship-to Code" = field(Code);
                    ToolTip = 'View the meter installed at this address.';
                }
            }
        }
    }
}



