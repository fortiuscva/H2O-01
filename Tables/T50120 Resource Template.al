table 50120 "Resource Template"
{
    Caption = 'Resource Template';
    LookupPageID = "Resource Template List";
    DrillDownPageID = "Resource Template List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Type; Enum "Resource Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;

            //trigger OnValidate()
            //begin
            //    ValidateShortcutDimCode(1, Description);
            //end;
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;

            //trigger OnValidate()
            //begin
            //    ValidateShortcutDimCode(1, "Description 2");
            //end;
        }
        field(14; "Resource Group No."; code[10])
        {
            Caption = 'Resource Group No.';
            DataClassification = ToBeClassified;
            TableRelation = "Resource Group";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Resource Group No."));
            end;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(18; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Base Unit of Measure"));
            end;
        }
        field(19; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Caption = 'Direct Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Direct Unit Cost"));
            end;
        }
        field(20; "Indirect Cost %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Indirect Cost %';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Indirect Cost %"));
            end;
        }
        field(21; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Unit Cost"));
            end;
        }
        field(24; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Unit Price"));
            end;
        }
        field(25; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Vendor No."));
            end;
        }
        field(38; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo(Blocked));
            end;
        }
        field(51; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Gen. Prod. Posting Group"));
            end;
        }
        field(55; "Automatic Ext. Texts"; Boolean)
        {
            Caption = 'Automatic Ext. Texts';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Automatic Ext. Texts"));
            end;
        }
        field(56; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("No. Series"));
            end;
        }
        field(57; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Tax Group Code"));
            end;
        }
        field(58; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("VAT Prod. Posting Group"));
            end;
        }
        field(150; "Privacy Blocked"; Boolean)
        {
            Caption = 'Privacy Blocked';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Privacy Blocked"));
            end;
        }
        field(950; "Use Time Sheet"; Boolean)
        {
            Caption = 'Use Time Sheet';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Use Time Sheet"));
            end;
        }
        field(951; "Time Sheet Owner User ID"; code[50])
        {
            Caption = 'Time Sheet Owner User ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Time Sheet Owner User ID"));
            end;
        }
        field(952; "Time Sheet Approver User ID"; code[50])
        {
            Caption = 'Time Sheet Approver User ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Time Sheet Approver User ID"));
            end;
        }
        field(50120; "Resource Category Code"; Code[20])
        {
            Caption = 'Resource Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Resource Category";

            trigger OnValidate()
            begin
                ValidateResField(FieldNo("Resource Category Code"));
            end;
        }
        //field(50130; "Resource Category Id"; Code[20])
        //{
        //    Caption = 'Resource Category Id';
        //    TableRelation = "Resource Category".SystemId;
        //
        //    trigger OnValidate()
        //    begin
        //        ValidateResField(FieldNo("Resource Category ID"));
        //    end;
        //}
        //field(50135; "Resource Group No."; code[10])
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
        key(CategoryKey; "Resource Category Code")
        {
        }
    }



    trigger OnDelete()
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DefaultDimension.SetRange("Table ID", Database::"Resource Template");
        DefaultDimension.SetRange("No.", Code);
        DefaultDimension.DeleteAll();
    end;


    trigger OnRename()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.RenameDefaultDim(Database::"Resource Template", xRec.Code, Code);
    end;


    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        if not IsTemporary then begin
            DimMgt.SaveDefaultDim(Database::"Resource Template", Code, FieldNumber, ShortcutDimCode);
            Modify();
        end;
    end;


    procedure CopyFromTemplate(SourceResTempl: Record "Resource Template")
    begin
        CopyTemplate(SourceResTempl);
        CopyDimensions(SourceResTempl);
        OnAfterCopyFromTemplate(SourceResTempl, Rec);
    end;


    local procedure CopyTemplate(SourceResTempl: Record "Resource Template")
    var
        SavedResTempl: Record "Resource Template";
    begin
        SavedResTempl := Rec;
        TransferFields(SourceResTempl, false);
        Code := SavedResTempl.Code;
        Description := SavedResTempl.Description;
        OnCopyTemplateOnBeforeModify(SourceResTempl, SavedResTempl, Rec);
        Modify();
    end;


    local procedure CopyDimensions(SourceResTempl: Record "Resource Template")
    var
        SourceDefaultDimension: Record "Default Dimension";
        DestDefaultDimension: Record "Default Dimension";
    begin
        DestDefaultDimension.SetRange("Table ID", Database::"Resource Template");
        DestDefaultDimension.SetRange("No.", Code);
        DestDefaultDimension.DeleteAll(true);

        SourceDefaultDimension.SetRange("Table ID", Database::"Resource Template");
        SourceDefaultDimension.SetRange("No.", SourceResTempl.Code);
        if SourceDefaultDimension.FindSet() then
            repeat
                DestDefaultDimension.Init();
                DestDefaultDimension.Validate("Table ID", Database::"Resource Template");
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
    local procedure OnAfterCopyFromTemplate(SourceResTempl: Record "Resource Template"; var ResTempl: Record "Resource Template")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCopyTemplateOnBeforeModify(SourceResTempl: Record "Resource Template"; SavedResTempl: Record "Resource Template"; var ResTempl: Record "Resource Template")
    begin
    end;
}
