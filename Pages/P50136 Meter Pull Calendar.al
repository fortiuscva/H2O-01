page 50136 "Meter Pull Calendar"
{
    ApplicationArea = All;
    Caption = 'Meter Reading Pull Calendar';
    PageType = List;
    SourceTable = "Meter Reading Pull Calendar";
    UsageCategory = Administration;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field(Name; rec.Name)
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    ApplicationArea = All;
                }
                field("Pull Date"; rec."Pull Date")
                {
                    Caption = 'Pull Date';
                    ToolTip = 'Specifies the value of the Pull Date field.';
                    ApplicationArea = All;
                }
                field("Pull Day"; rec."Pull Day")
                {
                    Caption = 'Pull Day';
                    ToolTip = 'Specifies the value of the Pull Day field.';
                    ApplicationArea = All;
                }
                field(Pulled; rec.Pulled)
                {
                    Caption = 'Pulled';
                    ToolTip = 'Specifies the value of the Pulled field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
