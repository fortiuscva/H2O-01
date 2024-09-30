pageextension 50138 "Business Mgr Role Center Ext" extends "Business Manager Role Center"
{
    actions
    {
        modify("Sales Invoice")
        {
            caption = 'Work Order';
        }

        addlast(Sections)
        {
            group(Meters)
            {
                group(Meter)
                {
                    caption = 'Meters';
                    action("Meter List")
                    {
                        Caption = 'Meters';
                        image = List;
                        RunObject = page "Meter List";
                        ApplicationArea = All;
                    }
                    action("Meter Group List")
                    {
                        Caption = 'Groups';
                        image = List;
                        RunObject = page "Meter Groups";
                        ApplicationArea = All;
                    }
                    action("Meter Prices")
                    {
                        Caption = 'Prices';
                        image = List;
                        RunObject = page "Meter Prices";
                        ApplicationArea = All;
                    }
                    action("Meter Routes")
                    {
                        Caption = 'Reading Routes';
                        image = List;
                        RunObject = page "Meter Reading Routes";
                        ApplicationArea = All;
                    }
                    action("Meter Read Opportunities")
                    {
                        Caption = 'Reading Opportunties';
                        image = List;
                        RunObject = page "Meter Read Opportunities";
                        ApplicationArea = All;
                    }

                }

                // Creates a sub-menu
                group("Meter History")
                {
                    caption = 'History';
                    action("Meter Ledger Entries")
                    {
                        caption = 'Ledger Entries';
                        RunObject = page "Meter Ledger Entries";
                        ApplicationArea = All;
                    }
                    action("Meter Registers")
                    {
                        caption = 'Registers';
                        RunObject = page "Meter Registers";
                        ApplicationArea = All;
                    }
                }

                // Creates a sub-menu
                group("Mtr Journals")
                {
                    caption = 'Meter Journals';
                    action("Meter Journal Template")
                    {
                        caption = 'Journal Templates';
                        ApplicationArea = All;
                        RunObject = page "Meter Journal Templates";
                    }
                    action("Meter Journal Batch")
                    {
                        caption = 'Journal Batches';
                        ApplicationArea = All;
                        RunObject = page "Meter Journal Batches";
                    }
                    action("Meter Journal")
                    {
                        caption = 'Journals';
                        ApplicationArea = All;
                        RunObject = page "Meter Journal";
                    }
                }

                //Create Submenu
                group(Action)
                {
                    caption = 'Actions';
                    action("Meters To Opus")
                    {
                        caption = 'Transmit Meters To Opus';
                        RunObject = xmlport "Meters to Opus";
                        ApplicationArea = All;
                    }
                    action("Meters To Mendix")
                    {
                        caption = 'Transmit Meters To Mendix';
                        RunObject = xmlport "Meters to Mendix";
                        ApplicationArea = All;
                    }
                    action("Create Calendar")
                    {
                        caption = 'Create H2O Calendar';
                        runobject = page "Meter Read Opportunities";
                        ApplicationArea = all;
                    }

                    action("Create Meter Read")
                    {
                        caption = 'Create Meter Read Opportunities';
                        runobject = page "Meter Read Opportunities";
                        ApplicationArea = all;
                    }
                    action("Create (Sold) Meters")
                    {
                        caption = 'Create (Sold) Meters';
                        ApplicationArea = All;
                        RunObject = report "Create Meters";
                        Ellipsis = true;
                    }
                    action("Create Meter Routes")
                    {
                        Caption = 'Create Meter Routes';
                        Image = Report;
                        RunObject = report "Create Meter Reading Routes";
                        ApplicationArea = All;
                    }
                }

                group(Setup)
                {
                    caption = 'Setup';
                    action("Meter Setup")
                    {
                        caption = 'Meter Setup';
                        ApplicationArea = All;
                        RunObject = page "Meter Setup";
                    }
                    action("Meter Activities")
                    {
                        caption = 'Meter Activities';
                        ApplicationArea = All;
                        RunObject = page "Meter Activities";
                    }
                    action("Meter Pull Calendar")
                    {
                        caption = 'Meter Pull Calendar';
                        ApplicationArea = All;
                        RunObject = page "Meter Pull Calendar";
                    }
                    action("Work Order Types")
                    {
                        caption = 'Work Order Types';
                        ApplicationArea = All;
                        RunObject = page "Work Order Types";
                    }
                    action("Meter Service Address Classes")
                    {
                        caption = 'Meter Service Address Classes';
                        ApplicationArea = All;
                        RunObject = page "Meter Service Address Classes";
                    }
                    action("Meter Manufacturers")
                    {
                        caption = 'Meter Manufacturers';
                        ApplicationArea = All;
                        RunObject = page "Meter Manufacturers";
                    }
                }
            }
        }
    }
}