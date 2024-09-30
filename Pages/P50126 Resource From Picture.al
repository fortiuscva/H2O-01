page 50126 "Resource From Picture"
{
    PageType = Card;
    ApplicationArea = All;
    DataCaptionExpression = '';
    Caption = 'Create Resource From Picture';
    SourceTable = "Resource From Picture Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(MainPicture; Rec.ResMediaSet)
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the media set for the new resource.';
                Editable = false;
            }
            group(ResSetupGroup)
            {
                ShowCaption = false;

                field(CategoryCode; Rec.ResCategoryCode)
                {
                    ApplicationArea = All;
                    Caption = 'Category';
                    ToolTip = 'Specifies the resource category for the new resource.';
                    TableRelation = "Resource Category";

                    trigger OnValidate()
                    var
                        CandidateTemplate: Code[20];
                    begin
                        LoadAttributesFromCategory();

                        if Rec.ResCategoryCode = '' then
                            exit;

                        if Rec.ResTemplateCode = '' then
                            CandidateTemplate := ResFromPicture.IdentifyTemplateFromCategory(Rec.ResCategoryCode);

                        if CandidateTemplate <> '' then
                            Rec.Validate(ResTemplateCode, CandidateTemplate);
                    end;
                }

                /*
                field(TemplateCode; Rec.ResTemplateCode)
                {
                    ApplicationArea = All;
                    Caption = 'Template to apply';
                    ToolTip = 'Specifies the template to apply to the new resource.';
                    TableRelation = "Resource Templ.";

                    trigger OnValidate()
                    var
                        ResTempl: Record "Resource Templ.";
                    begin
                        If Rec.ResTemplateCode = '' then
                            exit;

                        ResTempl.Get(Rec.ResTemplateCode);

                        if (ResTempl."Resource Category Code" = '') or (ResTempl."Resource Category Code" = Rec.ResCategoryCode) then
                            exit;

                        Rec.ResCategoryCode := ResTempl."Resource Category Code";
                        LoadAttributesFromCategory();
                    end;
                }
                */
            }
            part(Attributes; "Res. From Picture Attrib Part")
            {
            }
        }
    }

    trigger OnOpenPage()
    var
        ProgressDialog: Dialog;
        ShouldUseImageAnalysis: Boolean;
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();

            ShouldUseImageAnalysis := ResFromPicture.CanRunImageAnalysis(GetImageAnalysisTypes());

            if ShouldUseImageAnalysis then
                ShouldUseImageAnalysis := ResFromPicture.ApprovePrivacyNotice(NotificationBuffer);

            Session.LogMessage('0000JYQ', StrSubstNo(ResFromPictureStartedTelemetryTxt, ShouldUseImageAnalysis), Verbosity::Normal,
                DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', ResFromPicture.GetTelemetryCategory());

            if not ResFromPicture.ImportFile(Rec) then
                Error('');

            if ShouldUseImageAnalysis then begin
                ProgressDialog.Open(AnalyzingPictureProgressTxt);
                ResFromPicture.AnalyzeImage(ResFromPicture.GetFirstMediaFromMediaSet(Rec.ResMediaSet.MediaId), Rec, GetImageAnalysisTypes(), NotificationBuffer);
                ProgressDialog.Close();
            end;

            Rec.Insert();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        ImageAnalysisSetup: Record "Image Analysis Setup";
        NotificationToSend: Notification;
    begin
        LoadAttributesFromCategory();

        ImageAnalysisSetup.GetSingleInstance();

        foreach NotificationToSend in NotificationBuffer do
            NotificationLifecycleMgt.SendNotification(NotificationToSend, ImageAnalysisSetup.RecordId());

        Clear(NotificationBuffer);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [Action::LookupCancel, Action::Cancel] then
            ClearMediaAndAttributes()
        else
            SaveResAndAttributes();

        exit(true);
    end;

    var
        ResFromPicture: Codeunit "Resource From Picture";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        TemplateFailedOptionsTxt: Label 'Create resource without template, Discard resource', Comment = 'Comma separated list of options';
        TemplateFailedQuestionTxt: Label 'We could not apply the resource template. Contact your partner to fix this issue.\\ Do you want to create the resource without applying the template?';
        AnalyzingPictureProgressTxt: Label 'Analyzing your picture...';
        ResFromPictureStartedTelemetryTxt: Label 'Resource from picture started. Image analysis enabled: %1.', Locked = true;
        NotificationBuffer: List of [Notification];

    local procedure LoadAttributesFromCategory()
    begin
        CurrPage.Attributes.Page.LoadAttributesFromCategory(Rec.ResCategoryCode);
    end;

    local procedure SaveResAndAttributes()
    var
        Res: Record Resource;
        ResTemplMgt: Codeunit "Resource Template Management";
        IsHandled: Boolean;
        ResCreated: Boolean;
    begin
        if Rec.ResTemplateCode <> '' then begin
            ResCreated := ResTemplMgt.CreateResFromTemplate(Res, IsHandled, Rec.ResTemplateCode);
            if not IsHandled or not ResCreated then
                // This happens only in case of partner code interfering
                case StrMenu(TemplateFailedOptionsTxt, 1, TemplateFailedQuestionTxt) of
                    0: // Cancel
                        Error('');
                    1: // Create without template
                        IsHandled := false;
                    2: // Discard
                        exit;
                end;
        end;

        if not IsHandled then begin
            Res.Init();
            Res.Insert(true);
        end;

        if Rec.ResCategoryCode <> '' then
            Res.Validate("Resource Category Code", Rec.ResCategoryCode);
        Res.Validate(Name, ResFromPicture.GenerateResDescription(Rec));

        Res.Modify();

        CurrPage.Attributes.Page.SaveValues(Res);

        Page.Run(Page::"Resource Card", Res);
    end;

    local procedure ClearMediaAndAttributes()
    begin
        ResFromPicture.CleanTenantMediaSet(Rec.ResMediaSet.MediaId());

        CurrPage.Attributes.Page.ClearValues();
    end;

    local procedure GetImageAnalysisTypes() ImageAnalysisTypes: List of [Enum "Image Analysis Type"]
    begin
        ImageAnalysisTypes.Add(Enum::"Image Analysis Type"::Tags);
    end;
}