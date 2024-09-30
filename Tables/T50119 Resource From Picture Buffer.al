table 50119 "Resource From Picture Buffer"
{
    TableType = Temporary;

    fields
    {
        field(1; PrimaryKey; Integer)
        {
            AutoIncrement = true;
        }
        field(10; ResMediaSet; MediaSet)
        {
        }
        field(11; ResMediaFileName; Text[260])
        {
        }
        field(20; ResTemplateCode; Code[20])
        {
        }
        field(25; ResCategoryCode; Code[20])
        {
        }
        field(30; ResDescription; Text[100])
        {
        }
        field(100; AnalysisResult; Blob)
        {
        }
        field(101; AnalysisResultPreview; Text[2048])
        {
        }
    }


    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }


    procedure SetResult(Result: Text)
    var
        ResultOutStream: OutStream;
    begin
        Clear(Rec.AnalysisResult);
        Rec.AnalysisResult.CreateOutStream(ResultOutStream);
        ResultOutStream.WriteText(Result);

        Rec.Validate(AnalysisResultPreview, CopyStr(Result, 1, MaxStrLen(Rec.AnalysisResultPreview)));
    end;
}