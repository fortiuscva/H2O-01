page 50103 "Meter Journal Templates"
{
    ApplicationArea = All;
    Caption = 'Meter Journal Templates';
    PageType = List;
    SourceTable = "Meter Journal Template";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Posting No. Series field.';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ApplicationArea = All;
                }
                field("Page ID"; Rec."Page ID")
                {
                    ToolTip = 'Specifies the value of the Page ID field.';
                    ApplicationArea = All;
                }
                field("Page Caption"; Rec."Page Caption")
                {
                    ToolTip = 'Specifies the value of the Page Caption field.';
                    ApplicationArea = All;
                }
                field("Posting Report ID"; Rec."Posting Report ID")
                {
                    ToolTip = 'Specifies the value of the Posting Report ID field.';
                    ApplicationArea = All;
                }
                field("Posting Report Caption"; Rec."Posting Report Caption")
                {
                    ToolTip = 'Specifies the value of the Posting Report Caption field.';
                    ApplicationArea = All;
                }
                field("Force Posting Report"; Rec."Force Posting Report")
                {
                    ToolTip = 'Specifies the value of the Force Posting Report field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action(Batches)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Meter Journal Batches";
                    RunPageLink = "Journal Template Name" = FIELD(Name);
                    ToolTip = 'View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.';
                    Scope = Repeater;
                }
            }
        }
    }
}
