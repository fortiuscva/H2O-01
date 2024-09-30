table 50105 "Meter Journal Batch"
{
    Caption = 'Meter Journal Batch';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Journal Batches";
    DrillDownPageId = "Meter Journal Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(15; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
            trigger OnValidate()
            begin
                IF "Reason Code" <> xRec."Reason Code" THEN BEGIN
                    MtrJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    MtrJnlLine.SETRANGE("Journal Batch Name", Name);
                    MtrJnlLine.MODIFYALL("Reason Code", "Reason Code");
                    MODIFY;
                END;
            end;
        }
        field(20; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            trigger OnValidate()
            begin
                IF "No. Series" <> '' THEN BEGIN
                    MtrJnlTemplate.GET("Journal Template Name");
                    //IF MtrJnlTemplate.Recurring THEN
                    //    ERROR(
                    //      Text000,
                    //      FIELDCAPTION("Posting No. Series"));
                    IF "No. Series" = "Posting No. Series" THEN
                        VALIDATE("Posting No. Series", '');
                END;
            end;
        }
        field(25; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            trigger OnValidate()
            begin
                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                    FIELDERROR("Posting No. Series", STRSUBSTNO(Text001, "Posting No. Series"));
                MtrJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                MtrJnlLine.SETRANGE("Journal Batch Name", Name);
                MtrJnlLine.MODIFYALL("Posting No. Series", "Posting No. Series");
                MODIFY;
            end;
        }
        field(30; "No. of Journal Lines"; Integer)
        {
            Editable = false;
            caption = 'No. of Journal Lines';
            FieldClass = FlowField;
            CalcFormula = Count("Meter Journal Line" WHERE("Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name)));
        }
    }



    keys
    {
        key(PK; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }


    var
        MtrJnlTemplate: Record "Meter Journal Template";
        MtrJnlLine: Record "Meter Journal Line";
        MtrSetup: record "Meter Setup";
        Text000: TextConst ENU = 'Only the %1 field can be filled in on recurring journals.';
        Text001: TextConst ENU = 'Must not be %1';
        Text002: TextConst ENU = 'This Journal Batch Name is used for remote meter reads and cannot be deleted.';
        Text003: TextConst ENU = 'This Journal Batch Name is used for remote meter reads and cannot be renamed.';


    trigger OnInsert()
    begin
        LOCKTABLE;
        MtrJnlTemplate.GET("Journal Template Name");
    end;


    trigger OnDelete()
    begin
        MtrSetup.get;
        If Name = MtrSetup."Def. Jnl Templ. for Mtr Read" then
            error(Text002);

        MtrJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        MtrJnlLine.SETRANGE("Journal Batch Name", Name);
        MtrJnlLine.DELETEALL(TRUE);
    end;


    trigger OnRename()
    begin
        MtrSetup.get;
        If Name = MtrSetup."Def. Jnl Templ. for Mtr Read" then
            error(Text003);

        MtrJnlLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        MtrJnlLine.SETRANGE("Journal Batch Name", xRec.Name);
        WHILE MtrJnlLine.FINDFIRST DO
            MtrJnlLine.RENAME("Journal Template Name", Name, MtrJnlLine."Line No.");
    end;


    procedure SetupNewBatch()
    begin
        MtrJnlTemplate.GET("Journal Template Name");
        "No. Series" := MtrJnlTemplate."No. Series";
        "Posting No. Series" := MtrJnlTemplate."Posting No. Series";
        "Reason Code" := MtrJnlTemplate."Reason Code";
    end;
}
