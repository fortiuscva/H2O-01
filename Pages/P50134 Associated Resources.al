page 50134 "Associated Resources"
{
    ApplicationArea = All;
    Caption = 'Associated Resources';
    PageType = List;
    SourceTable = "Associated Resource";
    DataCaptionFields = "Resource No.";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Resource No. field.';
                    Visible = false;
                }
                field("Assoc. Type"; rec."Assoc. Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Associated Type field.';
                    Visible = true;
                }
                field("Assoc. No."; Rec."Associated No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field(Rental; rec.Rental)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies if the resource is a associated rental.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
            }
        }
    }
}
