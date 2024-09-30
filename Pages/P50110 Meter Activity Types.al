page 50110 "Meter Activities"
{
    ApplicationArea = All;
    Caption = 'Meter Activities';
    PageType = List;
    SourceTable = "Meter Activity";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    caption = 'Code';
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Reading; Rec.Reading)
                {
                    caption = 'Meter Reading';
                    ToolTip = 'Specifies if the activity type if for meter reading.';
                    ApplicationArea = All;
                }
                field("Requires New Meter"; rec."Requires New Meter")
                {
                    caption = 'Requires New Meter';
                    ToolTip = 'Specifies if the activity type requires a new meter.';
                    ApplicationArea = All;
                }
                field(Scrapped; Rec.Scrapped)
                {
                    caption = 'Scrapped';
                    ToolTip = 'Specifies if the activity type is to scrap a meter.';
                    ApplicationArea = All;
                }
                field(Sale; Rec.Sale)
                {
                    caption = 'Sale';
                    ToolTip = 'Specifies if the activity type is to sell a meter.';
                    ApplicationArea = All;
                }
                field("Meter Reading Opportunity"; Rec."Meter Reading Opportunity")
                {
                    caption = 'Meter Reading Opportunity';
                    ToolTip = 'Specifies if the activity type is to take advantage of Meter reading issues.';
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        MtrAct: record "Meter Activity";
}
