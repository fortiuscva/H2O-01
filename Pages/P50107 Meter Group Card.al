page 50107 "Meter Group Card"
{
    ApplicationArea = All;
    Caption = 'Meter Group';
    PageType = Card;
    SourceTable = "Meter Group";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("No. of Meters Assigned"; Rec."No. of Meters Assigned")
                {
                    ToolTip = 'Specifies the value of the No. of Meters Assigned field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies whether or not comments exist for this group.';
                    ApplicationArea = All;
                }
                field("Inspection Interval Gallons"; rec."Inspection Interval Gallons")
                {
                    ApplicationArea = all;
                    Tooltip = 'Specifies the default inpection interval for this meter group.';
                    DecimalPlaces = 0 : 0;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Meter &Group")
            {
                Caption = 'Meter &Group';
                Image = Group;
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    //unObject = Page "Res. Gr. Statistics";
                    //RunPageLink = "No." = FIELD("No."),
                    //              "Date Filter" = FIELD("Date Filter"),
                    //              "Unit of Measure Filter" = FIELD("Unit of Measure Filter"),
                    //              "Chargeable Filter" = FIELD("Chargeable Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Meter Group"),
                                  "No." = FIELD("Code");
                    ToolTip = 'View or add comments for the record.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(50101),
                                      "No." = FIELD("Code");
                        ShortCutKey = 'Alt+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            MtrGr: Record "Meter Group";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(MtrGr);
                            DefaultDimMultiple.SetMultiRecord(MtrGr, rec.FieldNo("Code"));
                            DefaultDimMultiple.RunModal();
                        end;
                    }
                }
            }
        }
    }
}