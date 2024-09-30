page 50153 "Select Meter Templ. List"
{
    Caption = 'Select a template for a new meter';
    PageType = List;
    SourceTable = "Meter Template";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
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
            }
        }
    }
}