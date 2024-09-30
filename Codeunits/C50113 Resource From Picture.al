codeunit 50113 "Resource From Picture"
{
    Access = Internal;
    Permissions = tabledata "Nav App Setting" = rm,
                  tabledata "Image Analysis Scenario" = Rimd;


    var
        // Setup handling
        ImageAnalysisDisabledNotAdminTxt: Label 'Next time you open this page, we can prefill some information for you. Ask your admin to activate this feature.';
        ImageAnalysisDisabledAdminTxt: Label 'Next time you open this page, we can prefill some information for you.';
        ImageAnalysisDisabledActionTxt: Label 'Set up';
        NotificationDontShowActionTxt: Label 'Don''t ask again';
        ImageAnalysisDisabledNotificationIdTxt: Label 'e33a923a-1931-488b-a6c9-2aefd146b2ab', Locked = true;
        ImageAnalysisErrorNotificationIdTxt: Label '046babbb-1713-45a2-b337-db23198314d2', Locked = true;
        ImageAnalysisNotificationNameTxt: Label 'Notify the user of Image Analysis capabilities when creating an resource from picture.', MaxLength = 128;
        ImageAnalysisNotificationDescriptionTxt: Label 'Reminds the user that the Resource From Picture experience supports using Image Analysis capabilities.';
        ResFromPictureScenarioTxt: Label 'RESOURCE FROM PICTURE', Locked = true;
        // Sandbox HTTP calls handling
        SystemApplicationAppIdTxt: Label '63ca2fa4-4f03-4f2b-a480-172fef340d3f', Locked = true;
        EnableHttpCallsQst: Label 'This feature only works if you allow %1 extensions to communicate with external services. This is turned off by default in Sandbox environments.\\Do you want to allow communication from %1 extensions to external services? You can always change this from the Extension Management page.', Comment = '%1 = The publisher of the BaseApp extension, for example Microsoft.';
        CouldNotEnableHttpCallsMsg: Label 'We could not enable external calls for this scenario. You might lack permissions for this operation.';
        // Image handling
        ImageFileFilterLbl: Label 'All supported images (*.jpg;*.jpeg;*.png;*.gif;*.bmp)';
        ImageFileFilterExtensionsTxt: Label '%1|*.jpg;*.jpeg;*.png;*.gif;*.bmp', Locked = true;
        TempResMediaTxt: Label 'Create Resource From Picture: %1', MaxLength = 250, Comment = '%1: the original picture name, for example "table.png"';
        UploadDialogCaptionTxt: Label 'Upload a picture to get started';
        // Resource handling
        ResDescriptionCategoryFileTxt: Label '%1 (from picture "%2")', Comment = '%1: a category name, for example "Kitchen appliances"; %2: a file name, for example "fork_2023_02_07"';
        ResDescriptionCategoryTxt: Label '%1', Comment = '%1: a category name, for example "Kitchen appliances"';
        ResDescriptionFileTxt: Label 'Resource from picture "%1"', Comment = '%1: a file name, for example "fork_2023_02_07"';
        // Error handling
        LimitReachedMsg: Label 'Seems like you reached the current limit of image analysis (%1 per %2). You won''t be able to analyze more images until the next period starts.', Comment = '%1: a number, for example 100; %2: a time period, for example "Month" or "Hour"';
        AnalysisNotPerformedMsg: Label 'We could not analyze your image because of the following error: %1', Comment = '%1: an error, for example "Usage limit reached"';
        // Telemetry
        ResFromPictureTelemetryCategoryTxt: Label 'AL Resource From Picture', Locked = true;
        ImageAnalysisFailedTelemetryTxt: Label 'Image analysis failed while creating resource from picture.', Locked = true;
        ImageAnalysisCompleteTelemetryTxt: Label 'Image analysis completed successfully. Category found: %1. Template found: %2. Limit reached: %3.', Locked = true;
        ImageAnalysisStartedTelemetryTxt: Label 'Image analysis started for analysis types: %1.', Locked = true;
        SavingAttributesTelemetryTxt: Label 'Saving %1 attributes for resource.', Locked = true;


    procedure EnableImageAnalysisScenario()
    var
        ImageAnalysisScenario: Record "Image Analysis Scenario";
        ResFromPicture: Codeunit "Resource From Picture";
    begin
        ImageAnalysisScenario.SetRange("Scenario Name", ResFromPicture.GetResFromPictureScenario());
        ImageAnalysisScenario.DeleteAll();

        ImageAnalysisScenario.Init();
        ImageAnalysisScenario."Scenario Name" := ResFromPicture.GetResFromPictureScenario();
        ImageAnalysisScenario."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(ImageAnalysisScenario."Company Name"));
        ImageAnalysisScenario.Status := true;
        ImageAnalysisScenario.Insert(true);
    end;


    procedure GetNewFromPictureActionVisible(): Boolean
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        Res: Record Resource;
        FeatureKey: Record "Feature Key";
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        if not (ClientTypeManagement.GetCurrentClientType() in [ClientType::Web, ClientType::Phone, ClientType::Tablet]) then
            exit(false);

        if not Res.WritePermission() or not Res.ReadPermission()
        or not ResAttributeValueMapping.WritePermission() or not ResAttributeValueMapping.ReadPermission() then
            exit(false);

        if FeatureKey.Get('EntityText') then
            if FeatureKey.Enabled = FeatureKey.Enabled::None then
                exit(false);

        exit(true);
    end;


    procedure ImportFile(var ResFromPictureBuffer: Record "Resource From Picture Buffer" temporary): Boolean
    var
        FileName: Text;
        ImageInStream: InStream;
        UploadResult: Boolean;
    begin
        UploadResult := UploadIntoStream(
            UploadDialogCaptionTxt,
            '',
            StrSubstNo(ImageFileFilterExtensionsTxt, ImageFileFilterLbl),
            FileName,
            ImageInStream);

        if (FileName = '') or (UploadResult = false) then
            exit(false);

        ResFromPictureBuffer.ResMediaSet.ImportStream(ImageInStream, StrSubstNo(TempResMediaTxt, FileName));
        ResFromPictureBuffer.ResMediaFileName := CopyStr(FileName, 1, MaxStrLen(ResFromPictureBuffer.ResMediaFileName));

        exit(true);
    end;


    procedure CleanTenantMediaSet(MediaSetId: Guid)
    var
        TenantMediaSet: Record "Tenant Media Set";
        TenantMedia: Record "Tenant Media";
    begin
        // The Tenant Media was inserted in the database; manually clear it.
        if not TenantMediaSet.WritePermission() or not TenantMediaSet.ReadPermission()
            or not TenantMedia.WritePermission() or not TenantMedia.ReadPermission() then
            exit;

        TenantMediaSet.SetRange(ID, MediaSetId);
        if TenantMediaSet.FindSet() then
            repeat
                if TenantMedia.Get(TenantMediaSet."Media ID".MediaId()) then
                    if TenantMedia.Delete() then;
            until TenantMediaSet.Next() = 0;

        TenantMediaSet.DeleteAll();
    end;


    procedure GetFirstMediaFromMediaSet(MediaSetId: Guid): Guid
    var
        TenantMediaSet: Record "Tenant Media Set";
    begin
        TenantMediaSet.SetRange(ID, MediaSetId);
        if TenantMediaSet.FindFirst() then
            exit(TenantMediaSet."Media ID".MediaId);
    end;


    procedure ResFromImage()
    var
        UnusedAction: Action;
    begin
        PromptOnHttpCallsIfSandbox();
        Commit();
        UnusedAction := Page.RunModal(Page::"Resource From Picture");
    end;


    procedure GenerateResDescription(ResFromPictureBuffer: Record "Resource From Picture Buffer" temporary): Text[100]
    var
        ResCategory: Record "Resource Category";
        CategoryDisplayName: Text;
        CandidateText: Text;
    begin
        if ResFromPictureBuffer.ResDescription <> '' then
            exit(ResFromPictureBuffer.ResDescription);

        if (ResFromPictureBuffer.ResCategoryCode = '') or not (ResCategory.Get(ResFromPictureBuffer.ResCategoryCode)) then
            exit(CopyStr(StrSubstNo(ResDescriptionFileTxt, ResFromPictureBuffer.ResMediaFileName), 1, 100));

        if ResCategory.Get(ResFromPictureBuffer.ResCategoryCode) then
            CategoryDisplayName := ResCategory.Description
        else
            CategoryDisplayName := ResFromPictureBuffer.ResCategoryCode;

        CandidateText := StrSubstNo(ResDescriptionCategoryFileTxt, CategoryDisplayName, ResFromPictureBuffer.ResMediaFileName);

        if StrLen(CandidateText) > 100 then
            CandidateText := StrSubstNo(ResDescriptionCategoryTxt, CategoryDisplayName);

        exit(CopyStr(CandidateText, 1, 100));
    end;


    procedure AnalyzeImage(MediaId: Guid; var ResFromPictureBuffer: Record "Resource From Picture Buffer" temporary; ImageAnalysisTypes: List of [Enum "Image Analysis Type"]; var NotificationBuffer: List of [Notification])
    var
        ImageAnalysisSetup: Record "Image Analysis Setup";
        ImageAnalysisManagement: Codeunit "Image Analysis Management";
        ImageAnalysisResult: Codeunit "Image Analysis Result";
        LastError: Text;
        UsageLimitError: Boolean;
        BestResCategoryCode: Code[20];
        BestResTemplateCode: Code[20];
        LimitValue: Integer;
        LimitType: Option;
    begin
        //Session.LogMessage('0000JYR', StrSubstNo(ImageAnalysisStartedTelemetryTxt, ImageAnalysisManagement.ToCommaSeparatedList(ImageAnalysisTypes)), Verbosity::Normal,
        //    DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', GetTelemetryCategory());

        ImageAnalysisManagement.Initialize(Enum::"Image Analysis Provider"::"v3.2");
        ImageAnalysisManagement.SetMedia(MediaId);
        if not ImageAnalysisManagement.Analyze(ImageAnalysisResult, ImageAnalysisTypes) then begin
            Session.LogMessage('0000JYS', ImageAnalysisFailedTelemetryTxt, Verbosity::Warning,
                DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', GetTelemetryCategory());

            ImageAnalysisManagement.GetLastError(LastError, UsageLimitError);
            NotificationBuffer.Add(CreateErrorNotification(StrSubstNo(AnalysisNotPerformedMsg, LastError)));
            exit;
        end;

        BestResCategoryCode := IdentifyBestResCategory(ImageAnalysisResult);
        if BestResCategoryCode <> '' then
            ResFromPictureBuffer.Validate(ResCategoryCode, BestResCategoryCode);

        BestResTemplateCode := IdentifyTemplateFromCategory(BestResCategoryCode);
        if BestResTemplateCode <> '' then
            ResFromPictureBuffer.Validate(ResTemplateCode, BestResTemplateCode);

        ImageAnalysisManagement.GetLimitParams(LimitType, LimitValue);
        if ImageAnalysisSetup.IsUsageLimitReached(LastError, LimitValue, LimitType) then
            NotificationBuffer.Add(CreateErrorNotification(LimitReachedMsg));

        //ResFromPictureBuffer.SetResult(ImageAnalysisResult.GetResultVerbatim());

        Session.LogMessage('0000JYT',
            StrSubstNo(ImageAnalysisCompleteTelemetryTxt, ResFromPictureBuffer.ResCategoryCode <> '', ResFromPictureBuffer.ResTemplateCode <> '', ImageAnalysisSetup.IsUsageLimitReached(LastError, LimitValue, LimitType)),
            Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', GetTelemetryCategory());
    end;


    procedure IdentifyTemplateFromCategory(CategoryCode: Code[20]): Code[20]
    var
        ResTempl: Record "Resource Template";
    begin
        /*
        if CategoryCode <> '' then begin
            ItemTempl.SetRange("Item Category Code", CategoryCode);
            if ItemTempl.FindFirst() then
                exit(ItemTempl.Code);
        end;

        ItemTempl.Reset();
        if ItemTempl.FindFirst() then
            exit(ItemTempl.Code);

        exit('');
        */
    end;


    local procedure IdentifyBestResCategory(ImageAnalysisResult: Codeunit "Image Analysis Result"): Code[20]
    var
        BestResCategory: Record "Resource Category";
        TagIndex: Integer;
        FoundExactMatch: Boolean;
        FoundPartialMatch: Boolean;
        BestResCategoryConfidence: Decimal;
    begin
        for TagIndex := 1 to ImageAnalysisResult.TagCount() do
            IdentifyBetterResCategory(ImageAnalysisResult.TagName(TagIndex),
                ImageAnalysisResult.TagConfidence(TagIndex),
                FoundExactMatch,
                FoundPartialMatch,
                BestResCategory,
                BestResCategoryConfidence);

        exit(BestResCategory.Code);
    end;


    local procedure IdentifyBetterResCategory(TagName: Text; ResConfidence: Decimal; var CurrentBestCategoryIsExactMatch: Boolean; var CurrentBestCategoryIsPartialMatch: Boolean; var CurrentBestResCategory: Record "Resource Category"; var CurrentBestCategoryConfidence: Decimal)
    var
        ResCategory: Record "Resource Category";
        ResCategoryManagement: Codeunit "Resource Category Management";
    begin
        if ResConfidence <= 0.5 then
            exit;

        if ResCategoryManagement.FindMatchInCategories(TagName, ResCategory, true) then
            if (not CurrentBestCategoryIsExactMatch)
                    or (CurrentBestResCategory.Indentation < ResCategory.Indentation)
                    or ((CurrentBestResCategory.Indentation = ResCategory.Indentation) and (CurrentBestCategoryConfidence < ResConfidence)) then begin
                CurrentBestResCategory := ResCategory;
                CurrentBestCategoryConfidence := ResConfidence;
                CurrentBestCategoryIsExactMatch := true;
            end;

        if not CurrentBestCategoryIsExactMatch then
            if ResCategoryManagement.FindMatchInCategories(TagName, ResCategory, false) then
                if (not CurrentBestCategoryIsPartialMatch)
                        or (CurrentBestResCategory.Indentation < ResCategory.Indentation)
                        or ((CurrentBestResCategory.Indentation = ResCategory.Indentation) and (CurrentBestCategoryConfidence < ResConfidence)) then begin
                    CurrentBestResCategory := ResCategory;
                    CurrentBestCategoryConfidence := ResConfidence;
                    CurrentBestCategoryIsPartialMatch := true;
                end;
    end;


    local procedure CreateErrorNotification(NotificationMessage: Text): Notification
    var
        NotificationToSend: Notification;
    begin
        NotificationToSend.Id := ImageAnalysisErrorNotificationIdTxt;
        NotificationToSend.Message := NotificationMessage;
        NotificationToSend.Scope := NotificationScope::LocalScope;

        exit(NotificationToSend)
    end;


    procedure CanRunImageAnalysis(AnalysisTypes: List of [Enum "Image Analysis Type"]): Boolean
    var
        ImageAnalysisManagement: Codeunit "Image Analysis Management";
    begin
        ImageAnalysisManagement.Initialize(Enum::"Image Analysis Provider"::"v3.2");

        if not ImageAnalysisManagement.IsCurrentUserLanguageSupported(AnalysisTypes) then
            exit(false);

        exit(true);
    end;


    procedure ApprovePrivacyNotice(): Boolean
    var
        NotificationBuffer: List of [Notification];
    begin
        exit(ApprovePrivacyNotice(NotificationBuffer));
    end;


    procedure ClearAttributeValues(var ResAttributeValueSelection: Record "Res. Attribute Value Selection" temporary)
    var
        ResAttribute: Record "Resource Attribute";
    begin
        if ResAttributeValueSelection.FindSet() then
            repeat
                if ResAttribute.Get(ResAttributeValueSelection."Attribute ID") then
                    ResAttribute.RemoveUnusedArbitraryValues();
            until ResAttributeValueSelection.Next() = 0;
    end;


    procedure SaveAttributeValues(var ResAttributeValueSelection: Record "Res. Attribute Value Selection" temporary; Res: Record Resource)
    var
        ResAttributeValueMapping: Record "Res. Attribute Value Mapping";
        ResAttributeValue: Record "Resource Attribute Value";
    begin
        Session.LogMessage('0000K00', StrSubstNo(SavingAttributesTelemetryTxt, ResAttributeValueSelection.Count()), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', GetTelemetryCategory());

        ResAttributeValueMapping.SetRange("Table ID", Database::Resource);
        ResAttributeValueMapping.SetRange("No.", Res."No.");
        ResAttributeValueMapping.DeleteAll();
        ResAttributeValueMapping.Reset();

        If ResAttributeValueSelection.FindSet() then
            repeat
                if ResAttributeValueSelection.FindAttributeValue(ResAttributeValue) then begin
                    ResAttributeValueMapping.Init();
                    ResAttributeValueMapping."Table ID" := DATABASE::Resource;
                    ResAttributeValueMapping."No." := Res."No.";
                    ResAttributeValueMapping."Resource Attribute ID" := ResAttributeValue."Attribute ID";
                    ResAttributeValueMapping."Resource Attribute Value ID" := ResAttributeValue.ID;
                    ResAttributeValueMapping.Insert();
                end;
            until ResAttributeValueSelection.Next() = 0;
    end;


    procedure ApprovePrivacyNotice(var NotificationBuffer: List of [Notification]): Boolean
    var
        ImageAnalysisScenario: Record "Image Analysis Scenario";
        MyNotifications: Record "My Notifications";
        EnableNotification: Notification;
    begin
        if ImageAnalysisScenario.Enabled(ResFromPictureScenarioTxt) then
            exit(true);

        if MyNotifications.IsEnabled(ImageAnalysisDisabledNotificationIdTxt) then begin
            EnableNotification.Id := ImageAnalysisDisabledNotificationIdTxt;
            EnableNotification.Scope := NotificationScope::LocalScope;

            if ImageAnalysisScenario.WritePermission then begin
                EnableNotification.Message := ImageAnalysisDisabledAdminTxt;
                EnableNotification.AddAction(ImageAnalysisDisabledActionTxt, Codeunit::"Resource From Picture", 'RunWizard');
            end else
                EnableNotification.Message := ImageAnalysisDisabledNotAdminTxt;

            EnableNotification.AddAction(NotificationDontShowActionTxt, Codeunit::"Resource From Picture", 'DisableNotification');
            NotificationBuffer.Add(EnableNotification);
        end;

        exit(false);
    end;


    [EventSubscriber(ObjectType::Page, Page::"My Notifications", 'OnInitializingNotificationWithDefaultState', '', false, false)]
    local procedure OnInitializingNotificationWithDefaultState();
    var
        MyNotifications: Record "My Notifications";
    begin
        MyNotifications.InsertDefault(ImageAnalysisDisabledNotificationIdTxt, ImageAnalysisNotificationNameTxt, ImageAnalysisNotificationDescriptionTxt, true);
    end;


    procedure DisableNotification(HostNotification: Notification)
    var
        MyNotifications: Record "My Notifications";
        NotificationId: Guid;
    begin
        NotificationId := HostNotification.Id;
        if MyNotifications.Get(UserId(), NotificationId) THEN
            MyNotifications.Disable(NotificationId)
        else
            MyNotifications.InsertDefault(NotificationId, ImageAnalysisNotificationNameTxt, ImageAnalysisNotificationDescriptionTxt, false);
    end;


    [NonDebuggable]
    procedure RunWizard(Notification: Notification)
    var
        ImageAnalysisSetup: Record "Image Analysis Setup";
        EnvironmentInformation: Codeunit "Environment Information";
        ResFromPictureWizard: Page "Res. From Picture Wizard";
        PageImageAnalysisSetup: Page "Image Analysis Setup";
    begin
        ResFromPictureWizard.RunModal();

        if not ImageAnalysisSetup.WritePermission() then
            exit;

        ImageAnalysisSetup.GetSingleInstance();
        //if EnvironmentInformation.IsOnPrem() then
        //    if (ImageAnalysisSetup."Api Uri" = '') or (ImageAnalysisSetup.GetApiKey() = '') then
        //        PageImageAnalysisSetup.Run();
    end;


    procedure GetResFromPictureScenario(): Code[20]
    begin
        exit(ResFromPictureScenarioTxt);
    end;


    internal procedure GetTelemetryCategory(): Text
    begin
        exit(ResFromPictureTelemetryCategoryTxt);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Image Analysis Scenario", 'OnGetKnownScenarios', '', false, false)]
    local procedure OnGetKnownScenariosAddResFromPicture(var Scenarios: List of [Code[20]])
    begin
        Scenarios.Add(ResFromPictureScenarioTxt);
    end;


    local procedure PromptOnHttpCallsIfSandbox()
    var
        NavAppSettings: Record "NAV App Setting";
        EnvironmentInformation: Codeunit "Environment Information";
        BaseAppSettingsExist: Boolean;
        SystemAppSettingsExist: Boolean;
        ShowFailedMessage: Boolean;
        CurrentModuleInfo: ModuleInfo;
    begin
        if not EnvironmentInformation.IsSandbox() then
            exit;

        if not NavAppSettings.WritePermission() then
            exit;

        NavApp.GetCurrentModuleInfo(CurrentModuleInfo);

        BaseAppSettingsExist := NavAppSettings.Get(CurrentModuleInfo.Id());
        SystemAppSettingsExist := NavAppSettings.Get(SystemApplicationAppIdTxt);

        if BaseAppSettingsExist and SystemAppSettingsExist then
            exit; // Choices have already been made

        if Confirm(EnableHttpCallsQst, false, CurrentModuleInfo.Publisher) then begin
            if not BaseAppSettingsExist then begin
                NavAppSettings."App ID" := CurrentModuleInfo.Id();
                NavAppSettings."Allow HttpClient Requests" := true;
                ShowFailedMessage := ShowFailedMessage or not NavAppSettings.Insert(true);
            end;

            if not SystemAppSettingsExist then begin
                NavAppSettings."App ID" := SystemApplicationAppIdTxt;
                NavAppSettings."Allow HttpClient Requests" := true;
                ShowFailedMessage := ShowFailedMessage or not NavAppSettings.Insert(true);
            end;

            if ShowFailedMessage then
                Message(CouldNotEnableHttpCallsMsg);
        end;
    end;
}