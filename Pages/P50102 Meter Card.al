page 50102 "Meter Card"
{
    ApplicationArea = All;
    Caption = 'Meter Card';
    PageType = Card;
    SourceTable = Meter;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Search Name field.';
                }
                field("Serial No."; rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("EID No."; rec."EID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EID No. field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Meter Blocked Reason"; rec."Meter Blocked Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies why a meter is blocked.';
                }
                field("New Meter No."; rec."New Meter No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'If the Activity Type indicates a new meter is required, this is the new Meter No.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Created From ILE Entry No."; rec."Created From ILE Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the meter has been created from an Item Ledger Entry record.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field("Meter Group Code"; Rec."Meter Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meter Group No. field.';
                }
                field("Meter Manufacturer Code"; rec."Meter Manufacturer Code")
                {
                    caption = 'Meter Manufacturer';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meter Manucture Code field.';
                }
                field("Customer Owned"; Rec."Customer Owned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Owned field.';
                }
            }
            group(Location)
            {
                Caption = 'Service Address';

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    caption = 'Property No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                }
                field("Opus Account No."; Rec."Opus Account No.")
                {
                    caption = 'Opus Account No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Opus Account No. field.';
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name 2 field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Address 2 field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer City field.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer State field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer ZIP Code field.';
                }
                field("Service Address ID"; rec."Service Address ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Address ID field.';
                }
                field("Service Address Type"; rec."Service Address Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Address Type field.';
                }
                field("Service Address Class Code"; rec."Service Address Class Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Address Class Code field.';
                }
                field("Meter Install Date"; rec."Meter Install Date")
                {
                    caption = 'Meter Install Date';
                    ApplicationArea = all;
                    ToolTip = 'The date the meter was installed.';
                }
                field("Endpoint Type"; rec."Endpoint Type")
                {
                    caption = 'Endpoint Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Endpoint Type field.';
                }
                field("Smart Meter"; rec."Smart Meter")
                {
                    caption = 'Smart Meter';
                    ApplicationArea = all;
                    ToolTip = 'If checked, the meter is a Smart Meter.';

                }
                field(Size; rec.Size)
                {
                    caption = 'Meter Size';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the size of the meter.';
                }
                field("No. Of Dials"; rec."No. of Dials")
                {
                    caption = 'No. Of Dials';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of dials on the meter.';
                }
                field("Meter Type"; rec."Meter Type")
                {
                    caption = 'Meter Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Type of the Meter.';
                }
                field("Utility Type"; rec."Utility Type")
                {
                    caption = 'Utility Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Type of the Utility.';
                }
                field("Service Type"; rec."Service Type")
                {
                    caption = 'Service Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Type of the Service.';
                }
                field("Opus Location"; rec."Opus Location")
                {
                    caption = 'Opus Location';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Opus Location of the meter.';
                }
            }
            group(Readings)
            {
                Caption = 'Readings';

                field("Route No."; rec."Route No.")
                {
                    caption = 'Route No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Route No. field.';
                }
                field("Location Stop"; rec."Location Stop")
                {
                    caption = 'Location Stop';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Stop field.';
                }
                field("Meter Register Resolution"; rec."Meter Register Resolution")
                {
                    caption = 'Register Resolution';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Register Resolution field.';
                }
                field("Reg. Unit of Measure Code"; rec."Reg. Unit of Measure Code")
                {
                    caption = 'Register Unit Of Measure Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Register Unit Of Measure Code field.';
                }
                field("Previous Meter Reading"; Rec."Previous Meter Reading")
                {
                    caption = 'Previous Meter Reading';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Meter Reading field.';
                }
                field("Previous Meter Reading Date"; Rec."Previous Meter Reading Date")
                {
                    Caption = 'Previous Meter Reading Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Previous Meter Reading Date field.';
                }
                field("Current Meter Reading"; Rec."Current Meter Reading")
                {
                    Caption = 'Current Meter Reading';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Meter Reading field.';
                }
                field("Current Meter Reading Date"; Rec."Current Meter Reading Date")
                {
                    caption = 'Current Meter Reading Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Meter Reading Date field.';
                }
                field("Water Usage"; Rec."Water Usage")
                {
                    caption = 'Water Usage';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Water Usage field.';
                }
            }
            group(Posting)
            {
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                    caption = 'Gen. Prod. Posting Group';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                }
                field("Tax Group Code"; rec."Tax Group Code")
                {
                    caption = 'Tax Group Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Group Code.';
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                    caption = 'Global Dimension 1 Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code.';
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code.';
                }
            }
            group(Maintenance)
            {
                field("Warranty Start Date"; rec."Warranty Start Date")
                {
                    Caption = 'Warranty Start Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value when warranty ends.';
                }
                field("Warranty End Date"; rec."Warranty End Date")
                {
                    caption = 'Warranty End Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value when warranty ends.';
                }
                field("Inspection Interval Gallons"; rec."Inspection Interval Gallons")
                {
                    Caption = 'Inspection Interval Gallons';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value when warranty ends.';
                    DecimalPlaces = 0 : 0;
                }
                field("Purchase Date"; rec."Purchase Date")
                {
                    Caption = 'Purchase Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the meter was purchases.';
                }
                field("Inspection Date"; rec."Inspection Date")
                {
                    Caption = 'Inspection Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the meter was last inspected.';
                }
                field("Scrap Date"; rec."Scrap Date")
                {
                    Caption = 'Scrap Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the meter was scrapped.';
                }
            }
            group("Interface")
            {
                field("Must Send To Opus"; rec."Must Send To Opus")
                {
                    Caption = 'Must Send To Opus';
                    ApplicationArea = All;
                    ToolTip = 'Generated by the system, if checked, this meter record must be sent to Opus.';
                }
                field("Sent to Opus"; rec."Sent To Opus")
                {
                    caption = 'Sent to Opus';
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the record has been transmitted to Opus.';
                }
                field("Sent to Opus Date"; rec."Sent to Opus Date")
                {
                    Caption = 'Sent to Opus Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the record has been transmitted to Opus.';
                }
                field("Sent to Opus Time"; rec."Sent to Opus Time")
                {
                    caption = 'Sent to Opus Time';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time the record has been transmitted to Opus.';
                }
                field("Must Send To Mendix"; rec."Must Send To Mendix")
                {
                    caption = 'Must Send To Mendix';
                    ApplicationArea = All;
                    ToolTip = 'Generated by the system, if checked, this meter record must be sent to Mendix.';
                }
                field("Sent to Mendix"; rec."Sent To Mendix")
                {
                    caption = 'Sent to Mendix';
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the record has been sent to Mendix.';
                }
                field("Sent to Mendix Date"; rec."Sent to Mendix Date")
                {
                    caption = 'Sent to Mendix Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the record has been sent to Mendix.';
                }
                field("Sent to Mendix Time"; rec."Sent to Mendix Time")
                {
                    caption = 'Sent to Mendix Time';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time the record has been sent to Mendix.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            //Caption = '&Meter';
            //Image = Resource;
            action(Statistics)
            {
                ApplicationArea = All;
                Caption = 'Statistics';
                Image = Statistics;
                //RunObject = Page "Resource Statistics";
                //RunPageLink = "No." = FIELD("No."),
                //              "Date Filter" = FIELD("Date Filter")
                //              "Chargeable Filter" = FIELD("Chargeable Filter");
                ShortCutKey = 'F7';
                ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
            }
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = CONST(50101),
                                  "No." = FIELD("No.");
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action("&Picture")
            {
                ApplicationArea = All;
                Caption = '&Picture';
                Image = Picture;
                RunObject = Page "Resource Picture";
                RunPageLink = "No." = FIELD("No.");
                ToolTip = 'View or add a picture of the resource or, for example, the company''s logo.';
            }
            action("E&xtended Texts")
            {
                ApplicationArea = Suite;
                Caption = 'E&xtended Texts';
                Image = Text;
                RunObject = Page "Extended Text List";
                RunPageLink = "Table Name" = CONST(Resource),
                                  "No." = FIELD("No.");
                RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                ToolTip = 'View the extended description that is set up.';
            }
            separator(Action34)
            {
                Caption = '';
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
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
            separator(Action35)
            {
                Caption = '';
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
        }

        area(Processing)
        {
            action(Templates)
            {
                ApplicationArea = All;
                Caption = 'Templates';
                Image = Template;
                ToolTip = 'View or edit meter templates.';

                trigger OnAction()
                var
                    MtrTemplMgt: Codeunit "Meter Template Management";
                begin
                    MtrTemplMgt.ShowTemplates();
                end;
            }
            action(ApplyTemplate)
            {
                ApplicationArea = All;
                Caption = 'Apply Template';
                Image = ApplyTemplate;
                ToolTip = 'Apply a template to update the entity with your standard settings for a certain type of entity.';

                trigger OnAction()
                var
                    MtrTemplMgt: Codeunit "Meter Template Management";
                begin
                    MtrTemplMgt.UpdateMtrFromTemplate(Rec);
                    //EnableControls();
                    CurrPage.Update();
                end;
            }
            action(SaveAsTemplate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Save as Template';
                Image = Save;
                ToolTip = 'Save the resource card as a template that can be reused to create new reseource cards. Resource templates contain preset information to help you fill in fields on resource cards.';

                trigger OnAction()
                var
                    MtrTemplMgt: Codeunit "Meter Template Management";
                begin
                    MtrTemplMgt.SaveAsTemplate(Rec);
                end;
            }
        }
    }



    var
        MtrLedgEntry: record "Meter Ledger Entry";
        NewMode: Boolean;



    trigger OnAfterGetCurrRecord()
    begin
        MtrLedgEntry.RESET;
        MtrLedgEntry.SETCURRENTKEY("Meter No.", "Posting Date");
        MtrLedgEntry.SETRANGE("Meter No.", rec."No.");
        MtrLedgEntry.setrange("Meter Reading", true);
        IF MtrLedgEntry.FINDLAST THEN BEGIN
            rec."Current Meter Reading" := MtrLedgEntry."Current Meter Reading";
            rec."Current Meter Reading Date" := MtrLedgEntry."Current Meter Reading Date";
        END;

        IF (MtrLedgEntry.NEXT < 1) THEN BEGIN
            rec."Previous Meter Reading" := MtrLedgEntry."Previous Meter Reading";
            rec."Previous Meter Reading Date" := MtrLedgEntry."Previous Meter Reading Date";
        END;

        rec."Water Usage" := rec."Current Meter Reading" - rec."Previous Meter Reading";
        rec.MODIFY;
    end;


    local procedure CreateMtrFromTemplate()
    var
        Mtr: Record Meter;
        MtrSetup: Record "Meter Setup";
        MtrTemplMgt: Codeunit "Meter Template Management";
    begin
        //OnBeforeCreateItemFromTemplate(NewMode, Rec, Item);

        if not NewMode then
            exit;
        NewMode := false;

        if MtrTemplMgt.InsertMtrFromTemplate(Mtr) then begin
            Rec.Copy(Mtr);
            //OnCreateItemFromTemplateOnBeforeCurrPageUpdate(Rec);
            //EnableControls();
            CurrPage.Update();
            //OnCreateItemFromTemplateOnAfterCurrPageUpdate(Rec);
        end else
            if MtrTemplMgt.TemplatesAreNotEmpty() then
                if not MtrTemplMgt.IsOpenBlankCardConfirmed() then begin
                    CurrPage.Close();
                    exit;
                end;

        //OnCreateItemFromTemplateOnBeforeIsFoundationEnabled(Rec);

        //if ApplicationAreaMgmtFacade.IsFoundationEnabled() then
        //    if (Res."No." = '') and ResourceSetup.Get() then
        //        Rec.Validate("Costing Method", InventorySetup."Default Costing Method");
    end;
}