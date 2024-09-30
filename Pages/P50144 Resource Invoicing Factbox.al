page 50144 "Resource invoicing Factbox"
{
    Caption = 'Resource Details - Invoicing';
    PageType = CardPart;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'Resource No.';
                ToolTip = 'Specifies the number of the resource.';

                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }
            /*
            field("Costing Method"; Rec."Costing Method")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';
            }
            field("Cost is Adjusted"; Rec."Cost is Adjusted")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies whether the item''s unit cost has been adjusted, either automatically or manually.';
            }
            field("Cost is Posted to G/L"; Rec."Cost is Posted to G/L")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies that all the inventory costs for this item have been posted to the general ledger.';
            }
            field("Standard Cost"; Rec."Standard Cost")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';
            }
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
            }
            field("Overhead Rate"; Rec."Overhead Rate")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the item''s indirect cost as an absolute amount.';
            }
            field("Indirect Cost %"; Rec."Indirect Cost %")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
            }
            field("Last Direct Cost"; Rec."Last Direct Cost")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the most recent direct unit cost of the item.';
            }
            field("Profit %"; Rec."Profit %")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
            }
            */
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the price of one unit of the resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
            }
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the cost of one unit of the resource. You can enter a cost manually or have it entered according to the Price/Profit Calculation field on the related card.';
            }
            field(Supervisor; Rec.Supervisor)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the supervisor of the person resource.';
            }
            field(Rental; Rec.Rental)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the resource is a rental resource.';
            }
            field("Associated Resources"; Rec."Associated Resources")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the resource has additional associated resources.';
            }
            field("Fixed Asset No."; Rec."Fixed Asset No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the rental resource is tied to a fixed asset.';
            }
        }
    }

    actions
    {
    }

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Resource Card", Rec);
    end;

}