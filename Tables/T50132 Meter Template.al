table 50132 "Meter Template"
{
    Caption = 'Meter Template';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(10; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(20; "Meter Group Code"; Code[10])
        {
            Caption = 'Meter Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Group";
            trigger OnValidate()
            begin
                IF "Meter Group Code" = xRec."Meter Group Code" THEN
                    EXIT;

                IF xRec."Meter Group Code" <> '' THEN
                    IF NOT CONFIRM(Text001, FALSE, FIELDCAPTION("Meter Group Code")) THEN BEGIN
                        "Meter Group Code" := xRec."Meter Group Code";
                        EXIT;
                    END;

                IF xRec.GETFILTER("Meter Group Code") <> '' THEN
                    SETFILTER("Meter Group Code", "Meter Group Code");

                IF MtrGrp.get("Meter Group Code") then
                    "Inspection Interval Gallons" := MtrGrp."Inspection Interval Gallons";
            end;

        }
        field(27; "Customer Owned"; Boolean)
        {
            Caption = 'Customer Owned';
            DataClassification = ToBeClassified;
        }
        field(75; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
        }
        field(85; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(86; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;

        }
        field(88; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(90; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(155; "Inspection Interval Gallons"; Decimal)
        {
            Caption = 'Inspection Interval Gallons';
            DataClassification = ToBeClassified;
        }
        field(160; "Meter Blocked Reason"; Code[10])
        {
            Caption = 'Meter Blocked Reason';
            DataClassification = ToBeClassified;

            TableRelation = "Meter Activity" where(Reading = CONST(false));
            trigger OnValidate()
            begin
                testfield(Blocked, TRUE)
            end;
        }
        field(220; "Service Address Class Code"; Code[10])
        {
            Caption = 'Service Address Class Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Service Address Class";
        }
        field(230; "Meter Register Resolution"; Enum "Meter Register Resolution")
        {
            Caption = 'Meter Register Resolution';
            DataClassification = ToBeClassified;
        }
        field(245; "Meter Manufacturer Code"; Code[10])
        {
            Caption = 'Meter Manufacturer Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Manufacturer";
        }
        field(250; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";
        }
        field(285; Size; enum "Meter Size")
        {
            Caption = 'Size';
            DataClassification = ToBeClassified;
        }
        field(290; "No. of Dials"; enum "No. Of Dials")
        {
            Caption = 'No. of Dials';
            DataClassification = ToBeClassified;
        }
        field(295; "Meter Type"; enum "Meter Type")
        {
            Caption = 'Meter Type';
            DataClassification = ToBeClassified;
        }
        field(300; "Utility Type"; enum "Utility Type")
        {
            Caption = 'Utility Type';
            DataClassification = ToBeClassified;
        }
        field(305; "Service Type"; enum "Service Type")
        {
            Caption = 'Service Type';
            DataClassification = ToBeClassified;
        }
    }



    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }

    }


    var
        MtrGrp: record "Meter Group";
        MtrSetup: record "Meter Setup";
        DimMgt: Codeunit DimensionManagement;
        Text001: TextConst ENU = 'Do you want to change %1?';



    trigger OnInsert()
    begin
        "Gen. Prod. Posting Group" := MtrSetup."Gen. Prod. Posting Group";

        IF GETFILTER("Meter Group Code") <> '' THEN
            IF GETRANGEMIN("Meter Group Code") = GETRANGEMAX("Meter Group Code") THEN
                VALIDATE("Meter Group Code", GETRANGEMIN("Meter Group Code"));

        DimMgt.UpdateDefaultDim(
          DATABASE::Meter, Code,
          "Global Dimension 1 Code", "Global Dimension 2 Code");

    end;


    trigger OnDelete()
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DefaultDimension.SetRange("Table ID", Database::"Meter Template");
        DefaultDimension.SetRange("No.", Code);
        DefaultDimension.DeleteAll();
    end;


    trigger OnRename()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.RenameDefaultDim(Database::"Meter Template", xRec.Code, Code);
    end;



    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        if not IsTemporary then begin
            DimMgt.SaveDefaultDim(DATABASE::"Meter Template", Code, FieldNumber, ShortcutDimCode);
            MODIFY;
        end;
    end;


    procedure CopyFromTemplate(SourceMtrTempl: Record "Meter Template")
    begin
        CopyTemplate(SourceMtrTempl);
        CopyDimensions(SourceMtrTempl);
        OnAfterCopyFromTemplate(SourceMtrTempl, Rec);
    end;


    local procedure CopyTemplate(SourceMtrTempl: Record "Meter Template")
    var
        SavedMtrTempl: Record "Meter Template";
    begin
        SavedMtrTempl := Rec;
        TransferFields(SourceMtrTempl, false);
        Code := SavedMtrTempl.Code;
        Description := SavedMtrTempl.Description;
        OnCopyTemplateOnBeforeModify(SourceMtrTempl, SavedMtrTempl, Rec);
        Modify();
    end;


    local procedure CopyDimensions(SourceMtrTempl: Record "Meter Template")
    var
        SourceDefaultDimension: Record "Default Dimension";
        DestDefaultDimension: Record "Default Dimension";
    begin
        DestDefaultDimension.SetRange("Table ID", Database::"Meter Template");
        DestDefaultDimension.SetRange("No.", Code);
        DestDefaultDimension.DeleteAll(true);

        SourceDefaultDimension.SetRange("Table ID", Database::"Meter Template");
        SourceDefaultDimension.SetRange("No.", SourceMtrTempl.Code);
        if SourceDefaultDimension.FindSet() then
            repeat
                DestDefaultDimension.Init();
                DestDefaultDimension.Validate("Table ID", Database::"Meter Template");
                DestDefaultDimension.Validate("No.", Code);
                DestDefaultDimension.Validate("Dimension Code", SourceDefaultDimension."Dimension Code");
                DestDefaultDimension.Validate("Dimension Value Code", SourceDefaultDimension."Dimension Value Code");
                DestDefaultDimension.Validate("Value Posting", SourceDefaultDimension."Value Posting");
                if DestDefaultDimension.Insert(true) then;
            until SourceDefaultDimension.Next() = 0;
    end;


    local procedure ValidateResField(FieldId: Integer)
    var
        ResRecRef: RecordRef;
        ResTemplRecRef: RecordRef;
        ResFieldRef: FieldRef;
        ResTemplFieldRef: FieldRef;
    begin
        ResTemplRecRef.GetTable(Rec);
        ResRecRef.Open(Database::Resource, true);
        TransferFieldValues(ResTemplRecRef, ResRecRef, false);
        ResRecRef.Insert();

        ResFieldRef := ResRecRef.Field(FieldId);
        ResTemplFieldRef := ResTemplRecRef.Field(FieldId);
        ResFieldRef.Validate(ResTemplFieldRef.Value);

        TransferFieldValues(ResTemplRecRef, ResRecRef, true);

        ResTemplRecRef.SetTable(Rec);
        Modify();
    end;


    local procedure TransferFieldValues(var SrcRecRef: RecordRef; var DestRecRef: RecordRef; Reverse: Boolean)
    var
        SrcFieldRef: FieldRef;
        DestFieldRef: FieldRef;
        i: Integer;
    begin
        for i := 3 to SrcRecRef.FieldCount do begin
            SrcFieldRef := SrcRecRef.FieldIndex(i);
            DestFieldRef := DestRecRef.Field(SrcFieldRef.Number);
            if not Reverse then
                DestFieldRef.Value := SrcFieldRef.Value
            else
                SrcFieldRef.Value := DestFieldRef.Value;
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyFromTemplate(SourceMtrTempl: Record "Meter Template"; var MtrTempl: Record "Meter Template")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnCopyTemplateOnBeforeModify(SourceMtrTempl: Record "Meter Template"; SavedMtrTempl: Record "Meter Template"; var MtrTempl: Record "Meter Template")
    begin
    end;
}
