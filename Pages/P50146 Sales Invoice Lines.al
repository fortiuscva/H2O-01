page 50146 "Sales Invoice Lines"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice Lines';
    PageType = List;
    SourceTable = "Sales Line";
    //SourceTableView = WHERE("Document Type" = FILTER(Invoice));
    SourceTableView = SORTING("Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(Invoice));
    UsageCategory = Lists;
    //Editable = false;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code.';
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the number of the order.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the type of the record on the document line. ';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item or service on the line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity of items on document line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the item''s unit of measure. ';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ToolTip = 'Specifies which work type the resource applies to when the sale is related to a job.';
                }
                field(Rental; Rec.Rental)
                {
                    ToolTip = 'Specifies whether or not the resource is a rental.';
                }
                field("On Rent"; Rec."On Rent")
                {
                    ToolTip = 'Specifies if the rental resource is currently on rent.';
                }
                field("Rental Start Date"; Rec."Rental Start Date")
                {
                    ToolTip = 'Specifies the start date of a rental resource period.';
                }
                field("Rental End Date"; Rec."Rental End Date")
                {
                    ToolTip = 'Specifies the end date of a rental resource period.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price for one unit on the sales line.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including VAT fields on the associated sales lines.';
                }
                field("Material Amount"; rec."Material Amount")
                {
                    Tooltip = 'Specifies the Material Amount';
                }
                field("Labor Amount"; rec."Labor Amount")
                {
                    Tooltip = 'Specifies the Labor Amount';
                }
                field("Equipment Amount"; rec."Equipment Amount")
                {
                    Tooltip = 'Specifies the Equipment Amount';
                }

            }
        }
    }
}
