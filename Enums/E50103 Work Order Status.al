enum 50103 "Work Order Status"
{
    Extensible = true;

    value(0; New)
    {
        Caption = 'New';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Rejected)
    {
        caption = 'Rejected';
    }
    value(4; "Ready For Invoicing")
    {
        Caption = 'Ready For Invoicing';
    }

}
