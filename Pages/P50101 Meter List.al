page 50101 "Meter List"
{
    ApplicationArea = All;
    Caption = 'Meters';
    PageType = List;
    SourceTable = Meter;
    CardPageId = "Meter Card";
    Editable = false;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    caption = 'Property No.';
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.';
                    ApplicationArea = All;
                }
                field("Route No."; rec."Route No.")
                {
                    ToolTip = 'Specifies the value of the Route No. field.';
                    ApplicationArea = All;
                }
                field("Location Stop"; rec."Location Stop")
                {
                    ToolTip = 'Specifies the value of the Location Stop field.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = All;
                }
                field("Customer Owned"; Rec."Customer Owned")
                {
                    ToolTip = 'Specifies the value of the Customer Owned field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Must Send To Opus"; rec."Must Send To Opus")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies if the record must be sent to Opus.';
                }
                field("Must Send To Mendix"; rec."Must Send To Mendix")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies if the record must be sent to Mendix.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Meter")
            {
                Caption = '&Meter';
                Image = Resource;
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    //RunObject = Page "Resource Statistics";
                    //RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Meter),
                                  "No." = FIELD("No.");
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
                                      "No." = FIELD("No.");
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
                            Mtr: Record Meter;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Mtr);
                            DefaultDimMultiple.SetMultiRecord(Mtr, rec.FieldNo("No."));
                            DefaultDimMultiple.RunModal();
                        end;
                    }
                }
                action("&Picture")
                {
                    ApplicationArea = All;
                    Caption = '&Picture';
                    Image = Picture;
                    //RunObject = Page "Resource Picture";
                    //RunPageLink = "No." = FIELD("No.");
                    ToolTip = 'View or add a picture of the resource or, for example, the company''s logo.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    RunObject = Page "Meter Ledger Entries";
                    RunPageLink = "Meter No." = FIELD("No.");
                    RunPageView = SORTING("Meter No.")
                                  ORDER(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("E&xtended Texts")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xtended Texts';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = CONST(Meter),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    ToolTip = 'View the extended description that is set up.';
                }
            }
        }
        area("Processing")
        {
            group("Export Meters")
            {
                action("Send Meters To Opus")
                {
                    caption = 'Send Meters to Opus';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50104, false, false);
                    end;
                }
                action("Send Meters To Mendix")
                {
                    caption = 'Send Meters to Mendix';
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        Xmlport.Run(50105, false, false);
                    end;
                }
            }
        }
    }
}