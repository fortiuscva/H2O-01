pageextension 50136 "Res. Availability Lines Ext" extends "Res. Availability Lines"
{
    layout
    {
        addafter(Capacity)
        {
            field("Qty. on Sales Invoice"; rec."Qty. on Sales Invoice")
            {
                ApplicationArea = All;
                Caption = 'Qty. on Sales Invoice';
                DecimalPlaces = 0 : 5;
                BlankZero = true;
                ToolTip = 'Specifies the total Qty. on Sales Invoices capacity for the corresponding time period.';
            }
        }

        modify(Capacity)
        {
            BlankZero = true;
        }
        modify("Resource.""Qty. on Order (Job)""")
        {
            Visible = false;
        }
        modify("Resource.""Qty. Quoted (Job)""")
        {
            Visible = false;
        }
        modify(CapacityAfterOrders)
        {
            Visible = false;
        }
        modify(CapacityAfterQuotes)
        {
            visible = false;
        }
        modify("Resource.""Qty. on Service Order""")
        {
            Visible = false;
        }
        modify(QtyOnAssemblyOrder)
        {
            Visible = false;
        }
        modify(NetAvailability)
        {
            blankzero = true;
        }
    }
}
