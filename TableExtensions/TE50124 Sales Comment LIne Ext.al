tableextension 50124 "Sales Comment Line Ext" extends "Sales Comment Line"
{
    fields
    {
        modify(Code)
        {
            TableRelation = "Comment Code";
        }

        field(50100; "User ID"; code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = User;
            Editable = false;
        }
        field(50105; "Comment Time"; time)
        {
            Caption = 'Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50110; Bold; boolean)
        {
            Caption = 'Time';
            DataClassification = ToBeClassified;
        }
    }


    trigger OnBeforeInsert()
    begin
        "User ID" := UserId;
        Date := today;
        "Comment Time" := time;
    end;


    trigger OnBeforeModify()
    begin
        "User ID" := UserId;
        Date := today;
        "Comment Time" := time;
    end;
}