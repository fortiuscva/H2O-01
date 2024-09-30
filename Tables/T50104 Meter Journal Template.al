table 50104 "Meter Journal Template"
{
    Caption = 'Meter Journal Template';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Journal Templates";
    DrillDownPageId = "Meter Journal Templates";

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(10; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(15; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(20; "Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(25; "Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
            DataClassification = ToBeClassified;
        }
        field(30; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
            trigger OnValidate()
            begin
                MtrJnlLine.SETRANGE("Journal Template Name", Name);
                MtrJnlLine.MODIFYALL("Source Code", "Source Code");
                MODIFY;
            end;
        }
        field(35; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(40; "Test Report Caption"; Text[250])
        {
            Caption = 'Test Report Caption';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report), "Object ID" = FIELD("Test Report ID")));
        }
        field(45; "Page Caption"; Text[250])
        {
            Caption = 'Page Caption';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Page), "Object ID" = FIELD("Page ID")));
        }
        field(50; "Posting Report Caption"; Text[250])
        {
            Caption = 'Posting Report Caption';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report), "Object ID" = FIELD("Posting Report ID")));
        }
        field(55; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            trigger OnValidate()
            begin
                IF "No. Series" <> '' THEN BEGIN
                    //IF Recurring THEN
                    //    ERROR(
                    //      Text000,
                    //      FIELDCAPTION("Posting No. Series"));
                    IF "No. Series" = "Posting No. Series" THEN
                        "Posting No. Series" := '';
                END;
            end;
        }
        field(60; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                    FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
            end;
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }


    var
        MtrJnlBatch: Record "Meter Journal Batch";
        MtrJnlLine: Record "Meter Journal Line";
        MtrSetup: record "Meter Setup";
        SourceCodeSetup: Record "Source Code Setup";
        Text000: TextConst ENU = 'Only the %1 field can be filled in on recurring journals.';
        Text001: TextConst ENU = 'Must not be %1';
        Text002: TextConst ENU = 'This Journal Template Name is used for remote meter reads and cannot be deleted.';
        Text003: TextConst ENU = 'This Journal Template Name is used for remote meter reads and cannot be renamed.';


    trigger OnInsert()
    begin
        VALIDATE("Page ID");
    end;


    trigger OnDelete()
    begin
        MtrSetup.get;
        If Name = MtrSetup."Def. Jnl Templ. for Mtr Read" then
            error(Text002);

        MtrJnlLine.SETRANGE("Journal Template Name", Name);
        MtrJnlLine.DELETEALL(TRUE);
        MtrJnlBatch.SETRANGE("Journal Template Name", Name);
        MtrJnlBatch.DELETEALL;
    end;


    trigger OnRename()
    begin
        MtrSetup.get;
        If Name = MtrSetup."Def. Jnl Templ. for Mtr Read" then
            error(Text003);
    end;
}
