pageextension 50114 "Resource Groups Ext" extends "Resource Groups"
{
    layout
    {
        addafter(Name)
        {
            field(Rental; rec.Rental)
            {
                caption = 'Rental';
                ToolTip = 'Specifies whether the Resource Group is associated with Rentals.';
                ApplicationArea = All;
            }
        }
    }


    actions
    {
        addbefore(Statistics)
        {
            action(ResCustPr)
            {
                ApplicationArea = All;
                Caption = 'Customer Prices';
                Image = Category;
                ToolTip = 'View or edit the resource group prices by customer';
                RunObject = Page "Resource Customer Prices";
                RunPageLink = "No." = FIELD("No.");
            }
        }
    }
}
