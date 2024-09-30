page 50131 "Resource Template Card"
{
    ApplicationArea = all;
    Caption = 'Resource Template';
    PageType = Card;
    SourceTable = "Resource Template";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the template.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the template.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description 2 of the template.';
                }

                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series that will be used to assign numbers to Resources.';
                }
            }
            group(Resource)
            {
                Caption = 'Resource';
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the resource card represents a person or a machine';
                }
                field(Blocked; rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions.';
                }
                field("Privacy Blocked"; rec."Privacy Blocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is a person and has personal information blocked from view.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit used to measure the resource, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field("Resource Category Code"; Rec."Resource Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category that the resource belongs to. Resource categories also contain any assigned Resource attributes.';
                }
                field("Resource Group No."; rec."Resource Group No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource group that the resource belongs to. Resource categories also contain any assigned resource attributes.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor No. from whom the resource is purchased.';
                }
            }
            group(CostsAndPosting)
            {
                Caption = 'Costs & Posting';
                group(CostDetails)
                {
                    Caption = 'Cost Details';
                    field("Direct Unit Cost"; Rec."Direct Unit Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the cost of one unit of the resource on the line.';
                    }
                    field("Indirect Cost %"; Rec."Indirect Cost %")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the percentage of the resource''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the resource.';
                    }
                    field("Unit Cost"; Rec."Unit Cost")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the cost of one unit of the Resource or resource on the line.';
                    }
                }
            }
            group(PostingDetails)
            {
                Caption = 'Posting';
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource''s product type to link transactions made for this resource with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the VAT specification of the involved resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = SalesTax;
                    Importance = Promoted;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = SalesTax;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Global Dimension 1 Code.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = SalesTax;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Global Dimension 2 Code.';
                }
            }
            group(PricesAndSales)
            {
                Caption = 'Prices & Sales';
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the price of one unit of the Resource or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                /*
                field("Price/Profit Calculation"; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this Resource.';
                }
                field("Profit %"; Rec."Profit %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profit margin that you want to sell the Resource at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
                }
                */
            }
            group(TimeEntry)
            {
                Caption = 'Time Entry';
                field("Use Time Sheet"; rec."Use Time Sheet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the resource is labor and must enter time.';
                }
                field("Time Sheet Owner User ID"; rec."Time Sheet Owner User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID of the resource owner for time entry purposes.';
                }
                field("Time Sheet Approver User ID"; rec."Time Sheet Approver User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID of the resource approver for time entry purposes.';
                }
            }
        }
    }



    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(1382),
                              "No." = field(Code);
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action(CopyTemplate)
            {
                ApplicationArea = All;
                Caption = 'Copy Template';
                Image = Copy;
                ToolTip = 'Copies all information to the current template from the selected one.';

                trigger OnAction()
                var
                    ResourceTempl: Record "Resource Template";
                    ResourceTemplList: Page "Resource Template List";
                begin
                    rec.TestField(Code);
                    ResourceTempl.SetFilter(Code, '<>%1', rec.Code);
                    ResourceTemplList.LookupMode(true);
                    ResourceTemplList.SetTableView(ResourceTempl);
                    if ResourceTemplList.RunModal() = Action::LookupOK then begin
                        ResourceTemplList.GetRecord(ResourceTempl);
                        rec.CopyFromTemplate(ResourceTempl);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(CopyTemplate_Promoted; CopyTemplate)
                {
                }
                actionref(Dimensions_Promoted; Dimensions)
                {
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ResourceSetup: Record "Resources Setup";
    begin
        if rec.Code <> '' then
            exit;

        if not ResourceSetup.Get() then
            exit;


    end;

    trigger OnInit()
    begin
        InitControls();
    end;


    trigger OnOpenPage()
    begin
    end;

    var



    local procedure InitControls()
    begin
    end;


}
