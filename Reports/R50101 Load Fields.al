report 50101 "Load Fields"
{
    ApplicationArea = All;
    Caption = 'Load Fields';
    UsageCategory = Administration;
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem(Field; "Field")
        {
            trigger OnPreDataItem()
            begin
                Field2.deleteall;
            end;


            trigger OnAfterGetRecord()
            begin
                Field2.init;
                Field2."Table No." := TableNo;
                Field2."No." := "No.";
                Field2."Table Name" := TableName;
                Field2."Field Name" := FieldName;
                //Field2.Type := Type;
                case Type OF
                    Field.Type::TableFilter:
                        begin
                            Field2.Type := Field2.Type::TableFilter;
                        end;
                    Field.Type::RecordID:
                        begin
                            Field2.Type := Field2.Type::RecordID;
                        end;
                    Field.Type::OemText:
                        begin
                            Field2.Type := Field2.Type::OemText;
                        end;
                    Field.Type::Date:
                        begin
                            Field2.Type := Field2.Type::Date;
                        end;
                    Field.Type::Time:
                        begin
                            Field2.Type := Field2.Type::Time;
                        end;
                    Field.Type::DateFormula:
                        begin
                            Field2.Type := Field2.Type::DateFormula;
                        end;
                    Field.Type::Decimal:
                        begin
                            Field2.Type := Field2.Type::Decimal;
                        end;
                    Field.Type::Media:
                        begin
                            Field2.Type := Field2.Type::Media;
                        end;
                    Field.Type::MediaSet:
                        begin
                            Field2.Type := Field2.Type::MediaSet;
                        end;
                    Field.Type::Text:
                        begin
                            Field2.Type := Field2.Type::Text;
                        end;
                    Field.Type::Code:
                        begin
                            Field2.Type := Field2.Type::Code;
                        end;
                    Field.Type::Binary:
                        begin
                            Field2.Type := Field2.Type::Binary;
                        end;
                    Field.Type::BLOB:
                        begin
                            Field2.Type := Field2.Type::BLOB;
                        end;
                    Field.Type::Boolean:
                        begin
                            Field2.Type := Field2.Type::Boolean;
                        end;
                    Field.Type::Integer:
                        begin
                            Field2.Type := Field2.Type::Integer;
                        end;
                    Field.Type::OemCode:
                        begin
                            Field2.Type := Field2.Type::OemCode;
                        end;
                    Field.Type::Option:
                        begin
                            Field2.Type := Field2.Type::Option;
                        end;
                    Field.Type::BigInteger:
                        begin
                            Field2.Type := Field2.Type::BigInteger;
                        end;
                    Field.Type::Duration:
                        begin
                            Field2.Type := Field2.Type::Duration;
                        end;
                    Field.Type::GUID:
                        begin
                            Field2.Type := Field2.Type::GUID;
                        end;
                    Field.Type::DateTime:
                        begin
                            Field2.Type := Field2.Type::DateTime;
                        end;
                end;
                Field2.Length := Len;
                Field2.Class := Class;
                Field2.Enabled := Enabled;
                Field2."Type Name" := "Type Name";
                Field2."Field Caption" := "Field Caption";
                Field2."Relation Table No." := RelationTableNo;
                Field2."Relation Field No." := RelationFieldNo;
                Field2."SQL Data Type" := SQLDataType;
                Field2."Option String" := OptionString;
                Field2."Obsolete State" := ObsoleteState;
                Field2."Obsolete Reason" := ObsoleteReason;
                Field2."Data Classification" := DataClassification;
                Field2."Is Part Of Primary Key" := IsPartOfPrimaryKey;
                Field2."App Package ID" := "App Package ID";
                Field2."App Runtime Package ID" := "App Runtime Package ID";
                Field2.insert;
            end;
        }
    }


    var
        Field2: record "Fields 2";


    trigger OnPostReport()
    begin
        //message('Done');
        page.run(50133);
    end;
}
//OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
// This list must stay in sync with NCLOptionMetadataNavTypeField
//OptionOrdinalValues = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
