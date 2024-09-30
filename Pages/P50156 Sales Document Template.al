page 50156 "Sales Document Template"
{
    ApplicationArea = All;
    Caption = 'Sales Document Template';
    PageType = List;
    SourceTable = "Sales Document Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Source Document Type';
                    ToolTip = 'Specifies the value of the From Document Type field.';
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Source Document No.';
                    ToolTip = 'Specifies the value of the From Document Type field.';
                }
                field("Source Document Status"; rec."Source Document Status")
                {
                    ApplicationArea = All;
                    Caption = 'Source Document Status';
                    ToolTip = 'Source Document Status must be equal to ''Open''.';
                }
                field("Target Document Type"; Rec."Target Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Target Document Type';
                    ToolTip = 'Specifies the value of the To Document Type field.';
                }
                field("Creation Day"; Rec."Creation Day")
                {
                    ApplicationArea = All;
                    Caption = 'Creation Day';
                    ToolTip = 'Specifies the value of the Creation Day field.';
                }
                field("Last Creation Date"; Rec."Last Creation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Last Creation Date';
                    ToolTip = 'Specifies the value of the Creation Day field.';
                }
                field("Last Document No. Created"; Rec."Last Document No. Created")
                {
                    ApplicationArea = All;
                    Caption = 'Last Document No. Created';
                    ToolTip = 'Specifies the value of the Work Order created by this template.';
                }
            }
        }
    }
}
