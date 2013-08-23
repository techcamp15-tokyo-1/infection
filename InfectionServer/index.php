<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Infection テストページ</title>
    </head>
    <body>
        <h1>ウィルス拡散開始</h1>
        <form action="spread.php" method="post">
            <p>virus_id</p>
            <input type="text" name="virus_id" />
            <input type="submit"/>
        </form>
        <h1>ウィルス感染</h1>
        <form action="infected.php" method="post">
            <p>virus_id</p>
            <input type="text" name="virus_id" />
            <input type="submit"/>
        </form>
        <h1>ウィルス復帰</h1>
        <form action="recovered.php" method="post">
            <p>virus_id</p>
            <input type="text" name="virus_id" />
            <input type="submit"/>
        </form>
        <h1>ウィルス拡散状況</h1>
        <form action="state.php" method="post">
            <p>virus_id</p>
            <input type="text" name="virus_id" />
            <input type="submit"/>
        </form>
    </body>
</html>
