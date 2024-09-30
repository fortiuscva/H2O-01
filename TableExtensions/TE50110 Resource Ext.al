tableextension 50110 "Resource Ext" extends Resource
{
    fields
    {
        field(50100; Rental; Boolean)
        {
            Caption = 'Rental';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                testfield(Type, Type::Machine);
            end;
        }


        field(50101; "Rental Start Date"; Date)
        {
            Caption = 'Rental Start Date';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = lookup("Sales Line"."Rental Start Date" WHERE(Type = CONST(Resource), "No." = field("No.")));
        }
        field(50102; "Rental End Date"; Date)
        {
            Caption = 'Rental End Date';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = lookup("Sales Line"."Rental End Date" WHERE(Type = CONST(Resource), "No." = field("No.")));
        }
        field(50103; "On Rent"; Boolean)
        {
            Caption = 'On Rent';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = lookup("Sales Line"."On Rent" WHERE(Type = CONST(Resource), "No." = field("No.")));
        }
        field(50105; "Rental Days"; integer)
        {
            Caption = 'Rental Days';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = lookup("Sales Line"."Rental Days" WHERE(Type = CONST(Resource), "No." = field("No.")));
        }
        field(50110; "Rental Work Order No."; code[20])
        {
            Caption = 'Rental Work Order No.';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = lookup("Sales Line"."Document No." WHERE(Type = CONST(Resource), "No." = field("No.")));
        }
        field(50120; "Resource Category Code"; Code[20])
        {
            Caption = 'Resource Category Code';
            TableRelation = "Resource Category";

            trigger OnValidate()
            var
                ResAttributeManagement: Codeunit "Resource Attribute Management";
            begin
                if not IsTemporary then
                    ResAttributeManagement.InheritAttributesFromResCategory(Rec, "Resource Category Code", xRec."Resource Category Code");
                UpdateResCategoryId();

                //OnAfterValidateResCategoryCode(Rec, xRec);
            end;
        }
        field(50130; "Resource Category Id"; Guid)
        {
            Caption = 'Resource Category Id';
            DataClassification = SystemMetadata;
            TableRelation = "Resource Category".SystemId;

            trigger OnValidate()
            begin
                UpdateResCategoryCode;
            end;
        }
        field(50145; "Associated Resources"; Boolean)
        {
            caption = 'Associated Resources';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = exist("Associated Resource" WHERE("Resource No." = FIELD("No.")));
        }
        field(50147; "Must Send To Mendix"; boolean)
        {
            Caption = 'Must Send To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50150; "Sent To Mendix"; Boolean)
        {
            Caption = 'Sent To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50155; "Sent To Mendix Date"; Date)
        {
            Caption = 'Sent To Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50160; "Sent To Mendix Time"; Time)
        {
            Caption = 'Sent To Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50165; "Fixed Asset No."; code[20])
        {
            Caption = 'Fixed Asset No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset" where(rental = const(true));
        }
        field(50170; Supervisor; code[20])
        {
            Caption = 'Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = Resource where(Type = Const(Person));
        }
        field(50175; "Qty. on Sales Invoice"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".Quantity WHERE(Type = CONST(Resource),
                            "No." = FIELD("No."),
                            "Posting Date" = FIELD("Date Filter"),
                            "Document Type" = const(Invoice)));
            Caption = 'Qty. on Sales Invoice';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50180; "Work Type Code"; code[10])
        {
            Caption = 'Default Work Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Work Type";
        }
        field(50190; "Technician Initials"; text[3])
        {
            Caption = 'Technician Initials';
            DataClassification = ToBeClassified;
        }
        field(50200; "Meter Journal Template"; code[10])
        {
            Caption = 'Meter Journal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Template";
        }
        field(50210; "Meter Journal Batch"; code[10])
        {
            Caption = 'Meter Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Batch".Name where("Journal Template Name" = FIELD("Meter Journal Template"));
        }


        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                IF Type = Type::Person then begin
                    Rental := false;
                end;
            end;
        }
        modify("Resource Group No.")
        {
            trigger OnAfterValidate()
            begin
                If ResGrp.get("Resource Group No.") then
                    Rental := ResGrp.Rental;
            end;
        }
    }


    var
        ResourceSetup: record "Resources Setup";
        ResGrp: record "Resource Group";
        ResCustPr: record "Resource Customer Price";
        Text50000: TextConst ENU = 'The resource is a rental until it comes off rent.';
        SelectResErr: TextConst ENU = 'You must select an existing resource.';
        CreateNewResTxt: Label 'Create a new resource card for %1.', Comment = '%1 is the name to be used to create the customer. ';
        SelectResTxt: Label 'Select an existing resource.';
        ResNotRegisteredTxt: Label 'This resource is not registered. To continue, choose one of the following options:';


    trigger OnAfterInsert()
    begin
        "Must Send To Mendix" := true;
        "Sent To Mendix" := false;
        "Sent To Mendix Date" := 0D;
        "Sent To Mendix Time" := 0T;
    end;


    trigger OnAfterModify()
    begin
    end;


    trigger OnBeforeDelete()
    begin
        ResCustPr.setrange(Type, ResCustPr.Type::Resource);
        ResCustPr.setrange("No.", "No.");
        ResCustPr.deleteall;
    end;


    procedure UpdateResCategoryId()
    var
        ResCategory: Record "Resource Category";
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
    begin
        if IsTemporary then
            exit;

        if not GraphMgtGeneralTools.IsApiEnabled() then
            exit;

        if "Resource Category Code" = '' then begin
            Clear("Resource Category Id");
            exit;
        end;

        if not ResCategory.Get("Resource Category Code") then
            exit;

        "Resource Category Id" := ResCategory.SystemId;
    end;


    local procedure UpdateResCategoryCode()
    var
        ResCategory: Record "Resource Category";
    begin
        if not IsNullGuid("Resource Category Id") then
            ResCategory.GetBySystemId("Resource Category Id");

        "Resource Category Code" := ResCategory.Code;
    end;


    local procedure CreateNewRes(ResName: Text[100]; ShowResCard: Boolean): Code[20]
    var
        Res: Record Resource;
        ResTemplMgt: Codeunit "Resource Template Management";
        ResCard: Page "Resource Card";
    begin
        //OnBeforeCreateNewRes(Res, ResName);
        if not ResTemplMgt.InsertResFromTemplate(Res) then
            Error(SelectResErr);

        Res.Name := ResName;
        Res.Modify(true);
        Commit();
        if not ShowResCard then
            exit(Res."No.");
        Res.SetRange("No.", Res."No.");
        ResCard.SetTableView(Res);
        if not (ResCard.RunModal() = ACTION::OK) then
            Error(SelectResErr);

        exit(Res."No.");
    end;


    procedure GetResNo(ResText: Text): Code[20]
    var
        ResNo: Text[50];
    begin
        TryGetResNo(ResNo, ResText, true);
        exit(CopyStr(ResNo, 1, MaxStrLen("No.")));
    end;


    procedure TryGetResNo(var ReturnValue: Text[50]; ResText: Text; DefaultCreate: Boolean): Boolean
    begin
        ResourceSetup.Get();
        exit(TryGetItemNoOpenCard(ReturnValue, ResText, DefaultCreate, true, not ResourceSetup."Skip Prompt to Create Res."));
    end;

    procedure TryGetItemNoOpenCard(var ReturnValue: Text; ResText: Text; DefaultCreate: Boolean; ShowResCard: Boolean; ShowCreateResOption: Boolean): Boolean
    var
        ResView: Record Resource;
    begin
        ResView.SetRange(Blocked, false);
        exit(TryGetResNoOpenCardWithView(ReturnValue, ResText, DefaultCreate, ShowResCard, ShowCreateResOption, ResView.GetView()));
    end;

    internal procedure TryGetResNoOpenCardWithView(var ReturnValue: Text; ResText: Text; DefaultCreate: Boolean; ShowResCard: Boolean; ShowCreateResOption: Boolean; View: Text): Boolean
    var
        Res: Record Resource;
        SalesLine: Record "Sales Line";
        FindRecordMgt: Codeunit "Find Record Management";
        ResNo: Code[20];
        ResWithoutQuote: Text;
        ResFilterContains: Text;
        FoundRecordCount: Integer;
    begin
        ReturnValue := CopyStr(ResText, 1, MaxStrLen(ReturnValue));
        if ResText = '' then
            exit(DefaultCreate);

        //FoundRecordCount :=
        //    FindRecordMgt.FindRecordByDescriptionAndView(ReturnValue, SalesLine.Type::Resource.AsInteger(), ResText, View);

        if FoundRecordCount = 1 then
            exit(true);

        ReturnValue := CopyStr(ResText, 1, MaxStrLen(ReturnValue));
        if FoundRecordCount = 0 then begin
            if not DefaultCreate then
                exit(false);

            if not GuiAllowed then
                Error(SelectResErr);

            //OnTryGetItemNoOpenCardWithViewOnBeforeShowCreateItemOption(Rec);
            if Res.WritePermission then
                if ShowCreateResOption then
                    case StrMenu(
                           StrSubstNo('%1,%2', StrSubstNo(CreateNewResTxt, ConvertStr(ResText, ',', '.')), SelectResTxt), 1, ResNotRegisteredTxt)
                    of
                        0:
                            Error('');
                        1:
                            begin
                                ReturnValue := CreateNewRes(CopyStr(ResText, 1, MaxStrLen(Res.Name)), ShowResCard);
                                exit(true);
                            end;
                    end
                else
                    exit(false);
        end;

        if not GuiAllowed then
            Error(SelectResErr);

        if FoundRecordCount > 0 then begin
            ResWithoutQuote := ConvertStr(ResText, '''', '?');
            ResFilterContains := '''@*' + ResWithoutQuote + '*''';
            Res.FilterGroup(-1);
            Res.SetFilter("No.", ResFilterContains);
            Res.SetFilter(Name, ResFilterContains);
            Res.SetFilter("Base Unit of Measure", ResFilterContains);
            //OnTryGetItemNoOpenCardOnAfterSetItemFilters(Item, ItemFilterContains);
        end;

        if ShowResCard then
            ResNo := PickRes(Res)
        else begin
            ReturnValue := '';
            exit(true);
        end;

        if ResNo <> '' then begin
            ReturnValue := ResNo;
            exit(true);
        end;

        if not DefaultCreate then
            exit(false);
        Error('');
    end;


    procedure PickRes(var Res: Record Resource): Code[20]
    var
        ResList: Page "Resource List";
    begin
        if Res.FilterGroup = -1 then
            ResList.SetTempFilteredResRec(Res);

        if Res.FindFirst() then;
        ResList.SetTableView(Res);
        ResList.SetRecord(Res);
        ResList.LookupMode := true;
        if ResList.RunModal() = ACTION::LookupOK then
            ResList.GetRecord(Res)
        else
            Clear(Res);

        exit(Res."No.");
    end;

}
