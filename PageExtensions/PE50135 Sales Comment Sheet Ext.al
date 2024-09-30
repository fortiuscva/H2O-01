pageextension 50135 "Sales Comment Sheet Ext" extends "Sales Comment Sheet"
{
    layout
    {
        addafter(Code)
        {
            field("User ID"; rec."User ID")
            {
                caption = 'User ID';
                ToolTip = 'Specifies the user who created the comment line.';
                ApplicationArea = All;
            }
        }
        addafter(Date)
        {
            field("Comment Time"; rec."Comment Time")
            {
                caption = 'Time';
                ToolTip = 'Specifies the time the comment line was created.';
                ApplicationArea = All;
            }
        }
    }
}
