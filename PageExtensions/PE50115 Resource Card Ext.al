pageextension 50115 "Resource Card Ext" extends "Resource Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ResAttributesFactbox; "Resource Attributes Factbox")
            {
                ApplicationArea = All;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                //Visible = ShowWorkflowStatus;
            }
        }
        addlast(content)
        {
            group(Rentals)
            {
                field(Rental; rec.Rental)
                {
                    caption = 'Rental';
                    ToolTip = 'Specifies whether the Resource is a rental.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IF (rec.Rental <> xrec.Rental) and (rec.Rental = FALSE) then begin
                            CheckIfOnRent();
                        end;
                    end;
                }
                field(RentOn; RentOn)
                {
                    caption = 'On Rent';
                    ToolTip = 'Specifies whether the Resource is currently on rent.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RentStart; RentStart)
                {
                    caption = 'Rental Start Date';
                    ToolTip = 'Specifies the Rental Start Date if the Resource is currently on rent.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RentEnd; RentEnd)
                {
                    caption = 'Rental End Date';
                    ToolTip = 'Specifies the Rental Start Date if the Resource is currently on rent.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RentDays; RentDays)
                {
                    caption = 'Rental Days';
                    ToolTip = 'Specifies the number of days the resource is currently on rent.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Associated Resources"; rec."Associated Resources")
                {
                    caption = 'Associated Resources';
                    ToolTip = 'If this is checked, there are additional resources associated with this resource.';
                    ApplicationArea = All;
                }
                field("Fixed Asset No."; rec."Fixed Asset No.")
                {
                    caption = 'Fixed Asset No.';
                    ToolTip = 'Specifies the Fixed Asset No. if the resource is a fixed asset.';
                    ApplicationArea = All;
                }
            }
            group(MtrJnls)
            {
                caption = 'Meter Journals';

                field("Meter Journal Template"; Rec."Meter Journal Template")
                {
                    caption = 'Meter Journal Template';
                    ToolTip = 'Specifies the Journal Template if this resource reads meters.';
                    ApplicationArea = All;
                }
                field("Meter Journal Batch"; Rec."Meter Journal Batch")
                {
                    caption = 'Meter Journal Batch';
                    ToolTip = 'Specifies the Journal Batch Name if this resource reads meters.';
                    ApplicationArea = All;
                }
            }
        }
        addafter("Last Date Modified")
        {
            field("Resource Category Code"; Rec."Resource Category Code")
            {
                caption = 'Resource Category Code';
                ApplicationArea = All;
                ToolTip = 'Specifies the category that the resource belongs to. Resource categories also contain any assigned resource attributes.';

                trigger OnValidate()
                begin
                    CurrPage.ResAttributesFactbox.PAGE.LoadResAttributesData(rec."No.");
                    //EnableCostingControls();
                end;
            }
        }
        addafter("Employment Date")
        {
            field(Supervisor; rec.Supervisor)
            {
                caption = 'Supervisor';
                ApplicationArea = All;
                ToolTip = 'Specifies the (employee) resource''s supervisor.';
            }
            field("Technician Initials"; rec."Technician Initials")
            {
                Caption = 'Technician Initials';
                ApplicationArea = All;
                ToolTip = 'Technician Initials (3 characters max.).';
            }

        }
        addafter("Resource Group No.")
        {
            field("Work Type Code"; rec."Work Type Code")
            {
                Caption = 'Default Work Type';
                ApplicationArea = All;
                ToolTip = 'Specifies the (employee) resource''s supervisor.';
            }
        }
    }



    actions
    {
        addlast(navigation)
        {
            action(ResCustPr)
            {
                ApplicationArea = All;
                Caption = 'Customer Prices';
                Image = Category;
                ToolTip = 'View or edit the resource prices by customer';
                RunObject = Page "Resource Customer Prices";
                RunPageLink = "No." = FIELD("No.");

                //trigger OnAction()
                //begin
                //PAGE.RunModal(PAGE::"Resource Customer Prices", Rec);
                //CurrPage.SaveRecord();
                //CurrPage.ResAttributesFactbox.PAGE.LoadResAttributesData(rec."No.");
                //end;
            }
            action(Attributes)
            {
                //AccessByPermission = TableData "Resource Attribute" = R;
                ApplicationArea = All;
                Caption = 'Attributes';
                Image = Category;
                ToolTip = 'View or edit the resource''s attributes, such as color, size, or other characteristics that help to describe the resource.';
                //RunObject = Page "Res. Attribute Value Editor";
                //RunPageLink = "No." = FIELD("No.");

                trigger OnAction()
                begin
                    PAGE.RunModal(PAGE::"Res. Attribute Value Editor", Rec);
                    CurrPage.SaveRecord();
                    CurrPage.ResAttributesFactbox.PAGE.LoadResAttributesData(rec."No.");
                end;
            }
            action(AssocResources)
            {
                caption = 'Associated Resources';
                ApplicationArea = All;
                image = Resource;
                ToolTip = 'View or edit additional resources associated with this resource.';
                RunObject = Page "Associated Resources";
                RunPageLink = "Resource No." = FIELD("No.");
            }
        }
        addlast("F&unctions")
        {
            action(Templates)
            {
                ApplicationArea = All;
                Caption = 'Templates';
                Image = Template;
                ToolTip = 'View or edit resource templates.';

                trigger OnAction()
                var
                    ResTemplMgt: Codeunit "Resource Template Management";
                begin
                    ResTemplMgt.ShowTemplates();
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
                    ResTemplMgt: Codeunit "Resource Template Management";
                begin
                    ResTemplMgt.UpdateResFromTemplate(Rec);
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
                    ResTemplMgt: Codeunit "Resource Template Management";
                begin
                    ResTemplMgt.SaveAsTemplate(Rec);
                end;
            }
        }
    }


    var
        SalesLine: record "Sales Line";
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistCurrUser: Boolean;
        ShowWorkflowStatus: Boolean;
        RentOn: boolean;
        RentStart: date;
        RentEnd: date;
        RentDays: Integer;
        Text50000: TextConst ENU = 'Resource %1 is currently on rent.';


    protected var
        NewMode: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;


    /*
    trigger OnAfterGetRecord()
    begin
        RentOn := false;
        RentStart := 0D;
        RentEnd := 0D;
        RentDays := 0;

        ResLedgEntry.reset;
        ResLedgEntry.SetCurrentKey("Entry No.", "Resource No.");
        ResLedgEntry.SetAscending("Entry No.", false);
        ResLedgEntry.setrange("Resource No.", rec."No.");
        ResLedgEntry.setrange(Rental, true);
        ResLedgEntry.setrange("Entry Type", ResLedgEntry."Entry Type"::Rent);
        If ResLedgEntry.Findfirst() then begin
            RentOn := ResLedgEntry."On Rent";
            RentStart := ResLedgEntry."Rental Start Date";
            RentEnd := ResLedgEntry."Rental End Date";
            RentDays := ResLedgEntry."Rental Days";

            CurrPage.Update();
        end;
    end;
    */


    local procedure CheckIfOnRent()
    begin
        SalesLine.reset;
        SalesLine.setrange(Type, SalesLine.Type::Resource);
        SalesLine.setrange("No.", rec."No.");
        SalesLine.setrange(Rental, true);
        SalesLine.setrange("On Rent", true);
        IF SalesLine.findfirst then
            error(Text50000, rec."No.");
    end;


    /*
    Local procedure OnAfterGetCurrRecordFunc()
    var
        //CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        CreateResFromTemplate();

        //if CRMIntegrationEnabled then begin
        //    CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
        //    if "No." <> xRec."No." then
        //        CRMIntegrationManagement.SendResultNotification(Rec);
        //end;
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RecordId);
        OpenApprovalEntriesExistCurrUser := false;
        if OpenApprovalEntriesExist then
            OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(rec.RecordId);

        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        CurrPage.ResAttributesFactbox.PAGE.LoadResAttributesData(Rec."No.");
        //CurrPage.EntityTextFactBox.Page.SetContext(Database::Item, Rec.SystemId, Enum::"Entity Text Scenario"::"Marketing Text", MarketingTextPlaceholderTxt);
    end;
    */


    local procedure CreateResFromTemplate()
    var
        Res: Record Resource;
        ResourceSetup: Record "Resources Setup";
        ResTemplMgt: Codeunit "Resource Template Management";
    begin
        //OnBeforeCreateItemFromTemplate(NewMode, Rec, Item);

        if not NewMode then
            exit;
        NewMode := false;

        if ResTemplMgt.InsertResFromTemplate(Res) then begin
            Rec.Copy(Res);
            //OnCreateItemFromTemplateOnBeforeCurrPageUpdate(Rec);
            //EnableControls();
            CurrPage.Update();
            //OnCreateItemFromTemplateOnAfterCurrPageUpdate(Rec);
        end else
            if ResTemplMgt.TemplatesAreNotEmpty() then
                if not ResTemplMgt.IsOpenBlankCardConfirmed() then begin
                    CurrPage.Close();
                    exit;
                end;

        //OnCreateItemFromTemplateOnBeforeIsFoundationEnabled(Rec);

        //if ApplicationAreaMgmtFacade.IsFoundationEnabled() then
        //    if (Res."No." = '') and ResourceSetup.Get() then
        //        Rec.Validate("Costing Method", InventorySetup."Default Costing Method");
    end;
}